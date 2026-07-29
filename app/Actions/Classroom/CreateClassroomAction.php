<?php

namespace App\Actions\Classroom;

use App\Models\ClassRoom;
use App\Models\User;

class CreateClassroomAction
{
    public function execute(User $user, array $data): ClassRoom
    {
        $class = ClassRoom::create([
            'class_code'  => strtoupper(trim($data['class_code'])),
            'class_name'  => $data['class_name'],
            'subject'     => $data['subject'],
            'teacher_id'  => $data['teacher_id'] ?? $user->id,
            'description' => $data['school_name'] ?? ($data['description'] ?? null),
            'is_active'   => 1,
        ]);

        $class->load('teacher');

        return $class;
    }
}
