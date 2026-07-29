<?php

namespace App\Actions\Submission;

use App\Models\Submission;

class GradeSubmissionAction
{
    public function execute($id, array $data): Submission
    {
        $submission = Submission::find($id);

        if (!$submission && str_contains((string)$id, '_')) {
            [$studentId, $taskId] = explode('_', (string)$id);
            $submission = Submission::where('user_id', $studentId)
                ->where('task_id', $taskId)
                ->first();
        }

        $score = $data['score'] ?? $data['grade'] ?? 0;
        $teacherNote = $data['teacher_note'] ?? $data['note'] ?? '';

        if (!$submission) {
            $studentId = $data['student_id'] ?? 1;
            $taskId = $data['task_id'] ?? $id;

            return Submission::create([
                'task_id'      => $taskId,
                'user_id'      => $studentId,
                'file_path'    => 'manual_grading.pdf',
                'score'        => $score,
                'teacher_note' => $teacherNote,
                'submitted_at' => now(),
            ]);
        }

        $submission->update([
            'score'        => $score,
            'teacher_note' => $teacherNote,
        ]);

        return $submission->fresh();
    }
}
