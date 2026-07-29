<?php

namespace App\Services;

use App\Models\ClassRoom;
use App\Models\Meeting;
use App\Models\Task;

class TaskService
{
    public function findClassByCode(string $classCode): ?ClassRoom
    {
        return ClassRoom::where('class_code', $classCode)->first();
    }

    public function findMeetingByNumber(int $classId, int $meetingNumber): ?Meeting
    {
        return Meeting::where('class_id', $classId)
            ->where('pertemuan', $meetingNumber)
            ->first();
    }

    public function listForApi(array $filters)
    {
        $query = Task::query();

        if (!empty($filters['class_code'])) {
            $class = $this->findClassByCode($filters['class_code']);

            if (!$class) {
                return collect();
            }

            $query->where('class_id', $class->id);

            if (!empty($filters['pertemuan'])) {
                $meeting = $this->findMeetingByNumber($class->id, (int) $filters['pertemuan']);

                if (!$meeting) {
                    return collect();
                }

                $query->where('meeting_id', $meeting->id);
            }
        }

        return $query->latest()->get();
    }
}
