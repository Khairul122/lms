<?php

namespace App\Http\Controllers\Api;

use App\Actions\Notification\CreateNotificationAction;
use App\Actions\Notification\DeleteNotificationAction;
use App\Actions\Notification\MarkNotificationReadAction;
use App\Http\Controllers\Controller;
use App\Http\Resources\NotificationResource;
use App\Models\Notification;
use App\Services\NotificationService;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    use ApiResponse;

    public function __construct(protected NotificationService $notificationService)
    {
    }

    public function index()
    {
        $notifications = $this->notificationService->listAll();

        return $this->success(NotificationResource::collection($notifications), 'Data notifikasi berhasil diambil.');
    }

    public function unreadCount()
    {
        $count = $this->notificationService->listAll()->where('is_read', false)->count();

        return $this->success(['unread_count' => $count]);
    }

    public function show(Notification $notification)
    {
        $notification->load(['receiver', 'classroom']);

        return $this->success($notification);
    }

    public function store(Request $request, CreateNotificationAction $action)
    {
        $request->validate([
            'receiver_id' => 'required|exists:users,id',
            'class_id'    => 'nullable|exists:class_rooms,id',
            'title'       => 'required|string|max:255',
            'message'     => 'required|string',
            'type'        => 'required|string',
        ]);

        $notification = $action->execute($request->all());

        return $this->created($notification, 'Notifikasi berhasil dibuat.');
    }

    public function update(Notification $notification, MarkNotificationReadAction $action)
    {
        $notification = $action->execute($notification);

        return $this->success($notification, 'Notifikasi ditandai sudah dibaca.');
    }

    public function destroy(Notification $notification, DeleteNotificationAction $action)
    {
        $action->execute($notification);

        return $this->success(null, 'Notifikasi berhasil dihapus.');
    }
}
