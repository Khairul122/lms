<?php

namespace App\Actions\Submission;

use App\Models\Submission;
use Illuminate\Support\Facades\Storage;

class DeleteSubmissionAction
{
    public function execute(Submission $submission): void
    {
        if ($submission->file_path) {
            Storage::disk('public')->delete($submission->file_path);
        }

        $submission->delete();
    }
}
