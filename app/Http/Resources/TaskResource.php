<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TaskResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'          => $this->id,
            'class_id'    => $this->class_id,
            'meeting_id'  => $this->meeting_id,
            'title'       => $this->title,
            'description' => $this->description,
            'deadline'    => $this->deadline,
            'max_score'   => $this->max_score,
            'attachment'  => $this->attachment,
            'is_active'   => $this->is_active,
            'created_at'  => $this->created_at,
        ];
    }
}
