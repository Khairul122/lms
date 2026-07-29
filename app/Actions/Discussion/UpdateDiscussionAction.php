<?php

namespace App\Actions\Discussion;

use App\Models\Discussion;

class UpdateDiscussionAction
{
    public function execute(Discussion $discussion, array $data): Discussion
    {
        $discussion->update([
            'class_id' => $data['class_id'] ?? $discussion->class_id,
            'message'  => $data['message'] ?? $discussion->message,
        ]);

        return $discussion;
    }
}
