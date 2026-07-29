<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class SiswaSeeder extends Seeder
{
    public function run(): void
    {
        User::updateOrCreate(
            ['email' => 'siswa@gmail.com'],
            [
                'name' => 'Siswa Demo',
                'username' => 'siswa',
                'password' => Hash::make('siswa123'),
                'role' => 'siswa',
                'nisn' => '0051234567',
            ]
        );
    }
}
