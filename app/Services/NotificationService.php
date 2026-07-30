<?php

namespace App\Services;

use App\Models\ClassRoom;
use App\Models\Notification;

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
}
