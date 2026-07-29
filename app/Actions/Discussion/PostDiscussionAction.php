<?php

namespace App\Actions\Discussion;

use App\Models\Discussion;
use App\Models\Notification;

class PostDiscussionAction
{
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
            Notification::create([
                'receiver_id' => null,
                'class_id'    => $discussion->class_id,
                'title'       => 'Pesan Diskusi Baru',
                'message'     => (auth()->user()?->name ?? 'Pengguna') . ': ' . substr($discussion->message, 0, 50),
                'type'        => 'discussion',
                'is_read'     => false,
            ]);
        } catch (\Exception $e) {
            // Silence if notification fails
        }

        return $discussion;
    }
}
