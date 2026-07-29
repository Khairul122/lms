<?php

namespace App\Http\Controllers\Api;

use App\Actions\Meeting\CreateMeetingAction;
use App\Actions\Meeting\DeleteMeetingAction;
use App\Actions\Meeting\UpdateMeetingAction;
use App\Http\Controllers\Controller;
use App\Http\Resources\MeetingResource;
use App\Models\Meeting;
use App\Services\MeetingService;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class MeetingController extends Controller
{
    use ApiResponse;

    public function __construct(protected MeetingService $meetingService)
    {
    }

    /**
     * Mengambil daftar pertemuan (filtered per kelas)
     */
    public function index(Request $request)
    {
        $meetings = $this->meetingService->listForApi($request->only(['class_code', 'class_id']));

        return $this->success(MeetingResource::collection($meetings), 'Data pertemuan berhasil diambil.');
    }

    /**
     * Menambah pertemuan baru untuk kelas tertentu
     */
    public function store(Request $request, CreateMeetingAction $action)
    {
        $validator = Validator::make($request->all(), [
            'class_code'     => 'required|string',
            'nama_pertemuan' => 'required|string|max:255',
            'tema_pertemuan' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return $this->error('Validasi gagal', 422, $validator->errors());
        }

        $classroom = $this->meetingService->findClassByCode($request->class_code);

        if (!$classroom) {
            return $this->notFound('Kelas dengan kode tersebut tidak ditemukan.');
        }

        $meeting = $action->execute([
            'class_id'       => $classroom->id,
            'pertemuan'      => $this->meetingService->nextPertemuanNumber($classroom->id),
            'nama_pertemuan' => $request->nama_pertemuan,
            'tema_pertemuan' => $request->tema_pertemuan,
        ]);

        return $this->created($meeting, 'Pertemuan berhasil ditambahkan.');
    }

    public function show(Meeting $meeting)
    {
        $meeting->load('classroom');

        return $this->success(new MeetingResource($meeting), 'Detail pertemuan berhasil diambil.');
    }

    public function update(Request $request, Meeting $meeting, UpdateMeetingAction $action)
    {
        $validator = Validator::make($request->all(), [
            'nama_pertemuan' => 'sometimes|string|max:255',
            'tema_pertemuan' => 'sometimes|string|max:255',
        ]);

        if ($validator->fails()) {
            return $this->error('Validasi gagal', 422, $validator->errors());
        }

        $meeting = $action->execute($meeting, $request->only(['nama_pertemuan', 'tema_pertemuan']));

        return $this->success($meeting, 'Pertemuan berhasil diperbarui.');
    }

    public function destroy(Meeting $meeting, DeleteMeetingAction $action)
    {
        $action->execute($meeting);

        return $this->success(null, 'Pertemuan berhasil dihapus.');
    }
}
