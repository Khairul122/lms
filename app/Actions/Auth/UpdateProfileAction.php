<?php

namespace App\Actions\Auth;

use App\Models\User;

class UpdateProfileAction
{
    public function execute(User $user, array $data): User
    {
        $user->update([
            'name'           => $data['name'] ?? $user->name,
            'phone'          => $data['phone'] ?? null,
            'nip'            => $data['nip'] ?? null,
            'ttl'            => $data['ttl'] ?? null,
            'jenis_kelamin'  => $data['jenis_kelamin'] ?? null,
            'mata_pelajaran' => $data['mata_pelajaran'] ?? null,
            'sekolah_asal'   => $data['sekolah_asal'] ?? null,
            'alamat'         => $data['alamat'] ?? null,
            'photo'          => $data['photo'] ?? null,
        ]);

        return $user->fresh();
    }
}
