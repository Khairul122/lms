<?php

namespace App\Actions\Task;

use App\Models\Task;
use App\Services\NotificationService;

class CreateTaskAction
{
    public function __construct(protected NotificationService $notificationService)
    {
    }

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
            $this->notificationService->notifyClass(
                classId: $task->class_id,
                title: 'Tugas Baru: ' . $task->title,
                message: 'Guru telah menambahkan tugas baru. Batas pengumpulan: ' . $task->deadline,
                type: 'task',
                excludeUserId: auth()->id(),
            );
        } catch (\Exception $e) {
            // Silence if notification fails
        }

        return $task;
    }
}
