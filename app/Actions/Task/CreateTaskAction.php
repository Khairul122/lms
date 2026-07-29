<?php

namespace App\Actions\Task;

use App\Models\Notification;
use App\Models\Task;

class CreateTaskAction
{
    /**
     * @param array{class_id:int,meeting_id:?int,title:string,description:?string,deadline:string,max_score:?int,attachment:?string} $data
     */
    public function execute(array $data): Task
    {
        $task = Task::create([
            'class_id'    => $data['class_id'],
            'meeting_id'  => $data['meeting_id'] ?? null,
            'title'       => $data['title'],
            'description' => $data['description'] ?? null,
            'deadline'    => $data['deadline'],
            'max_score'   => $data['max_score'] ?? 100,
            'attachment'  => $data['attachment'] ?? null,
            'is_active'   => true,
        ]);

        try {
            Notification::create([
                'receiver_id' => null,
                'class_id'    => $task->class_id,
                'title'       => 'Tugas Baru: ' . $task->title,
                'message'     => 'Guru telah menambahkan tugas baru. Batas pengumpulan: ' . $task->deadline,
                'type'        => 'task',
                'is_read'     => false,
            ]);
        } catch (\Exception $e) {
            // Silence if notification fails
        }

        return $task;
    }
}
