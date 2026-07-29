<?php

namespace App\Actions\Notification;

use App\Models\Notification;

class DeleteNotificationAction
{
    public function execute(Notification $notification): void
    {
        $notification->delete();
    }
}
