<?php

namespace App\Actions\Meeting;

use App\Models\Meeting;

class UpdateMeetingAction
{
    public function execute(Meeting $meeting, array $data): Meeting
    {
        $meeting->update($data);

        return $meeting;
    }
}
