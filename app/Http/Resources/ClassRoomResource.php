<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ClassRoomResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'             => $this->id,
            'class_code'     => $this->class_code,
            'class_name'     => $this->class_name,
            'subject'        => $this->subject,
            'teacher'        => $this->teacher?->name ?? 'Pengajar',
            'teacher_detail' => [
                'id'    => $this->teacher?->id,
                'name'  => $this->teacher?->name ?? 'Pengajar',
                'email' => $this->teacher?->email,
            ],
            'students'       => $this->whenLoaded('students', function () {
                return $this->students->map(function ($s) {
                    return [
                        'id'    => $s->id,
                        'name'  => $s->name,
                        'email' => $s->email,
                        'nisn'  => $s->nisn,
                        'phone' => $s->phone,
                    ];
                });
            }),
            'description'    => $this->description,
            'students_count' => $this->students_count ?? 0,
            'is_active'      => $this->is_active,
            'created_at'     => $this->created_at,
        ];
    }
}
