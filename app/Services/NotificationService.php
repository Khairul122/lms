<?php

namespace App\Services;

use App\Models\Notification;

class NotificationService
{
    public function listAll()
    {
        return Notification::with(['receiver', 'classroom'])
            ->latest()
            ->get();
    }

    public function paginateForAdmin(int $perPage = 10)
    {
        return Notification::with('receiver')
            ->latest()
            ->paginate($perPage);
    }
}
