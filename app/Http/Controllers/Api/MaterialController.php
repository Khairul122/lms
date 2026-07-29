<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Material;
use App\Models\ClassRoom;
use App\Models\Meeting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class MaterialController extends Controller
{
    /**
     * Daftar materi (dengan filter class_code & pertemuan dari Flutter)
     */
    public function index(Request $request)
    {
        $query = Material::with(['classroom', 'meeting']);

        // Filter jika dikirim query param dari Flutter
        if ($request->has('class_code')) {
            $class = ClassRoom::where('class_code', $request->class_code)->first();

            if ($class) {
                $query->where('class_id', $class->id);

                if ($request->has('pertemuan')) {
                    $meeting = Meeting::where('class_id', $class->id)
                        ->where('pertemuan', $request->pertemuan)
                        ->first();

                    if ($meeting) {
                        $query->where('meeting_id', $meeting->id);
                    } else {
                        return response()->json([
                            'success' => true,
                            'message' => 'Data materi berhasil diambil.',
                            'data' => [],
                        ]);
                    }
                }
            } else {
                return response()->json([
                    'success' => true,
                    'message' => 'Data materi berhasil diambil.',
                    'data' => [],
                ]);
            }
        }

        $materials = $query->latest()
            ->get()
            ->map(function ($material) {
                return [
                    'id' => $material->id,
                    'class_id' => $material->class_id,
                    'class_name' => optional($material->classroom)->class_name,
                    'meeting_id' => $material->meeting_id,
                    'meeting_name' => optional($material->meeting)->nama_pertemuan,
                    'pertemuan' => $material->pertemuan,
                    'title' => $material->title,
                    'description' => $material->description,
                    'file_url' => $material->file_url,
                    'youtube_url' => $material->youtube_url,
                    'created_at' => $material->created_at,
                ];
            });

        return response()->json([
            'success' => true,
            'message' => 'Data materi berhasil diambil.',
            'data' => $materials,
        ]);
    }

    /**
     * Simpan materi baru dari Flutter / Web Admin
     */
    public function store(Request $request)
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
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors'  => $validator->errors()
            ], 422);
        }

        try {
            // Cari kelas berdasarkan class_code
            $class = ClassRoom::where('class_code', $request->class_code)->first();

            if (!$class) {
                return response()->json([
                    'success' => false,
                    'message' => 'Kelas tidak ditemukan.'
                ], 404);
            }

            // Cari meeting berdasarkan class_id dan pertemuan
            $meeting = Meeting::where('class_id', $class->id)
                ->where('pertemuan', $request->meeting_number)
                ->first();

            // Simpan data materi
            $material = Material::create([
                'class_id'    => $class->id,
                'meeting_id'  => $meeting ? $meeting->id : null,
                'pertemuan'   => $request->meeting_number,
                'title'       => $request->title,
                'description' => $request->description,
                'file_url'    => $request->file_url,
                'youtube_url' => $request->youtube_url,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Materi berhasil disimpan',
                'data'    => $material
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan materi',
                'error'   => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Detail materi
     */
    public function show(Material $material)
    {
        $material->load(['classroom', 'meeting']);

        return response()->json([
            'success' => true,
            'data' => [
                'id' => $material->id,
                'class_id' => $material->class_id,
                'class_name' => optional($material->classroom)->class_name,
                'meeting_id' => $material->meeting_id,
                'meeting_name' => optional($material->meeting)->nama_pertemuan,
                'pertemuan' => $material->pertemuan,
                'title' => $material->title,
                'description' => $material->description,
                'file_url' => $material->file_url,
                'youtube_url' => $material->youtube_url,
                'created_at' => $material->created_at,
            ]
        ]);
    }

    /**
     * Hapus materi
     */
    public function destroy($id)
    {
        try {
            $material = Material::find($id);

            if (!$material) {
                return response()->json([
                    'success' => false,
                    'message' => 'Materi tidak ditemukan'
                ], 404);
            }

            $material->delete();

            return response()->json([
                'success' => true,
                'message' => 'Materi berhasil dihapus'
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus materi',
                'error'   => $e->getMessage()
            ], 500);
        }
    }
}