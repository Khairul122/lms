<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\ClassRoom;
use App\Models\Meeting;
use App\Models\Task;
use App\Models\Material;
use App\Models\Submission;
use App\Models\Discussion;
use App\Models\Notification;

class LmsDataSeeder extends Seeder
{
    public function run(): void
    {
        $guruMain = User::where('email', 'guru@gmail.com')->first();
        $guruBudi = User::where('email', 'budi@gmail.com')->first() ?? $guruMain;
        $guruSiti = User::where('email', 'siti@gmail.com')->first() ?? $guruMain;

        $siswaList = User::where('role', 'siswa')->get();

        if (!$guruMain) {
            return;
        }

        // 1. Seed Classes
        $classes = [
            [
                'class_code'  => 'MTK-10A',
                'class_name'  => 'Matematika XI IPA 1',
                'subject'     => 'Matematika Aljabar & Kalkulus',
                'teacher_id'  => $guruMain->id,
                'description' => 'Kelas pembelajaran konsep matematika tingkat lanjut, persamaan kuadrat, dan kalkulus diferensial.',
                'is_active'   => 1,
            ],
            [
                'class_code'  => 'PEM-12C',
                'class_name'  => 'Pemrograman Web & Mobile',
                'subject'     => 'Informatika & Software Engineering',
                'teacher_id'  => $guruMain->id,
                'description' => 'Pembuatan aplikasi web modern dengan Laravel REST API & Mobile Flutter App.',
                'is_active'   => 1,
            ],
            [
                'class_code'  => 'FIS-11B',
                'class_name'  => 'Fisika Kuantum & Mekanika',
                'subject'     => 'Fisika Terapan',
                'teacher_id'  => $guruBudi->id,
                'description' => 'Diskusi dan eksperimen mekanika fluida, gerak harmonis, dan fisika modern.',
                'is_active'   => 1,
            ],
            [
                'class_code'  => 'BIG-10A',
                'class_name'  => 'Bahasa Inggris Komunikasi',
                'subject'     => 'Bahasa Inggris',
                'teacher_id'  => $guruSiti->id,
                'description' => 'Pengembangan kemampuan tata bahasa, percakapan sehari-hari, dan penulisan esai.',
                'is_active'   => 1,
            ],
        ];

        foreach ($classes as $classData) {
            $class = ClassRoom::updateOrCreate(
                ['class_code' => $classData['class_code']],
                $classData
            );

            // Hubungkan semua siswa ke kelas
            if ($siswaList->isNotEmpty() && method_exists($class, 'students')) {
                $class->students()->syncWithoutDetaching($siswaList->pluck('id')->toArray());
            }

            // 2. Seed Pertemuan (Meetings)
            for ($i = 1; $i <= 3; $i++) {
                $meeting = Meeting::updateOrCreate(
                    [
                        'class_id'  => $class->id,
                        'pertemuan' => $i,
                    ],
                    [
                        'nama_pertemuan' => "Pertemuan $i: Modul Pembahasan Bab $i",
                        'tema_pertemuan' => "Pendalaman Konsep dan Studi Kasus Modul Ke-$i",
                    ]
                );

                // 3. Seed Materi (Materials)
                Material::updateOrCreate(
                    [
                        'class_id'   => $class->id,
                        'meeting_id' => $meeting->id,
                        'pertemuan'  => $i,
                        'title'      => "Modul Pembelajaran Pertemuan $i (PDF)",
                    ],
                    [
                        'description' => "Unduh dan pelajari slide presentasi serta rangkuman materi pertemuan ke-$i.",
                        'file_url'    => "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
                        'youtube_url' => "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                    ]
                );

                // 4. Seed Tugas (Tasks)
                $task = Task::updateOrCreate(
                    [
                        'class_id'   => $class->id,
                        'meeting_id' => $meeting->id,
                        'title'      => "Tugas Mandiri Pertemuan $i",
                    ],
                    [
                        'description' => "Kerjakan soal latihan pada modul pertemuan $i. Unggah jawaban dalam bentuk PDF.",
                        'deadline'    => now()->addDays(7),
                        'max_score'   => 100,
                        'is_active'   => 1,
                    ]
                );

                // 5. Seed Submissions (Pengumpulan Tugas Siswa & Penilaian)
                if ($siswaList->isNotEmpty()) {
                    foreach ($siswaList as $index => $student) {
                        $isGraded = ($index % 2 == 0); // Selang-seling dinilai dan belum dinilai
                        Submission::updateOrCreate(
                            [
                                'task_id' => $task->id,
                                'user_id' => $student->id,
                            ],
                            [
                                'file_path'    => "submissions/tugas_{$task->id}_siswa_{$student->id}.pdf",
                                'note'         => "Berikut hasil pengerjaan tugas saya Pak/Bu Guru. Terima kasih.",
                                'score'        => $isGraded ? rand(80, 98) : null,
                                'teacher_note' => $isGraded ? "Hasil kerja sangat baik, pertahankan prestasimu!" : null,
                                'submitted_at' => now()->subDays(rand(1, 3)),
                            ]
                        );
                    }
                }

                // 6. Seed Diskusi (Discussions)
                if ($siswaList->isNotEmpty()) {
                    $randomStudent = $siswaList->random();
                    Discussion::create([
                        'class_id'   => $class->id,
                        'user_id'    => $randomStudent->id,
                        'meeting_id' => $meeting->id,
                        'message'    => "Halo Pak/Bu Guru, saya ingin bertanya terkait penjelasan rumus pada halaman " . ($i * 12) . ".",
                    ]);

                    Discussion::create([
                        'class_id'   => $class->id,
                        'user_id'    => $class->teacher_id,
                        'meeting_id' => $meeting->id,
                        'message'    => "Halo @{$randomStudent->name}, silakan periksa kembali bagian contoh soal pada slide ke-5 ya.",
                    ]);
                }
            }
        }

        // 7. Seed Notifications
        if ($siswaList->isNotEmpty()) {
            foreach ($siswaList as $student) {
                Notification::create([
                    'receiver_id' => $student->id,
                    'class_id'    => ClassRoom::first()?->id,
                    'title'       => 'Tugas Baru Diterbitkan',
                    'message'     => 'Guru telah mengunggah Tugas Mandiri Pertemuan 1. Jangan lupa cek deadline!',
                    'type'        => 'tugas',
                    'is_read'     => false,
                ]);

                Notification::create([
                    'receiver_id' => $student->id,
                    'class_id'    => ClassRoom::first()?->id,
                    'title'       => 'Nilai Tugas Telah Diberikan',
                    'message'     => 'Nilai tugas pertemuan 1 Anda telah diperbarui oleh Guru.',
                    'type'        => 'penilaian',
                    'is_read'     => true,
                ]);
            }
        }
    }
}
