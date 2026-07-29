<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class DiscussionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'         => $this->id,
            'class_code' => optional($this->classroom)->class_code,
            'class_name' => optional($this->classroom)->class_name,
            'user_name'  => optional($this->user)->name,
            'message'    => $this->message,
            'created_at' => $this->created_at,
        ];
    }
}
