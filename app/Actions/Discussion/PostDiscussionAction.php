<?php

namespace App\Actions\Discussion;

use App\Models\Discussion;

class PostDiscussionAction
{
    /**
     * @param array{class_id:int,user_id:int,message:string,meeting_id:?int} $data
     */
    public function execute(array $data): Discussion
    {
        return Discussion::create([
            'class_id'   => $data['class_id'],
            'user_id'    => $data['user_id'],
            'meeting_id' => $data['meeting_id'] ?? null,
            'message'    => $data['message'],
        ]);
    }
}
