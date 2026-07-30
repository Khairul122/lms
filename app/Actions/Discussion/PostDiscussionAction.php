<?php

namespace App\Actions\Discussion;

use App\Models\Discussion;
use App\Services\NotificationService;

class PostDiscussionAction
{
    public function __construct(protected NotificationService $notificationService)
    {
    }

    /**
     * @param array{class_id:int,user_id:int,message:string,meeting_id:?int} $data
     */
    public function execute(array $data): Discussion
    {
        $discussion = Discussion::create([
            'class_id'   => $data['class_id'],
            'user_id'    => $data['user_id'],
            'meeting_id' => $data['meeting_id'] ?? null,
            'message'    => $data['message'],
        ]);

        try {
            $senderName = auth()->user()?->name ?? 'Pengguna';

            $this->notificationService->notifyClass(
                classId: $discussion->class_id,
                title: 'Pesan Diskusi Baru',
                message: $senderName . ': ' . substr($discussion->message, 0, 50),
                type: 'discussion',
                excludeUserId: $data['user_id'],
            );
        } catch (\Exception $e) {
            // Silence if notification fails
        }

        return $discussion;
    }
}
