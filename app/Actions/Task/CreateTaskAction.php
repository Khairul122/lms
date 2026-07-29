<?php

namespace App\Actions\Task;

use App\Models\Task;

class CreateTaskAction
{
    /**
     * @param array{class_id:int,meeting_id:?int,title:string,description:?string,deadline:string,max_score:?int,attachment:?string} $data
     */
    public function execute(array $data): Task
    {
        return Task::create([
            'class_id'    => $data['class_id'],
            'meeting_id'  => $data['meeting_id'] ?? null,
            'title'       => $data['title'],
            'description' => $data['description'] ?? null,
            'deadline'    => $data['deadline'],
            'max_score'   => $data['max_score'] ?? 100,
            'attachment'  => $data['attachment'] ?? null,
            'is_active'   => true,
        ]);
    }
}
