<?php

namespace App\Services;

use App\Models\ClassRoom;
use App\Models\User;
use App\Services\RoleService;

class ClassroomService
{
    public function __construct(protected RoleService $roleService)
    {
    }

    /**
     * Get classes for user based on role
     */
    public function getClassesForUser(User $user)
    {
        if ($this->roleService->isSiswa($user)) {
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
}
