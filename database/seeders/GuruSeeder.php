<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class GuruSeeder extends Seeder
{
    public function run(): void
    {
        User::updateOrCreate(
            ['email' => 'guru@gmail.com'],
            [
                'name' => 'Guru Demo',
                'username' => 'guru',
                'password' => Hash::make('guru123'),
                'role' => 'guru',
                'nip' => '198501012010011001',
            ]
        );
    }
}
