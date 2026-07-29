<?php

namespace App\Actions\Auth;

use App\Models\User;
use Exception;

class FirebaseLoginAction
{
    /**
     * @return array{user:User,token:string}
     */
    public function execute(string $email): array
    {
        $user = User::where('email', $email)->first();

        if (!$user) {
            throw new Exception('Akun belum terdaftar pada LMS.', 404);
        }

        $user->tokens()->delete();

        $token = $user->createToken('firebase-login')->plainTextToken;

        return ['user' => $user, 'token' => $token];
    }
}
