<?php

namespace App\Http\Requests\User;

use Illuminate\Foundation\Http\FormRequest;

class StoreUserRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name'       => 'required|string|max:150',
            'username'   => 'nullable|string|max:100|unique:users,username',
            'email'      => 'required|email|max:150|unique:users,email',
            'password'   => 'required|min:6',
            'role'       => 'required|in:admin,guru,siswa',
            'nisn'       => 'nullable|max:30',
            'nip'        => 'nullable|max:30',
            'phone'      => 'nullable|max:30',
            'gender'     => 'nullable|in:Laki-laki,Perempuan',
            'birth_date' => 'nullable|date',
            'photo'      => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
        ];
    }

    public function messages(): array
    {
        return [
            'name.required'     => 'Nama wajib diisi.',
            'email.required'    => 'Email wajib diisi.',
            'email.unique'      => 'Email sudah digunakan.',
            'username.unique'   => 'Username sudah digunakan.',
            'password.required' => 'Password wajib diisi.',
            'password.min'      => 'Password minimal 6 karakter.',
            'role.required'     => 'Role wajib dipilih.',
            'photo.image'       => 'File harus berupa gambar.',
            'photo.max'         => 'Ukuran foto maksimal 2 MB.',
        ];
    }
}
