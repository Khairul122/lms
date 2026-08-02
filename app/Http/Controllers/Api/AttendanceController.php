<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Attendance;
use App\Models\ClassRoom;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class AttendanceController extends Controller
{
    use ApiResponse;

    /**
     * Helper privat untuk mencari ClassRoom berdasarkan class_code atau id
     */
    private function findClassRoom(?string $codeOrId): ?ClassRoom
    {
        if (!$codeOrId) return null;
        $term = trim($codeOrId);
        return ClassRoom::whereRaw('LOWER(class_code) = ?', [strtolower($term)])
            ->orWhere('id', $term)
            ->first();
    }

    /**
     * Helper privat untuk mengambil daftar siswa terdaftar di suatu kelas
     */
    private function getStudentsInClass(ClassRoom $classRoom)
    {
        $classRoom->load(['students', 'members.user']);

        $students = $classRoom->students;
        if ($students->isEmpty() && $classRoom->members) {
            $students = $classRoom->members->map(function ($m) {
                return $m->user;
            })->filter()->values();
        }
        return $students;
    }

    /**
     * Ambil data absensi per kelas, tanggal, dan meeting (opsional).
     */
    public function index(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'class_code' => 'required|string',
            'date'       => 'nullable|date_format:Y-m-d',
            'meeting_id' => 'nullable|integer',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first(), 422);
        }

        $classRoom = $this->findClassRoom($request->class_code);
        if (!$classRoom) {
            return $this->notFound('Kelas tidak ditemukan.');
        }

        $date = $request->date ?? Carbon::now()->toDateString();
        $meetingId = $request->meeting_id;

        // Ambil murid yang terdaftar di kelas ini
        $students = $this->getStudentsInClass($classRoom);

        // Ambil data absensi yang sudah tercatat
        $query = Attendance::where('class_room_id', $classRoom->id)
            ->where('date', $date);

        if ($meetingId) {
            $query->where('meeting_id', $meetingId);
        }

        $existingAttendances = $query->get()->keyBy('student_id');

        $result = $students->map(function ($student) use ($existingAttendances) {
            $att = $existingAttendances->get($student->id);
            return [
                'student_id'    => $student->id,
                'student_name'  => $student->name,
                'name'          => $student->name,
                'student_nisn'  => $student->nisn ?? '-',
                'student_email' => $student->email ?? '',
                'status'        => $att ? $att->status : 'hadir',
                'notes'         => $att ? ($att->notes ?? '') : '',
            ];
        })->values();

        return $this->success([
            'class_id'    => $classRoom->id,
            'class_code'  => $classRoom->class_code,
            'class_name'  => $classRoom->class_name,
            'date'        => $date,
            'meeting_id'  => $meetingId,
            'attendances' => $result,
        ], 'Data absensi berhasil dimuat.');
    }

    /**
     * Simpan / update absensi secara bulk.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'class_code'               => 'required|string',
            'date'                     => 'required|date_format:Y-m-d',
            'meeting_id'               => 'nullable|integer',
            'attendances'              => 'required|array',
            'attendances.*.student_id' => 'required|integer|exists:users,id',
            'attendances.*.status'     => 'required|in:hadir,izin,sakit,alpa',
            'attendances.*.notes'      => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first(), 422);
        }

        $classRoom = $this->findClassRoom($request->class_code);
        if (!$classRoom) {
            return $this->notFound('Kelas tidak ditemukan.');
        }

        $date = $request->date;
        $meetingId = $request->meeting_id;
        $savedRecords = [];

        foreach ($request->attendances as $item) {
            $attendance = Attendance::updateOrCreate(
                [
                    'class_room_id' => $classRoom->id,
                    'student_id'    => $item['student_id'],
                    'date'          => $date,
                    'meeting_id'    => $meetingId,
                ],
                [
                    'status' => $item['status'],
                    'notes'  => $item['notes'] ?? null,
                ]
            );
            $savedRecords[] = $attendance;
        }

        return $this->success($savedRecords, 'Absensi siswa berhasil disimpan.');
    }

    /**
     * Rekapitulasi absensi siswa per kelas.
     */
    public function recap(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'class_code' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first(), 422);
        }

        $classRoom = $this->findClassRoom($request->class_code);
        if (!$classRoom) {
            return $this->notFound('Kelas tidak ditemukan.');
        }

        $students = $this->getStudentsInClass($classRoom);

        // Hitung total tanggal absensi yang unik di kelas ini
        $totalMeetings = Attendance::where('class_room_id', $classRoom->id)
            ->distinct('date')
            ->count('date');

        $recapData = $students->map(function ($student) use ($classRoom) {
            $attendances = Attendance::where('class_room_id', $classRoom->id)
                ->where('student_id', $student->id)
                ->get();

            $hadirCount = $attendances->where('status', 'hadir')->count();
            $izinCount  = $attendances->where('status', 'izin')->count();
            $sakitCount = $attendances->where('status', 'sakit')->count();
            $alpaCount  = $attendances->where('status', 'alpa')->count();

            return [
                'student_id'    => $student->id,
                'student_name'  => $student->name,
                'name'          => $student->name,
                'student_nisn'  => $student->nisn ?? '-',
                'student_email' => $student->email ?? '',
                'hadir'         => $hadirCount,
                'izin'          => $izinCount,
                'sakit'         => $sakitCount,
                'alpa'          => $alpaCount,
                'total'         => $hadirCount + $izinCount + $sakitCount + $alpaCount,
            ];
        })->values();

        return $this->success([
            'class_code'     => $classRoom->class_code,
            'class_name'     => $classRoom->class_name,
            'total_meetings' => $totalMeetings,
            'recap'          => $recapData,
        ], 'Rekapitulasi absensi berhasil dimuat.');
    }
}
