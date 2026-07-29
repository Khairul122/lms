<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SubmissionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'           => $this->id,
            'task_id'      => $this->task_id,
            'task'         => $this->task?->title,
            'student'      => $this->student?->name,
            'file_path'    => $this->file_path,
            'note'         => $this->note,
            'score'        => $this->score,
            'teacher_note' => $this->teacher_note,
            'submitted_at' => $this->submitted_at,
        ];
    }
}
