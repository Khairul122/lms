<?php

namespace App\Actions\Auth;

use App\Models\User;
use Illuminate\Support\Facades\Hash;

class RegisterUserAction
{
    public function execute(array $data): User
    {
        return User::create([
            'name'            => $data['name'],
            'email'           => $data['email'],
            'password'        => Hash::make($data['password']),
            'role'            => $data['role'],
            'nip'             => $data['nip'] ?? null,
            'phone'           => $data['phone'] ?? null,
            'ttl'             => $data['ttl'] ?? null,
            'jenis_kelamin'   => $data['jenis_kelamin'] ?? null,
            'mata_pelajaran'  => $data['mata_pelajaran'] ?? null,
            'sekolah_asal'    => $data['sekolah_asal'] ?? null,
            'alamat'          => $data['alamat'] ?? null,
            'photo'           => null,
        ]);
    }
}
