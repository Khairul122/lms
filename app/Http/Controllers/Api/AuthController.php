<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {

            return response()->json([
                'success' => false,
                'message' => 'Email atau password salah.'
            ], 401);
        }

        $user->tokens()->delete();

        $token = $user->createToken('edusmart-mobile')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil.',
            'token' => $token,
            'user' => $user,
        ]);
    }

    public function register(Request $request)
{
    $validator = Validator::make($request->all(), [

    'name' => 'required|string|max:255',

    'email' => 'required|email|unique:users,email',

    'password' => 'required|min:6',

    'role' => 'required',

    'nip' => 'nullable',

    'phone' => 'nullable',

    'ttl' => 'nullable',

    'jenis_kelamin' => 'nullable',

    'mata_pelajaran' => 'nullable',

    'sekolah_asal' => 'nullable',

    'alamat' => 'nullable',

]);

    if ($validator->fails()) {

        return response()->json([
            'success' => false,
            'errors' => $validator->errors()
        ],422);

    }

    $user = User::create([

        'name' => $request->name,

        'email' => $request->email,

        'password' => Hash::make($request->password),

        'role' => $request->role,

        'nip' => $request->nip,

        'phone' => $request->phone,

        'ttl' => $request->ttl,

        'jenis_kelamin' => $request->jenis_kelamin,

        'mata_pelajaran' => $request->mata_pelajaran,

        'sekolah_asal' => $request->sekolah_asal,

        'alamat' => $request->alamat,

        'photo' => null,

    ]);

    return response()->json([

        'success' => true,

        'message' => 'Register berhasil',

        'user' => $user,

    ]);
}

public function profile(Request $request)
{
    $user = $request->user();

return response()->json([
    'success' => true,

    'data' => [

        'id' => $user->id,
        'name' => $user->name,
        'email' => $user->email,
        'phone' => $user->phone,
        'role' => $user->role,
        'nip' => $user->nip,
        'ttl' => $user->ttl,
        'jenis_kelamin' => $user->jenis_kelamin,
        'mata_pelajaran' => $user->mata_pelajaran,
        'sekolah_asal' => $user->sekolah_asal,
        'alamat' => $user->alamat,
        'photo' => $user->photo,
    ]
]);
}
public function updateProfile(Request $request)
{
    $user = $request->user();

    $user->update([

        'name' => $request->name ?? $user->name,

        'phone' => $request->phone,

        'nip' => $request->nip,

        'ttl' => $request->ttl,

        'jenis_kelamin' => $request->jenis_kelamin,

        'mata_pelajaran' => $request->mata_pelajaran,

        'sekolah_asal' => $request->sekolah_asal,

        'alamat' => $request->alamat,

        'photo' => $request->photo,

    ]);

    return response()->json([

        "success" => true,

        "message" => "Profil berhasil diperbarui.",

        "user" => $user->fresh(),

    ]);
}

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logout berhasil.',
        ]);
    }
}