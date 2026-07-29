<?php

namespace App\Services;

use App\Models\ClassRoom;
use App\Models\Meeting;

class MeetingService
{
    public function findClassByCode(string $classCode): ?ClassRoom
    {
        return ClassRoom::where('class_code', strtoupper(trim($classCode)))->first();
    }

    public function nextPertemuanNumber(int $classId): int
    {
        return (int) Meeting::where('class_id', $classId)->max('pertemuan') + 1;
    }

    public function listForApi(array $filters)
    {
        $query = Meeting::with('classroom');

        if (!empty($filters['class_code'])) {
            $classroom = $this->findClassByCode($filters['class_code']);

            if (!$classroom) {
                return collect();
            }

            $query->where('class_id', $classroom->id);
        } elseif (!empty($filters['class_id'])) {
            $query->where('class_id', $filters['class_id']);
        }

        return $query->orderBy('pertemuan')->get();
    }
}
