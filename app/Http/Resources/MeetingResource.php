<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MeetingResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'             => $this->id,
            'class_id'       => $this->class_id,
            'class_code'     => optional($this->classroom)->class_code,
            'class_name'     => optional($this->classroom)->class_name,
            'pertemuan'      => $this->pertemuan,
            'nama_pertemuan' => $this->nama_pertemuan,
            'tema_pertemuan' => $this->tema_pertemuan,
            'created_at'     => $this->created_at,
        ];
    }
}
