<?php

namespace App\Services;

use App\Models\Submission;

class SubmissionService
{
    public function getAllSubmissions()
    {
        return Submission::with(['task', 'student'])
            ->latest()
            ->get();
    }
}
