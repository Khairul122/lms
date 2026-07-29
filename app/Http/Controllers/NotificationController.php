<?php

namespace App\Http\Controllers;

use App\Actions\Notification\CreateNotificationAction;
use App\Actions\Notification\DeleteNotificationAction;
use App\Actions\Notification\UpdateNotificationAction;
use App\Models\Notification;
use App\Models\User;
use App\Services\NotificationService;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    public function __construct(protected NotificationService $notificationService)
    {
    }

    public function index()
    {
        $notifications = $this->notificationService->paginateForAdmin();

        return view('notifications.index', compact('notifications'));
    }

    public function create()
    {
        $users = User::orderBy('name')->get();

        return view('notifications.create', compact('users'));
    }

    public function store(Request $request, CreateNotificationAction $action)
    {
        $request->validate([
            'user_id' => 'required',
            'title'   => 'required',
            'message' => 'required',
            'type'    => 'required',
        ]);

        $action->execute([
            'receiver_id' => $request->user_id,
            'title'       => $request->title,
            'message'     => $request->message,
            'type'        => $request->type,
        ]);

        return redirect()
            ->route('notifications.index')
            ->with('success', 'Notifikasi berhasil ditambahkan.');
    }

    public function show(Notification $notification)
    {
        return view('notifications.show', compact('notification'));
    }

    public function edit(Notification $notification)
    {
        $users = User::orderBy('name')->get();

        return view('notifications.edit', compact('notification', 'users'));
    }

    public function update(Request $request, Notification $notification, UpdateNotificationAction $action)
    {
        $action->execute($notification, [
            'receiver_id' => $request->user_id,
            'title'       => $request->title,
            'message'     => $request->message,
            'type'        => $request->type,
            'is_read'     => $request->boolean('is_read'),
        ]);

        return redirect()
            ->route('notifications.index')
            ->with('success', 'Notifikasi berhasil diupdate.');
    }

    public function destroy(Notification $notification, DeleteNotificationAction $action)
    {
        $action->execute($notification);

        return back()->with('success', 'Notifikasi berhasil dihapus.');
    }
}
