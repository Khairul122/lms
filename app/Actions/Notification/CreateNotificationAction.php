<?php

namespace App\Actions\Notification;

use App\Models\Notification;

class CreateNotificationAction
{
    public function execute(array $data): Notification
    {
        return Notification::create([
            'receiver_id' => $data['receiver_id'],
            'class_id'    => $data['class_id'] ?? null,
            'title'       => $data['title'],
            'message'     => $data['message'],
            'type'        => $data['type'],
            'is_read'     => false,
        ]);
    }
}
