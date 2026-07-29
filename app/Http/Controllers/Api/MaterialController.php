<?php

namespace App\Http\Controllers\Api;

use App\Actions\Material\CreateMaterialAction;
use App\Actions\Material\DeleteMaterialAction;
use App\Http\Controllers\Controller;
use App\Http\Resources\MaterialResource;
use App\Models\Material;
use App\Services\MaterialService;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class MaterialController extends Controller
{
    use ApiResponse;

    public function __construct(protected MaterialService $materialService)
    {
    }

    /**
     * Daftar materi (dengan filter class_code & pertemuan dari Flutter)
     */
    public function index(Request $request)
    {
        $materials = $this->materialService->listForApi($request->only(['class_code', 'pertemuan']));

        return $this->success(MaterialResource::collection($materials), 'Data materi berhasil diambil.');
    }

    /**
     * Simpan materi baru dari Flutter / Web Admin
     */
    public function store(Request $request, CreateMaterialAction $action)
    {
        $validator = Validator::make($request->all(), [
            'class_code'     => 'required|string',
            'meeting_number' => 'required|integer',
            'title'          => 'required|string|max:255',
            'description'    => 'nullable|string',
            'file_url'       => 'nullable|string',
            'youtube_url'    => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->error('Validasi gagal', 422, $validator->errors());
        }

        $class = $this->materialService->findClassByCode($request->class_code);

        if (!$class) {
            return $this->notFound('Kelas tidak ditemukan.');
        }

        $meeting = $this->materialService->findMeetingByNumber($class->id, (int) $request->meeting_number);

        $material = $action->execute([
            'class_id'    => $class->id,
            'meeting_id'  => $meeting?->id,
            'pertemuan'   => $request->meeting_number,
            'title'       => $request->title,
            'description' => $request->description,
            'file_url'    => $request->file_url,
            'youtube_url' => $request->youtube_url,
        ]);

        return $this->created($material, 'Materi berhasil disimpan');
    }

    /**
     * Detail materi
     */
    public function show(Material $material)
    {
        $material->load(['classroom', 'meeting']);

        return $this->success(new MaterialResource($material));
    }

    /**
     * Hapus materi
     */
    public function destroy(Material $material, DeleteMaterialAction $action)
    {
        $action->execute($material);

        return $this->success(null, 'Materi berhasil dihapus');
    }
}
