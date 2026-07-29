<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ClassRoom;
use App\Services\ClassroomService;
use App\Actions\Classroom\CreateClassroomAction;
use App\Actions\Classroom\JoinClassroomAction;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Exception;

class ClassController extends Controller
{
    protected ClassroomService $classroomService;

    public function __construct(ClassroomService $classroomService)
    {
        $this->classroomService = $classroomService;
    }

    /**
     * Daftar kelas sesuai Role User (Guru / Siswa)
     */
    public function index(Request $request)
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthenticated / Token tidak valid.'
            ], 401);
        }

        $classes = $this->classroomService->getClassesForUser($user);
        $formattedClasses = $this->classroomService->formatClassroomResponse($classes);

        return response()->json([
            'success' => true,
            'message' => 'Data kelas berhasil diambil.',
            'data'    => $formattedClasses,
        ], 200);
    }

    /**
     * Membuat Kelas Baru (Oleh Guru)
     */
    public function store(Request $request, CreateClassroomAction $action)
    {
        $validator = Validator::make($request->all(), [
            'class_code' => 'required|string|unique:class_rooms,class_code',
            'class_name' => 'required|string|max:255',
            'subject'    => 'required|string|max:255',
            'school_name'=> 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first() ?? 'Validasi gagal.',
                'errors'  => $validator->errors()
            ], 422);
        }

        $user = $request->user();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthenticated / Token tidak valid.'
            ], 401);
        }

        $class = $action->execute($user, $request->all());

        return response()->json([
            'success' => true,
            'message' => 'Kelas baru berhasil dibuat.',
            'data'    => [
                'id'             => $class->id,
                'class_code'     => $class->class_code,
                'class_name'     => $class->class_name,
                'subject'        => $class->subject,
                'teacher'        => $class->teacher?->name ?? 'Pengajar',
                'description'    => $class->description,
                'students_count' => 0,
                'is_active'      => $class->is_active,
                'created_at'     => $class->created_at,
            ]
        ], 201);
    }

    /**
     * Method Join Kelas untuk Siswa
     */
    public function joinClass(Request $request, JoinClassroomAction $action)
    {
        try {
            $validator = Validator::make($request->all(), [
                'class_code' => 'required|string',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => $validator->errors()->first('class_code') ?? 'Kode kelas wajib diisi!',
                    'errors'  => $validator->errors()
                ], 422);
            }

            $user = $request->user();

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'Unauthenticated / Sesi login habis.'
                ], 401);
            }

            $class = $action->execute($user, $request->class_code);

            return response()->json([
                'success' => true,
                'message' => 'Berhasil bergabung ke kelas ' . $class->class_name,
                'data'    => [
                    'id'         => $class->id,
                    'class_code' => $class->class_code,
                    'class_name' => $class->class_name,
                    'subject'    => $class->subject,
                    'teacher'    => $class->teacher?->name ?? 'Pengajar',
                ]
            ], 200);

        } catch (Exception $e) {
            $code = $e->getCode() >= 400 && $e->getCode() < 600 ? $e->getCode() : 500;
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], $code);
        }
    }

    /**
     * Detail kelas
     */
    public function show(ClassRoom $class)
    {
        $class->load('teacher');
        $class->loadCount('students');

        return response()->json([
            'success' => true,
            'message' => 'Detail kelas berhasil diambil.',
            'data'    => [
                'id'             => $class->id,
                'class_code'     => $class->class_code,
                'class_name'     => $class->class_name,
                'subject'        => $class->subject,
                'teacher'        => $class->teacher?->name ?? 'Pengajar',
                'description'    => $class->description,
                'students_count' => $class->students_count ?? 0,
                'is_active'      => $class->is_active,
                'created_at'     => $class->created_at,
            ]
        ], 200);
    }
}