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

    public function store(Request $request)
    {
        $request->validate([
            'receiver_id' => 'nullable|exists:users,id',
            'class_id'    => 'nullable|exists:class_rooms,id',
            'title'       => 'required|string|max:255',
            'message'     => 'required|string',
            'type'        => 'required|string',
        ]);

        $user = $request->user();

        if ($request->filled('receiver_id')) {
            $this->notificationService->notifyUser(
                userId: $request->receiver_id,
                title: $request->title,
                message: $request->message,
                type: $request->type,
                classId: $request->class_id
            );
        } elseif ($request->filled('class_id')) {
            $this->notificationService->notifyClass(
                classId: $request->class_id,
                title: $request->title,
                message: $request->message,
                type: $request->type,
                excludeUserId: $user->id
            );
        } else {
            // Broadcast ke seluruh siswa
            $students = \App\Models\User::where('role', 'siswa')->get();
            $now = now();
            $rows = [];
            foreach ($students as $student) {
                $rows[] = [
                    'receiver_id' => $student->id,
                    'class_id'    => null,
                    'title'       => $request->title,
                    'message'     => $request->message,
                    'type'        => $request->type,
                    'is_read'     => false,
                    'created_at'  => $now,
                    'updated_at'  => $now,
                ];
            }
            if (count($rows) > 0) {
                Notification::insert($rows);
            }
        }

        return $this->success(null, 'Notifikasi berhasil dibuat.', 201);
    }

    public function update(Notification $notification, MarkNotificationReadAction $action)
    {
        if ($notification->receiver_id !== auth()->id()) {
            return $this->forbidden('Anda tidak memiliki akses ke notifikasi ini.');
        }

        $notification = $action->execute($notification);

        return $this->success($notification, 'Notifikasi ditandai sudah dibaca.');
    }

    public function destroy(Notification $notification, DeleteNotificationAction $action)
    {
        if ($notification->receiver_id !== auth()->id()) {
            return $this->forbidden('Anda tidak memiliki akses untuk menghapus notifikasi ini.');
        }

        $action->execute($notification);

        return $this->success(null, 'Notifikasi berhasil dihapus.');
    }
}
