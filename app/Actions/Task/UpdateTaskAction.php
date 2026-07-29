<?php

namespace App\Actions\Task;

use App\Models\Task;
use Illuminate\Support\Facades\Storage;

class UpdateTaskAction
{
    /**
     * @param array{class_id:int,meeting_id:?int,title:string,description:?string,deadline:string,max_score:?int,is_active:bool,new_attachment_path:?string} $data
     */
    public function execute(Task $task, array $data): Task
    {
        $attachment = $task->attachment;

        if (!empty($data['new_attachment_path'])) {
            if ($attachment) {
                Storage::disk('public')->delete($attachment);
            }
            $attachment = $data['new_attachment_path'];
        }

        $task->update([
            'class_id'    => $data['class_id'],
            'meeting_id'  => $data['meeting_id'] ?? null,
            'title'       => $data['title'],
            'description' => $data['description'] ?? null,
            'deadline'    => $data['deadline'],
            'max_score'   => $data['max_score'] ?? $task->max_score,
            'attachment'  => $attachment,
            'is_active'   => $data['is_active'] ?? $task->is_active,
        ]);

        return $task;
    }
}
