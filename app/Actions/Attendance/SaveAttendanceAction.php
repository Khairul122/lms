<?php

namespace App\Actions\Attendance;

use App\Models\Attendance;
use App\Models\Meeting;

class SaveAttendanceAction
{
    /**
     * @param  array<int, array{user_id: int, status: string, note?: string|null}>  $records
     */
    public function execute(Meeting $meeting, array $records): void
    {
        foreach ($records as $record) {
            Attendance::updateOrCreate(
                [
                    'meeting_id' => $meeting->id,
                    'user_id'    => $record['user_id'],
                ],
                [
                    'status' => $record['status'],
                    'note'   => $record['note'] ?? null,
                ],
            );
        }
    }
}
