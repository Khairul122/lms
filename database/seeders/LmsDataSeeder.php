<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\ClassRoom;
use App\Models\Meeting;
use App\Models\Task;
use App\Models\Discussion;
use App\Models\Notification;
use App\Models\Material;

class LmsDataSeeder extends Seeder
{
    public function run(): void
    {
        $guru = User::where('role', 'guru')->first() ?? User::where('email', 'guru@gmail.com')->first();
        $siswaList = User::where('role', 'siswa')->get();

        if (!$guru) {
            return;
        }

        // 1. Seed Classes
        $classes = [
            [
                'class_code' => 'MTK-10A',
                'class_name' => 'Matematika XI IPA 1',
                'subject'    => 'Matematika Aljabar & Kalkulus',
                'description'=> 'Kelas pembelajaran konsep matematika tingkat lanjut.',
                'is_active'  => 1,
            ],
            [
                'class_code' => 'FIS-11B',
                'class_name' => 'Fisika Kuantum & Mekanika',
                'subject'    => 'Fisika Terapan',
                'description'=> 'Diskusi dan eksperimen mekanika fluida dan fisika modern.',
                'is_active'  => 1,
            ],
            [
                'class_code' => 'PEM-12C',
                'class_name' => 'Pemrograman Web Fullstack',
                'subject'    => 'Informatika & Software Engineering',
                'description'=> 'Pembuatan aplikasi web modern dengan Laravel REST API & Flutter.',
                'is_active'  => 1,
            ],
        ];

        foreach ($classes as $classData) {
            $class = ClassRoom::updateOrCreate(
                ['class_code' => $classData['class_code']],
                array_merge($classData, ['teacher_id' => $guru->id])
            );

            // Attach students if relationship exists
            if ($siswaList->isNotEmpty() && method_exists($class, 'students')) {
                $class->students()->syncWithoutDetaching($siswaList->pluck('id')->toArray());
            }

            // 2. Seed Meetings for each class
            for ($i = 1; $i <= 3; $i++) {
                $meeting = Meeting::updateOrCreate(
                    [
                        'class_id'  => $class->id,
                        'pertemuan' => $i,
                    ],
                    [
                        'nama_pertemuan' => "Pertemuan $i: Konsep Dasar dan Praktikum Bab $i",
                        'tema_pertemuan' => "Pemahaman Modul $i dan Penerapan Studi Kasus",
                    ]
                );

                // 3. Seed Task for Meeting 1 & 2
                if ($i <= 2) {
                    $task = Task::updateOrCreate(
                        [
                            'class_id'   => $class->id,
                            'meeting_id' => $meeting->id,
                            'title'      => "Tugas Mandiri Pertemuan $i",
                        ],
                        [
                            'description'=> "Kerjakan latihan modul $i dan upload file laporan dalam format PDF.",
                            'deadline'   => now()->addDays(7),
                            'max_score'  => 100,
                            'is_active'  => 1,
                        ]
                    );
                }

                // 4. Seed Discussion
                if ($siswaList->isNotEmpty()) {
                    $randomStudent = $siswaList->random();
                    Discussion::create([
                        'class_id'   => $class->id,
                        'user_id'    => $randomStudent->id,
                        'meeting_id' => $meeting->id,
                        'message'    => "Halo Pak/Bu Guru, mohon penjelasan untuk materi pada modul Pertemuan $i halaman 15.",
                    ]);
                }
            }
        }

        // 5. Seed Notifications
        if ($siswaList->isNotEmpty()) {
            foreach ($siswaList->take(3) as $student) {
                Notification::create([
                    'receiver_id' => $student->id,
                    'class_id'    => ClassRoom::first()?->id,
                    'title'       => 'Tugas Baru Telah Diterbitkan',
                    'message'     => 'Guru telah mengunggah Tugas Mandiri Pertemuan 1. Silakan periksa deadline.',
                    'type'        => 'tugas',
                    'is_read'     => false,
                ]);
            }
        }
    }
}
