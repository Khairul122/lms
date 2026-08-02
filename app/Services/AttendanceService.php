<?php

namespace App\Services;

use App\Models\Attendance;
use App\Models\ClassRoom;
use App\Models\Meeting;

class AttendanceService
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

    /**
     * Daftar siswa di kelas pemilik pertemuan ini, masing-masing dilengkapi
     * status absensi kalau sudah pernah diisi (null kalau belum diabsen).
     */
    public function listForMeeting(Meeting $meeting)
    {
        $meeting->loadMissing('classroom.students');

        $attendances = Attendance::where('meeting_id', $meeting->id)
            ->get()
            ->keyBy('user_id');

        return $meeting->classroom->students->map(function ($student) use ($meeting, $attendances) {
            $attendance = $attendances->get($student->id);

            return [
                'meeting_id' => $meeting->id,
                'user_id'    => $student->id,
                'student_name' => $student->name,
                'status'     => $attendance?->status,
                'note'       => $attendance?->note,
            ];
        })->values();
    }
}
