<?php

namespace App\Actions\Material;

use App\Models\Material;
use App\Services\MaterialService;

class DeleteMaterialAction
{
    public function __construct(protected MaterialService $materialService)
    {
    }

    public function execute(Material $material): void
    {
        $this->materialService->deleteFile($material->file_url);
        $material->delete();
    }
}
