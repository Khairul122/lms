<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;

class FirebaseLoginController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Akun belum terdaftar pada LMS.'
            ], 404);
        }

        // Hapus token lama (opsional)
        $user->tokens()->delete();

        // Buat Sanctum Token baru
        $token = $user->createToken('firebase-login')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil.',
            'token' => $token,
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->role,
                'nip' => $user->nip,
                'nisn' => $user->nisn,
                'phone' => $user->phone,
                'photo' => $user->photo,
            ],
        ]);
    }
}