<?php

namespace App\Actions\Submission;

use App\Models\Submission;
use Illuminate\Http\Request;

class StoreSubmissionAction
{
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

        return Submission::create([
            'task_id'      => $request->task_id,
            'user_id'      => $userId,
            'file_path'    => $filePath,
            'note'         => $request->note ?? '',
            'submitted_at' => now(),
        ]);
    }
}
