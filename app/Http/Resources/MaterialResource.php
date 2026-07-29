<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MaterialResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'           => $this->id,
            'class_id'     => $this->class_id,
            'class_name'   => optional($this->classroom)->class_name,
            'meeting_id'   => $this->meeting_id,
            'meeting_name' => optional($this->meeting)->nama_pertemuan,
            'pertemuan'    => $this->pertemuan,
            'title'        => $this->title,
            'description'  => $this->description,
            'file_url'     => $this->file_url,
            'youtube_url'  => $this->youtube_url,
            'created_at'   => $this->created_at,
        ];
    }
}
