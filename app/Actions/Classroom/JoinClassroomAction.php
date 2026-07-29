<?php

namespace App\Actions\Classroom;

use App\Models\ClassRoom;
use App\Models\User;
use Exception;

class JoinClassroomAction
{
    public function execute(User $user, string $classCode): ClassRoom
    {
        $code = strtoupper(trim($classCode));
        $class = ClassRoom::where('class_code', $code)->first();

        if (!$class) {
            throw new Exception('Kode kelas salah atau tidak ditemukan!', 404);
        }

        $alreadyJoined = false;
        if (method_exists($class, 'students')) {
            $alreadyJoined = $class->students()->where('user_id', $user->id)->exists();
        } else if (method_exists($user, 'joinedClasses')) {
            $alreadyJoined = $user->joinedClasses()->where('class_room_id', $class->id)->exists();
        }

        if ($alreadyJoined) {
            throw new Exception('Kamu sudah terdaftar di kelas ini!', 400);
        }

        if (method_exists($class, 'students')) {
            $class->students()->attach($user->id);
        } else {
            $user->joinedClasses()->attach($class->id);
        }

        return $class;
    }
}
