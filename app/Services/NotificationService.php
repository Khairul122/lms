<?php

namespace App\Services;

use App\Models\Notification;

class NotificationService
{
    public function listAll()
    {
        $userId = auth()->id();

        return Notification::with(['receiver', 'classroom'])
            ->where(function ($query) use ($userId) {
                if ($userId) {
                    $query->where('receiver_id', $userId)
                          ->orWhereNull('receiver_id');
                }
            })
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
