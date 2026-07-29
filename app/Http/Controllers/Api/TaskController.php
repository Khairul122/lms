<?php

namespace App\Http\Controllers\Api;

use App\Actions\Task\CreateTaskAction;
use App\Actions\Task\DeleteTaskAction;
use App\Http\Controllers\Controller;
use App\Http\Resources\TaskResource;
use App\Models\Task;
use App\Services\TaskService;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class TaskController extends Controller
{
    use ApiResponse;

    public function __construct(protected TaskService $taskService)
    {
    }

    /**
     * Dipanggil oleh Flutter: GET /api/tasks?class_code=...&pertemuan=...
     */
    public function index(Request $request)
    {
        $tasks = $this->taskService->listForApi($request->only(['class_code', 'pertemuan']));

        return $this->success(TaskResource::collection($tasks), 'Data tugas berhasil diambil.');
    }

    public function store(Request $request, CreateTaskAction $action)
    {
        $validator = Validator::make($request->all(), [
            'class_code'     => 'required|string',
            'meeting_number' => 'required|integer',
            'title'          => 'required|string|max:255',
            'description'    => 'nullable|string',
            'deadline'       => 'required|date',
        ]);

        if ($validator->fails()) {
            return $this->error('Validasi gagal', 422, $validator->errors());
        }

        $class = $this->taskService->findClassByCode($request->class_code);

        if (!$class) {
            return $this->notFound('Kelas tidak ditemukan.');
        }

        $meeting = $this->taskService->findMeetingByNumber($class->id, (int) $request->meeting_number);

        $task = $action->execute([
            'class_id'   => $class->id,
            'meeting_id' => $meeting?->id,
            'title'      => $request->title,
            'description'=> $request->description,
            'deadline'   => $request->deadline,
        ]);

        return $this->created($task, 'Tugas berhasil disimpan');
    }

    public function show(Task $task)
    {
        return $this->success(new TaskResource($task), 'Detail tugas berhasil diambil');
    }

    public function destroy(Task $task, DeleteTaskAction $action)
    {
        $action->execute($task);

        return $this->success(null, 'Tugas berhasil dihapus');
    }
}
