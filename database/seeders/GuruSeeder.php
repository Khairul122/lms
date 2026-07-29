<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class GuruSeeder extends Seeder
{
    public function run(): void
    {
        $gurus = [
            [
                'email' => 'guru@gmail.com',
                'name' => 'Guru Demo S.Pd',
                'username' => 'guru',
                'password' => Hash::make('guru123'),
                'role' => 'guru',
                'nip' => '198501012010011001',
                'phone' => '081234567890',
                'mata_pelajaran' => 'Matematika & Informatika',
                'sekolah_asal' => 'SMA Negeri 1 Jakarta',
            ],
            [
                'email' => 'budi@gmail.com',
                'name' => 'Pak Budi Santoso M.Pd',
                'username' => 'budi',
                'password' => Hash::make('guru123'),
                'role' => 'guru',
                'nip' => '198703152012021003',
                'phone' => '081298765432',
                'mata_pelajaran' => 'Fisika Terapan',
                'sekolah_asal' => 'SMA Negeri 1 Jakarta',
            ],
            [
                'email' => 'siti@gmail.com',
                'name' => 'Ibu Siti Rahma S.Si',
                'username' => 'siti',
                'password' => Hash::make('guru123'),
                'role' => 'guru',
                'nip' => '199008202015032005',
                'phone' => '081311223344',
                'mata_pelajaran' => 'Bahasa Inggris & Literatur',
                'sekolah_asal' => 'SMA Negeri 1 Jakarta',
            ],
        ];

        foreach ($gurus as $guruData) {
            $user = User::updateOrCreate(
                ['email' => $guruData['email']],
                $guruData
            );
            
            if (method_exists($user, 'assignRole')) {
                $user->assignRole('guru');
            }
        }
    }
}
