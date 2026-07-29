<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class SiswaSeeder extends Seeder
{
    public function run(): void
    {
        $siswas = [
            [
                'email' => 'siswa@gmail.com',
                'name' => 'Siswa Demo',
                'username' => 'siswa',
                'password' => Hash::make('siswa123'),
                'role' => 'siswa',
                'nisn' => '0051234567',
                'phone' => '085711223344',
                'sekolah_asal' => 'SMA Negeri 1 Jakarta',
            ],
            [
                'email' => 'ahmad@gmail.com',
                'name' => 'Ahmad Rizky Pratama',
                'username' => 'ahmad',
                'password' => Hash::make('siswa123'),
                'role' => 'siswa',
                'nisn' => '0051234568',
                'phone' => '085711223345',
                'sekolah_asal' => 'SMA Negeri 1 Jakarta',
            ],
            [
                'email' => 'citra@gmail.com',
                'name' => 'Citra Lestari',
                'username' => 'citra',
                'password' => Hash::make('siswa123'),
                'role' => 'siswa',
                'nisn' => '0051234569',
                'phone' => '085711223346',
                'sekolah_asal' => 'SMA Negeri 1 Jakarta',
            ],
            [
                'email' => 'dewi@gmail.com',
                'name' => 'Dewi Anggraini',
                'username' => 'dewi',
                'password' => Hash::make('siswa123'),
                'role' => 'siswa',
                'nisn' => '0051234570',
                'phone' => '085711223347',
                'sekolah_asal' => 'SMA Negeri 1 Jakarta',
            ],
            [
                'email' => 'eko@gmail.com',
                'name' => 'Eko Prasetyo',
                'username' => 'eko',
                'password' => Hash::make('siswa123'),
                'role' => 'siswa',
                'nisn' => '0051234571',
                'phone' => '085711223348',
                'sekolah_asal' => 'SMA Negeri 1 Jakarta',
            ],
        ];

        foreach ($siswas as $siswaData) {
            $user = User::updateOrCreate(
                ['email' => $siswaData['email']],
                $siswaData
            );

            if (method_exists($user, 'assignRole')) {
                $user->assignRole('siswa');
            }
        }
    }
}
