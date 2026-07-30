<?php

namespace App\Actions\Submission;

use App\Models\Submission;
use App\Models\Task;
use App\Services\NotificationService;
use Illuminate\Http\Request;

class StoreSubmissionAction
{
    public function __construct(protected NotificationService $notificationService)
    {
    }

    public function execute(Request $request): Submission
    {
        $filePath = null;

        if ($request->hasFile('file')) {
            $filePath = $request->file('file')->store('submissions', 'public');
        } elseif ($request->has('file_url') && !empty($request->file_url)) {
            $filePath = $request->file_url;
        } elseif ($request->has('file_path') && !empty($request->file_path)) {
            $filePath = $request->file_path;
        } else {
            $filePath = 'submission_default.pdf';
        }

        $userId = auth()->id() ?? $request->user_id ?? 1;

        $submission = Submission::create([
            'task_id'      => $request->task_id,
            'user_id'      => $userId,
            'file_path'    => $filePath,
            'note'         => $request->note ?? '',
            'submitted_at' => now(),
        ]);

        try {
            $task = Task::with('classroom')->find($submission->task_id);

            if ($task && $task->classroom && $task->classroom->teacher_id) {
                $studentName = auth()->user()?->name ?? 'Seorang murid';

                $this->notificationService->notifyUser(
                    userId: $task->classroom->teacher_id,
                    title: 'Tugas Dikumpulkan',
                    message: $studentName . ' telah mengumpulkan tugas: ' . $task->title,
                    type: 'submission',
                    classId: $task->class_id,
                );
            }
        } catch (\Exception $e) {
            // Silence if notification fails
        }

        return $submission;
    }
}
