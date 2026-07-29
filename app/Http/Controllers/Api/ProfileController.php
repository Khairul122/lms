<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function profile(Request $request)
    {
        // 1. Ambil user berdasarkan email jika dikirim, atau dari Token Auth
        if ($request->has('email') && !empty($request->email)) {
            $request->validate(['email' => 'required|email']);
            $user = User::where('email', $request->email)->first();
        } else {
            $user = $request->user();
        }

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User tidak ditemukan.'
            ], 404);
        }

        // 2. Kembalikan field lengkap (bisa dipakai Guru maupun Siswa)
        return response()->json([
            'success' => true,
            'message' => 'Data user berhasil diambil.',
            'data'    => [
                'id'             => $user->id,
                'name'           => $user->name ?? $user->nama ?? '',
                'email'          => $user->email ?? '',
                'role'           => $user->role ?? 'siswa',
                'nip'            => $user->nip ?? '',
                'nisn'           => $user->nisn ?? $user->nik ?? '',
                'phone'          => $user->phone ?? $user->telepon ?? $user->no_hp ?? '',
                'ttl'            => $user->ttl ?? $user->birth_date ?? $user->tanggal_lahir ?? '',
                'gender'         => $user->gender ?? $user->jenis_kelamin ?? '',
                'subject'        => $user->subject ?? $user->mata_pelajaran ?? $user->jurusan ?? '',
                'school'         => $user->school ?? $user->sekolah_asal ?? $user->instansi ?? '',
                'address'        => $user->address ?? $user->alamat ?? '',
                'photo'          => $user->photo ?? $user->avatar ?? null,
            ]
        ], 200);
    }
}