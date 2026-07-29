<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\SubmissionResource;
use App\Models\Submission;
use App\Services\SubmissionService;
use App\Actions\Submission\StoreSubmissionAction;
use App\Actions\Submission\GradeSubmissionAction;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;

class SubmissionController extends Controller
{
    use ApiResponse;

    protected SubmissionService $submissionService;

    public function __construct(SubmissionService $submissionService)
    {
        $this->submissionService = $submissionService;
    }

    /**
     * Daftar submission
     */
    public function index()
    {
        $submissions = $this->submissionService->getAllSubmissions();

        return $this->success(SubmissionResource::collection($submissions), 'Data submission berhasil diambil.');
    }

    /**
     * Detail submission
     */
    public function show(Submission $submission)
    {
        $submission->load(['task', 'student']);

        return $this->success([
            'id'           => $submission->id,
            'task'         => $submission->task,
            'student'      => $submission->student,
            'file_path'    => $submission->file_path,
            'note'         => $submission->note,
            'score'        => $submission->score,
            'teacher_note' => $submission->teacher_note,
            'submitted_at' => $submission->submitted_at,
        ]);
    }

    /**
     * Upload submission (Siswa)
     */
    public function store(Request $request, StoreSubmissionAction $action)
    {
        $request->validate([
            'task_id'  => 'required',
            'file'     => 'nullable|file|max:20480',
            'file_url' => 'nullable|string',
            'note'     => 'nullable|string',
        ]);

        $submission = $action->execute($request);

        return $this->created($submission, 'Submission berhasil dikirim ke server.');
    }

    /**
     * Penilaian submission (Guru)
     */
    public function update(Request $request, $id, GradeSubmissionAction $action)
    {
        $submission = $action->execute($id, $request->all());

        return $this->success($submission, 'Penilaian tugas berhasil diperbarui.');
    }
}
