<?php

namespace App\Services;

use App\Models\ClassRoom;
use App\Models\Discussion;

class DiscussionService
{
    public function findClassByCode(string $classCode): ?ClassRoom
    {
        return ClassRoom::where('class_code', $classCode)->first();
    }

    public function listForApi(array $filters)
    {
        $query = Discussion::with(['classroom', 'user']);

        if (!empty($filters['class_code'])) {
            $classroom = $this->findClassByCode($filters['class_code']);

            if ($classroom) {
                $query->where('class_id', $classroom->id);
            }
        }

        return $query->latest()->get();
    }
}
