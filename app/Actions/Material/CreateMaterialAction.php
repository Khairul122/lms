<?php

namespace App\Actions\Material;

use App\Models\Material;
use App\Services\NotificationService;

class CreateMaterialAction
{
    public function __construct(protected NotificationService $notificationService)
    {
    }

    /**
     * @param array{class_id:int,meeting_id:?int,pertemuan:?int,title:string,description:?string,file_url:?string,youtube_url:?string} $data
     */
    public function execute(array $data): Material
    {
        $material = Material::create([
            'class_id'    => $data['class_id'],
            'meeting_id'  => $data['meeting_id'] ?? null,
            'pertemuan'   => $data['pertemuan'] ?? null,
            'title'       => $data['title'],
            'description' => $data['description'] ?? null,
            'file_url'    => $data['file_url'] ?? null,
            'youtube_url' => $data['youtube_url'] ?? null,
        ]);

        try {
            $this->notificationService->notifyClass(
                classId: $material->class_id,
                title: 'Materi Baru: ' . $material->title,
                message: 'Guru telah menambahkan materi baru di kelas ini.',
                type: 'material',
                excludeUserId: auth()->id(),
            );
        } catch (\Exception $e) {
            // Silence if notification fails
        }

        return $material;
    }
}
