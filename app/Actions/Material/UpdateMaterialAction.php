<?php

namespace App\Actions\Material;

use App\Models\Material;
use App\Services\MaterialService;

class UpdateMaterialAction
{
    public function __construct(protected MaterialService $materialService)
    {
    }

    /**
     * @param array{class_id:int,meeting_id:?int,pertemuan:?int,title:string,description:?string,youtube_url:?string,new_file_path:?string} $data
     */
    public function execute(Material $material, array $data): Material
    {
        $fileUrl = $material->file_url;

        if (!empty($data['new_file_path'])) {
            $this->materialService->deleteFile($material->file_url);
            $fileUrl = $data['new_file_path'];
        }

        $material->update([
            'class_id'    => $data['class_id'],
            'meeting_id'  => $data['meeting_id'] ?? null,
            'pertemuan'   => $data['pertemuan'] ?? null,
            'title'       => $data['title'],
            'description' => $data['description'] ?? null,
            'youtube_url' => $data['youtube_url'] ?? null,
            'file_url'    => $fileUrl,
        ]);

        return $material;
    }
}
