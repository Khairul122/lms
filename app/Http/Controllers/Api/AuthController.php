<?php

namespace App\Http\Controllers\Api;

use App\Actions\Auth\LoginUserAction;
use App\Actions\Auth\RegisterUserAction;
use App\Actions\Auth\UpdateProfileAction;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Exception;

class AuthController extends Controller
{
    public function login(Request $request, LoginUserAction $action)
    {
        $request->validate([
            'email'    => 'required|email',
            'password' => 'required',
        ]);

        try {
            $result = $action->execute($request->email, $request->password);
        } catch (Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], $e->getCode() ?: 401);
        }

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil.',
            'token'   => $result['token'],
            'user'    => $result['user'],
        ]);
    }

    public function register(Request $request, RegisterUserAction $action)
    {
        $validator = Validator::make($request->all(), [
            'name'            => 'required|string|max:255',
            'email'           => 'required|email|unique:users,email',
            'password'        => 'required|min:6',
            'role'            => 'required',
            'nip'             => 'nullable',
            'phone'           => 'nullable',
            'ttl'             => 'nullable',
            'jenis_kelamin'   => 'nullable',
            'mata_pelajaran'  => 'nullable',
            'sekolah_asal'    => 'nullable',
            'alamat'          => 'nullable',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors'  => $validator->errors(),
            ], 422);
        }

        $user = $action->execute($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Register berhasil',
            'user'    => $user,
        ]);
    }

    public function profile(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'success' => true,
            'data'    => [
                'id'             => $user->id,
                'name'           => $user->name,
                'email'          => $user->email,
                'phone'          => $user->phone,
                'role'           => $user->role,
                'nip'            => $user->nip,
                'ttl'            => $user->ttl,
                'jenis_kelamin'  => $user->jenis_kelamin,
                'mata_pelajaran' => $user->mata_pelajaran,
                'sekolah_asal'   => $user->sekolah_asal,
                'alamat'         => $user->alamat,
                'photo'          => $user->photo,
            ],
        ]);
    }

    public function updateProfile(Request $request, UpdateProfileAction $action)
    {
        $user = $action->execute($request->user(), $request->all());

        return response()->json([
            'success' => true,
            'message' => 'Profil berhasil diperbarui.',
            'user'    => $user,
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
