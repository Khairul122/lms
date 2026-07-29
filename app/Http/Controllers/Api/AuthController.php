<?php

namespace App\Http\Controllers\Api;

use App\Actions\Auth\ChangePasswordAction;
use App\Actions\Auth\ForgotPasswordAction;
use App\Actions\Auth\LoginUserAction;
use App\Actions\Auth\RegisterUserAction;
use App\Actions\Auth\ResetPasswordAction;
use App\Actions\Auth\UpdateProfileAction;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Tymon\JWTAuth\Facades\JWTAuth;
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

        $token = JWTAuth::fromUser($user);

        return response()->json([
            'success' => true,
            'message' => 'Register berhasil',
            'user'    => $user,
            'token'   => $token,
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
                'photo'          => $user->photo_url ?? $user->photo,
            ],
        ]);
    }

    public function updateProfile(Request $request, UpdateProfileAction $action)
    {
        $user = $action->execute($request->user(), $request->all());

        $userData = $user->toArray();
        $userData['photo'] = $user->photo_url ?? $user->photo;

        return response()->json([
            'success' => true,
            'message' => 'Profil berhasil diperbarui.',
            'user'    => $userData,
        ]);
    }

    public function logout(Request $request)
    {
        JWTAuth::invalidate(JWTAuth::getToken());

        return response()->json([
            'success' => true,
            'message' => 'Logout berhasil.',
        ]);
    }

    public function forgotPassword(Request $request, ForgotPasswordAction $action)
    {
        $request->validate([
            'email' => 'required|email',
        ]);

        try {
            $action->execute($request->email);
        } catch (Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], $e->getCode() ?: 400);
        }

        return response()->json([
            'success' => true,
            'message' => 'Tautan reset password telah dikirim ke email.',
        ]);
    }

    public function resetPassword(Request $request, ResetPasswordAction $action)
    {
        $request->validate([
            'email'    => 'required|email',
            'token'    => 'required|string',
            'password' => 'required|min:6',
        ]);

        try {
            $action->execute($request->email, $request->token, $request->password);
        } catch (Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], $e->getCode() ?: 400);
        }

        return response()->json([
            'success' => true,
            'message' => 'Password berhasil direset.',
        ]);
    }

    public function changePassword(Request $request, ChangePasswordAction $action)
    {
        $request->validate([
            'current_password' => 'required',
            'new_password'      => 'required|min:6',
        ]);

        try {
            $action->execute($request->user(), $request->current_password, $request->new_password);
        } catch (Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], $e->getCode() ?: 422);
        }

        return response()->json([
            'success' => true,
            'message' => 'Password berhasil diubah.',
        ]);
    }
}
