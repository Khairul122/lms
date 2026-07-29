<?php

namespace App\Actions\Notification;

use App\Models\Notification;

class UpdateNotificationAction
{
    public function execute(Notification $notification, array $data): Notification
    {
        $notification->update([
            'receiver_id' => $data['receiver_id'] ?? $notification->receiver_id,
            'title'       => $data['title'] ?? $notification->title,
            'message'     => $data['message'] ?? $notification->message,
            'type'        => $data['type'] ?? $notification->type,
            'is_read'     => array_key_exists('is_read', $data) ? (bool) $data['is_read'] : $notification->is_read,
        ]);

        return $notification;
    }
}
