<?php

namespace App\Actions\Auth;

use App\Models\User;
use Exception;
use Illuminate\Support\Facades\Hash;
use Tymon\JWTAuth\Facades\JWTAuth;

class LoginUserAction
{
    /**
     * @return array{user:User,token:string}
     */
    public function execute(string $email, string $password): array
    {
        $user = User::where('email', $email)->first();

        if (!$user || !Hash::check($password, $user->password)) {
            throw new Exception('Email atau password salah.', 401);
        }

        $token = JWTAuth::fromUser($user);

        return ['user' => $user, 'token' => $token];
    }
}
