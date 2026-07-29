<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ClassRoomResource;
use App\Models\ClassRoom;
use App\Services\ClassroomService;
use App\Actions\Classroom\CreateClassroomAction;
use App\Actions\Classroom\JoinClassroomAction;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Exception;

class ClassController extends Controller
{
    use ApiResponse;

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
            return $this->unauthorized('Unauthenticated / Token tidak valid.');
        }

        $classes = $this->classroomService->getClassesForUser($user);

        return $this->success(ClassRoomResource::collection($classes), 'Data kelas berhasil diambil.');
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
            return $this->error($validator->errors()->first() ?? 'Validasi gagal.', 422, $validator->errors());
        }

        $user = $request->user();

        if (!$user) {
            return $this->unauthorized('Unauthenticated / Token tidak valid.');
        }

        $class = $action->execute($user, $request->all());

        return $this->created(new ClassRoomResource($class), 'Kelas baru berhasil dibuat.');
    }

    /**
     * Method Join Kelas untuk Siswa
     */
    public function joinClass(Request $request, JoinClassroomAction $action)
    {
        $validator = Validator::make($request->all(), [
            'class_code' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->error($validator->errors()->first('class_code') ?? 'Kode kelas wajib diisi!', 422, $validator->errors());
        }

        $user = $request->user();

        if (!$user) {
            return $this->unauthorized('Unauthenticated / Sesi login habis.');
        }

        try {
            $class = $action->execute($user, $request->class_code);
        } catch (Exception $e) {
            $code = $e->getCode() >= 400 && $e->getCode() < 600 ? $e->getCode() : 500;
            return $this->error($e->getMessage(), $code);
        }

        return $this->success(new ClassRoomResource($class), 'Berhasil bergabung ke kelas ' . $class->class_name);
    }

    /**
     * Detail kelas
     */
    public function show(ClassRoom $class)
    {
        $class->load(['teacher', 'students']);
        $class->loadCount('students');

        return $this->success(new ClassRoomResource($class), 'Detail kelas berhasil diambil.');
    }
}
