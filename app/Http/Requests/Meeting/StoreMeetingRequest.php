<?php

namespace App\Http\Requests\Meeting;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreMeetingRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'class_id' => [
                'required',
                'exists:class_rooms,id',
            ],
            'pertemuan' => [
                'required',
                'integer',
                'min:1',
                Rule::unique('meetings')->where(fn ($query) => $query->where('class_id', $this->class_id)),
            ],
            'nama_pertemuan' => ['required', 'string', 'max:150'],
            'tema_pertemuan' => ['nullable', 'string'],
        ];
    }

    public function messages(): array
    {
        return [
            'class_id.required'    => 'Silakan pilih kelas.',
            'class_id.exists'      => 'Kelas yang dipilih tidak ditemukan.',
            'pertemuan.required'   => 'Nomor pertemuan wajib diisi.',
            'pertemuan.integer'    => 'Nomor pertemuan harus berupa angka.',
            'pertemuan.min'        => 'Nomor pertemuan minimal 1.',
            'pertemuan.unique'     => 'Nomor pertemuan tersebut sudah ada pada kelas ini.',
            'nama_pertemuan.required' => 'Nama pertemuan wajib diisi.',
            'nama_pertemuan.max'      => 'Nama pertemuan maksimal 150 karakter.',
        ];
    }

    public function attributes(): array
    {
        return [
            'class_id'       => 'kelas',
            'pertemuan'      => 'nomor pertemuan',
            'nama_pertemuan' => 'nama pertemuan',
            'tema_pertemuan' => 'tema pertemuan',
        ];
    }
}
