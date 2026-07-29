<?php

namespace App\Http\Requests\ClassRoom;

use Illuminate\Foundation\Http\FormRequest;

class StoreClassRoomRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'class_name'  => 'required|max:150',
            'subject'     => 'required|max:150',
            'teacher_id'  => 'nullable|exists:users,id',
            'description' => 'nullable|max:1000',
        ];
    }

    public function messages(): array
    {
        return [
            'class_name.required' => 'Nama kelas wajib diisi.',
            'subject.required'    => 'Mata pelajaran wajib diisi.',
            'teacher_id.exists'   => 'Guru tidak ditemukan.',
        ];
    }
}
