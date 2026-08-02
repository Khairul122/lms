<?php

namespace App\Actions\Classroom;

use App\Models\ClassRoom;
use App\Models\User;
use App\Services\NotificationService;

class CreateClassroomAction
{
    public function __construct(protected NotificationService $notificationService)
    {
    }

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

        $this->notificationService->notifyClassCreated($class);

        return $class;
    }
}
