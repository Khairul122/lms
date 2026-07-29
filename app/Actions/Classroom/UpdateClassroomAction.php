<?php

namespace App\Actions\Classroom;

use App\Models\ClassRoom;

class UpdateClassroomAction
{
    public function execute(ClassRoom $class, array $data): ClassRoom
    {
        $class->update(array_filter([
            'class_name'  => $data['class_name'] ?? null,
            'subject'     => $data['subject'] ?? null,
            'teacher_id'  => $data['teacher_id'] ?? null,
            'description' => $data['description'] ?? null,
            'is_active'   => $data['is_active'] ?? null,
        ], fn ($value) => $value !== null));

        return $class;
    }
}
