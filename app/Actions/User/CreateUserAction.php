<?php

namespace App\Actions\User;

use App\Models\User;
use Illuminate\Support\Facades\Hash;

class CreateUserAction
{
    /**
     * @param array{name:string,username:?string,email:string,password:string,role:string,nisn:?string,nip:?string,phone:?string,gender:?string,birth_date:?string,photo:?string,assign_spatie_role:?bool} $data
     */
    public function execute(array $data): User
    {
        $user = User::create([
            'name'       => $data['name'],
            'username'   => $data['username'] ?? null,
            'email'      => $data['email'],
            'password'   => Hash::make($data['password']),
            'role'       => $data['role'],
            'nisn'       => $data['nisn'] ?? null,
            'nip'        => $data['nip'] ?? null,
            'phone'      => $data['phone'] ?? null,
            'gender'     => $data['gender'] ?? null,
            'birth_date' => $data['birth_date'] ?? null,
            'photo'      => $data['photo'] ?? null,
        ]);

        if (!empty($data['assign_spatie_role']) && method_exists($user, 'assignRole')) {
            $user->assignRole($data['role']);
        }

        return $user;
    }
}
