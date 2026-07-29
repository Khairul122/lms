<?php

namespace App\Actions\Meeting;

use App\Models\Meeting;

class CreateMeetingAction
{
    /**
     * @param array{class_id:int,pertemuan:int,nama_pertemuan:string,tema_pertemuan:?string} $data
     */
    public function execute(array $data): Meeting
    {
        return Meeting::create([
            'class_id'       => $data['class_id'],
            'pertemuan'      => $data['pertemuan'],
            'nama_pertemuan' => $data['nama_pertemuan'],
            'tema_pertemuan' => $data['tema_pertemuan'] ?? null,
        ]);
    }
}
