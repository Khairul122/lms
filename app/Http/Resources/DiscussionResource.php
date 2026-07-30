<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class DiscussionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'          => $this->id,
            'class_code'  => optional($this->classroom)->class_code,
            'class_name'  => optional($this->classroom)->class_name,
            'user_id'     => $this->user_id,
            'user_name'   => optional($this->user)->name,
            'sender_name' => optional($this->user)->name,
            'role'        => optional($this->user)->role,
            'message'     => $this->message,
            'created_at'  => $this->created_at,
        ];
    }
}
