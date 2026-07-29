<?php

namespace App\Actions\Notification;

use App\Models\Notification;

class MarkNotificationReadAction
{
    public function execute(Notification $notification): Notification
    {
        $notification->update(['is_read' => true]);

        return $notification;
    }
}
