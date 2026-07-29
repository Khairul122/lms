<?php

namespace App\Actions\Meeting;

use App\Models\Meeting;

class DeleteMeetingAction
{
    public function execute(Meeting $meeting): void
    {
        $meeting->delete();
    }
}
