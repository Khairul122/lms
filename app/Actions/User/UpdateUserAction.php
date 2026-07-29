<?php

namespace App\Actions\User;

use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UpdateUserAction
{
    /**
     * @param array{name:string,username:?string,email:string,role:?string,nisn:?string,nip:?string,phone:?string,gender:?string,birth_date:?string,photo:?string,password:?string} $data
     */
    public function execute(User $user, array $data): User
    {
        $user->name       = $data['name'];
        $user->username   = $data['username'] ?? $user->username;
        $user->email      = $data['email'];
        $user->nisn       = $data['nisn'] ?? $user->nisn;
        $user->nip        = $data['nip'] ?? $user->nip;
        $user->phone      = $data['phone'] ?? $user->phone;
        $user->gender     = $data['gender'] ?? $user->gender;
        $user->birth_date = $data['birth_date'] ?? $user->birth_date;

        if (array_key_exists('role', $data) && $data['role'] !== null) {
            $user->role = $data['role'];
        }

        if (array_key_exists('photo', $data) && $data['photo'] !== null) {
            $user->photo = $data['photo'];
        }

        if (!empty($data['password'])) {
            $user->password = Hash::make($data['password']);
        }

        $user->save();

        return $user;
    }
}
