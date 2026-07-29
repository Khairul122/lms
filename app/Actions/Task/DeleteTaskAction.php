<?php

namespace App\Actions\Task;

use App\Models\Task;
use Illuminate\Support\Facades\Storage;

class DeleteTaskAction
{
    public function execute(Task $task): void
    {
        if ($task->attachment) {
            Storage::disk('public')->delete($task->attachment);
        }

        $task->delete();
    }
}
