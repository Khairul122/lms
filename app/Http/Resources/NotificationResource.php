<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class NotificationResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'         => $this->id,
            'receiver'   => optional($this->receiver)->name,
            'class'      => optional($this->classroom)->class_name,
            'class_code' => optional($this->classroom)->class_code,
            'title'      => $this->title,
            'message'    => $this->message,
            'type'       => $this->type,
            'is_read'    => $this->is_read,
            'created_at' => $this->created_at,
        ];
    }
}
