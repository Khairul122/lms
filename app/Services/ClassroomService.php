<?php

namespace App\Services;

use App\Models\ClassRoom;
use App\Models\User;

class ClassroomService
{
    /**
     * Get classes for user based on role
     */
    public function getClassesForUser(User $user)
    {
        $isStudent = strtolower($user->role ?? '') === 'student' 
                  || strtolower($user->role ?? '') === 'siswa' 
                  || (method_exists($user, 'hasRole') && ($user->hasRole('student') || $user->hasRole('siswa')));

        if ($isStudent) {
            return $user->joinedClasses()
                ->with('teacher')
                ->withCount('students')
                ->latest()
                ->get();
        }

        $classes = ClassRoom::where('teacher_id', $user->id)
            ->with('teacher')
            ->withCount('students')
            ->latest()
            ->get();

        if ($classes->isEmpty()) {
            $joined = $user->joinedClasses()
                ->with('teacher')
                ->withCount('students')
                ->latest()
                ->get();
            if ($joined->isNotEmpty()) {
                return $joined;
            }
        }

        return $classes;
    }

    /**
     * Format classroom collection for API response
     */
    public function formatClassroomResponse($classes)
    {
        return $classes->map(function ($class) {
            return [
                'id'             => $class->id,
                'class_code'     => $class->class_code,
                'class_name'     => $class->class_name,
                'subject'        => $class->subject,
                'teacher'        => $class->teacher?->name ?? 'Pengajar',
                'description'    => $class->description,
                'students_count' => $class->students_count ?? 0,
                'is_active'      => $class->is_active,
                'created_at'     => $class->created_at,
            ];
        });
    }
}
