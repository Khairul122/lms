<?php

namespace App\Services;

use App\Models\ClassRoom;
use App\Models\Notification;
use App\Models\User;

class NotificationService
{
    /**
     * Notifikasi ke seluruh anggota kelas (guru + murid), masing-masing
     * mendapat baris tersendiri supaya status "sudah dibaca" per-orang akurat
     * dan tidak bocor ke user di kelas lain.
     * $excludeUserId dipakai supaya pengirim/pembuat tidak menerima notifikasi
     * atas aksinya sendiri.
     */
    public function notifyClass(int $classId, string $title, string $message, string $type, ?int $excludeUserId = null): void
    {
        $class = ClassRoom::with('students')->find($classId);

        if (!$class) {
            return;
        }

        $recipientIds = collect();

        if ($class->teacher_id) {
            $recipientIds->push($class->teacher_id);
        }

        $recipientIds = $recipientIds->merge($class->students->pluck('id'));
        $recipientIds = $recipientIds->filter(fn ($id) => $id !== null)->unique();

        if ($excludeUserId !== null) {
            $recipientIds = $recipientIds->reject(fn ($id) => (int) $id === (int) $excludeUserId);
        }

        if ($recipientIds->isEmpty()) {
            return;
        }

        $now = now();
        $rows = $recipientIds->map(fn ($id) => [
            'receiver_id' => $id,
            'class_id'    => $classId,
            'title'       => $title,
            'message'     => $message,
            'type'        => $type,
            'is_read'     => false,
            'created_at'  => $now,
            'updated_at'  => $now,
        ])->values()->all();

        Notification::insert($rows);
    }

    /**
     * Notifikasi ke satu user spesifik (mis. nilai keluar, tugas dikumpulkan).
     */
    public function notifyUser(int $userId, string $title, string $message, string $type, ?int $classId = null): void
    {
        Notification::create([
            'receiver_id' => $userId,
            'class_id'    => $classId,
            'title'       => $title,
            'message'     => $message,
            'type'        => $type,
            'is_read'     => false,
        ]);
    }

    public function listAll()
    {
        $user = auth()->user();

        if (!$user) {
            return collect();
        }

        // Kelas yang relevan untuk user ini (sebagai guru pengajar atau murid terdaftar).
        // Dipakai untuk membatasi baris broadcast lama (receiver_id null, jika ada)
        // supaya tidak bocor ke user di kelas lain.
        $classIds = ClassRoom::where('teacher_id', $user->id)
            ->orWhereHas('students', fn ($q) => $q->where('users.id', $user->id))
            ->pluck('id');

        return Notification::with(['receiver', 'classroom'])
            ->where(function ($query) use ($user, $classIds) {
                $query->where('receiver_id', $user->id)
                    ->orWhere(function ($q) use ($classIds) {
                        $q->whereNull('receiver_id')
                            ->where(function ($q2) use ($classIds) {
                                $q2->whereNull('class_id')
                                    ->orWhereIn('class_id', $classIds);
                            });
                    });
            })
            ->latest()
            ->get();
    }

    public function paginateForAdmin(int $perPage = 10)
    {
        return Notification::with('receiver')
            ->latest()
            ->paginate($perPage);
    }

    /**
     * Kirim notifikasi pembuatan kelas (untuk guru pembuat dan semua siswa)
     */
    public function notifyClassCreated(ClassRoom $class): void
    {
        $now = now();
        $notifications = [];

        // Pastikan relasi teacher dimuat
        if (!$class->relationLoaded('teacher')) {
            $class->load('teacher');
        }

        // 1. Notifikasi untuk guru pembuat kelas
        if ($class->teacher_id) {
            $notifications[] = [
                'receiver_id' => $class->teacher_id,
                'class_id'    => $class->id,
                'title'       => 'Kelas Berhasil Dibuat',
                'message'     => "Kelas {$class->class_name} telah berhasil dibuat dengan kode kelas {$class->class_code}.",
                'type'        => 'kelas',
                'is_read'     => false,
                'created_at'  => $now,
                'updated_at'  => $now,
            ];
        }

        // 2. Notifikasi untuk seluruh siswa terdaftar
        $students = User::where('role', 'siswa')->get();
        foreach ($students as $student) {
            $notifications[] = [
                'receiver_id' => $student->id,
                'class_id'    => $class->id,
                'title'       => 'Kelas Baru Tersedia',
                'message'     => "Kelas {$class->class_name} oleh " . ($class->teacher?->name ?? 'Guru') . " telah ditambahkan. Silakan bergabung menggunakan kode: {$class->class_code}",
                'type'        => 'kelas',
                'is_read'     => false,
                'created_at'  => $now,
                'updated_at'  => $now,
            ];
        }

        if (count($notifications) > 0) {
            Notification::insert($notifications);
        }
    }
}
