<?php

namespace App\Http\Controllers\Api;

use App\Actions\Auth\FirebaseLoginAction;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Exception;

class FirebaseLoginController extends Controller
{
    public function login(Request $request, FirebaseLoginAction $action)
    {
        $request->validate([
            'email' => 'required|email',
        ]);

        try {
            $result = $action->execute($request->email);
        } catch (Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], $e->getCode() ?: 404);
        }

        $user = $result['user'];

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil.',
            'token'   => $result['token'],
            'user'    => [
                'id'     => $user->id,
                'name'   => $user->name,
                'email'  => $user->email,
                'role'   => $user->role,
                'nip'    => $user->nip,
                'nisn'   => $user->nisn,
                'phone'  => $user->phone,
                'photo'  => $user->photo,
            ],
        ]);
    }
}
