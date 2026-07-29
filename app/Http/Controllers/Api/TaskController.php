<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Task;
use App\Models\ClassRoom;
use App\Models\Meeting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class TaskController extends Controller
{
    /**
     * Display a listing of the tasks.
     * Dipanggil oleh Flutter: GET /api/tasks?class_code=...&pertemuan=...
     */
    public function index(Request $request)
    {
        try {
            $query = Task::query();

            // Jika Flutter mengirimkan param class_code & pertemuan
            if ($request->has('class_code')) {
                $class = ClassRoom::where('class_code', $request->class_code)->first();

                if ($class) {
                    $query->where('class_id', $class->id);

                    // Filter berdasarkan nomor pertemuan jika ada
                    if ($request->has('pertemuan')) {
                        $meeting = Meeting::where('class_id', $class->id)
                            ->where('pertemuan', $request->pertemuan)
                            ->first();

                        if ($meeting) {
                            $query->where('meeting_id', $meeting->id);
                        } else {
                            // Jika meeting tidak ditemukan, kembalikan array kosong
                            return response()->json([
                                'success' => true,
                                'message' => 'Data tugas berhasil diambil.',
                                'data'    => []
                            ], 200);
                        }
                    }
                } else {
                    // Jika kelas tidak ditemukan, kembalikan array kosong
                    return response()->json([
                        'success' => true,
                        'message' => 'Data tugas berhasil diambil.',
                        'data'    => []
                    ], 200);
                }
            }

            $tasks = $query->latest()->get();

            return response()->json([
                'success' => true,
                'message' => 'Data tugas berhasil diambil.',
                'data'    => $tasks
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data tugas',
                'error'   => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Store a newly created task in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'class_code'     => 'required|string',
            'meeting_number' => 'required|integer',
            'title'          => 'required|string|max:255',
            'description'    => 'nullable|string',
            'deadline'       => 'required|date',
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

            // Simpan task
            $task = Task::create([
                'class_id'   => $class->id,
                'meeting_id' => $meeting ? $meeting->id : null,
                'title'      => $request->title,
                'description' => $request->description,
                'deadline'   => $request->deadline,
                'max_score'  => 100,
                'is_active'  => true,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Tugas berhasil disimpan',
                'data'    => $task
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan tugas',
                'error'   => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified task.
     */
    public function show($id)
    {
        try {
            $task = Task::find($id);

            if (!$task) {
                return response()->json([
                    'success' => false,
                    'message' => 'Tugas tidak ditemukan'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'message' => 'Detail tugas berhasil diambil',
                'data'    => $task
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil detail tugas',
                'error'   => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified task from storage.
     */
    public function destroy($id)
    {
        try {
            $task = Task::find($id);

            if (!$task) {
                return response()->json([
                    'success' => false,
                    'message' => 'Tugas tidak ditemukan'
                ], 404);
            }

            $task->delete();

            return response()->json([
                'success' => true,
                'message' => 'Tugas berhasil dihapus'
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus tugas',
                'error'   => $e->getMessage()
            ], 500);
        }
    }
}