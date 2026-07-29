<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Meeting;
use App\Models\ClassRoom;
use Illuminate\Support\Facades\Validator;

class MeetingController extends Controller
{
    /**
     * 🔥 Mengambil daftar pertemuan (Filtered per kelas)
     */
    public function index(Request $request)
    {
        $query = Meeting::with('classroom');

        // 1. Filter berdasarkan class_code (jika Flutter mengirim parameter ?class_code=XXXX)
        if ($request->has('class_code') && !empty($request->class_code)) {
            $classroom = ClassRoom::where('class_code', strtoupper(trim($request->class_code)))->first();
            
            if (!$classroom) {
                return response()->json([
                    'success' => true,
                    'message' => 'Kelas tidak ditemukan.',
                    'data'    => []
                ], 200);
            }

            $query->where('class_id', $classroom->id);
        }
        // 2. Filter berdasarkan class_id (jika Flutter mengirim parameter ?class_id=X)
        elseif ($request->has('class_id') && !empty($request->class_id)) {
            $query->where('class_id', $request->class_id);
        }

        // 3. Ambil data yang sudah difilter
        $meetings = $query->orderBy('pertemuan', 'asc')
            ->get()
            ->map(function ($meeting) {
                return [
                    'id'             => $meeting->id,
                    'class_id'       => $meeting->class_id,
                    'class_code'     => optional($meeting->classroom)->class_code,
                    'class_name'     => optional($meeting->classroom)->class_name,
                    'pertemuan'      => $meeting->pertemuan,
                    'nama_pertemuan' => $meeting->nama_pertemuan,
                    'tema_pertemuan' => $meeting->tema_pertemuan,
                    'created_at'     => $meeting->created_at,
                ];
            });

        return response()->json([
            'success' => true,
            'message' => 'Data pertemuan berhasil diambil.',
            'data'    => $meetings
        ], 200);
    }

    /**
     * 🔥 Menambah pertemuan baru untuk kelas tertentu
     */
    public function store(Request $request)
    {
        // 1. Validasi Input
        $validator = Validator::make($request->all(), [
            'class_code'     => 'required|string',
            'nama_pertemuan' => 'required|string|max:255',
            'tema_pertemuan' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors'  => $validator->errors()
            ], 422);
        }

        try {
            // 2. Cari Class ID berdasarkan class_code (misal: YMDUFJ)
            $classroom = ClassRoom::where('class_code', strtoupper(trim($request->class_code)))->first();

            if (!$classroom) {
                return response()->json([
                    'success' => false,
                    'message' => 'Kelas dengan kode tersebut tidak ditemukan.'
                ], 404);
            }

            // 3. Hitung nomor pertemuan otomatis per kelas
            $lastMeeting = Meeting::where('class_id', $classroom->id)->max('pertemuan');
            $nextPertemuan = ($lastMeeting ?? 0) + 1;

            // 4. Simpan ke database MySQL
            $meeting = Meeting::create([
                'class_id'       => $classroom->id,
                'pertemuan'      => $nextPertemuan,
                'nama_pertemuan' => $request->nama_pertemuan,
                'tema_pertemuan' => $request->tema_pertemuan,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Pertemuan berhasil ditambahkan.',
                'data'    => $meeting,
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan pertemuan.',
                'error'   => $e->getMessage()
            ], 500);
        }
    }
}