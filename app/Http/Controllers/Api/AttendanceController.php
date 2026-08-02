<?php

namespace App\Http\Controllers\Api;

use App\Actions\Attendance\SaveAttendanceAction;
use App\Http\Controllers\Controller;
use App\Services\AttendanceService;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class AttendanceController extends Controller
{
    use ApiResponse;

    public function __construct(protected AttendanceService $attendanceService)
    {
    }

    /**
     * Daftar siswa & status absensi untuk satu pertemuan (?class_code=&pertemuan=)
     */
    public function index(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'class_code' => 'required|string',
            'pertemuan'  => 'required|integer',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first() ?? 'Validasi gagal.', 422, $validator->errors());
        }

        $class = $this->attendanceService->findClassByCode($request->class_code);

        if (!$class) {
            return $this->notFound('Kelas tidak ditemukan.');
        }

        $meeting = $this->attendanceService->findMeetingByNumber($class->id, (int) $request->pertemuan);

        if (!$meeting) {
            return $this->notFound('Pertemuan tidak ditemukan.');
        }

        return $this->success($this->attendanceService->listForMeeting($meeting), 'Data absensi berhasil diambil.');
    }

    /**
     * Simpan absensi (bulk) untuk satu pertemuan (Guru)
     */
    public function store(Request $request, SaveAttendanceAction $action)
    {
        $validator = Validator::make($request->all(), [
            'class_code'          => 'required|string',
            'pertemuan'           => 'required|integer',
            'records'             => 'required|array|min:1',
            'records.*.user_id'   => 'required|integer',
            'records.*.status'    => 'required|string|in:hadir,izin,sakit,alpa',
            'records.*.note'      => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first() ?? 'Validasi gagal.', 422, $validator->errors());
        }

        $class = $this->attendanceService->findClassByCode($request->class_code);

        if (!$class) {
            return $this->notFound('Kelas tidak ditemukan.');
        }

        $meeting = $this->attendanceService->findMeetingByNumber($class->id, (int) $request->pertemuan);

        if (!$meeting) {
            return $this->notFound('Pertemuan tidak ditemukan.');
        }

        $action->execute($meeting, $request->records);

        return $this->success($this->attendanceService->listForMeeting($meeting), 'Absensi berhasil disimpan.');
    }
}
