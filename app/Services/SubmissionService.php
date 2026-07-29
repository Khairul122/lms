<?php

namespace App\Services;

use App\Models\Submission;

class SubmissionService
{
    public function getAllSubmissions()
    {
        return Submission::with(['task', 'student'])
            ->latest()
            ->get()
            ->map(function ($submission) {
                return [
                    'id'           => $submission->id,
                    'task_id'      => $submission->task_id,
                    'task'         => $submission->task?->title,
                    'student'      => $submission->student?->name,
                    'file_path'    => $submission->file_path,
                    'note'         => $submission->note,
                    'score'        => $submission->score,
                    'teacher_note' => $submission->teacher_note,
                    'submitted_at' => $submission->submitted_at,
                ];
            });
    }
}
