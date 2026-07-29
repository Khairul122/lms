<?php

namespace App\Http\Controllers;

use App\Actions\Submission\DeleteSubmissionAction;
use App\Actions\Submission\GradeSubmissionAction;
use App\Actions\Submission\StoreSubmissionAction;
use App\Models\Submission;
use App\Models\Task;
use Illuminate\Http\Request;

class SubmissionController extends Controller
{
    public function index()
    {
        $submissions = Submission::with([
            'task',
            'student',
        ])
            ->latest()
            ->paginate(10);

        return view('submissions.index', compact('submissions'));
    }

    public function create()
    {
        $tasks = Task::where('is_active', true)->get();

        return view('submissions.create', compact('tasks'));
    }

    public function store(Request $request, StoreSubmissionAction $action)
    {
        $request->validate([
            'task_id' => 'required',
            'file'    => 'required|file|max:20480',
            'note'    => 'nullable|string',
        ]);

        $action->execute($request);

        return redirect()
            ->route('submissions.index')
            ->with('success', 'Tugas berhasil dikumpulkan.');
    }

    public function show(Submission $submission)
    {
        return view('submissions.show', compact('submission'));
    }

    public function edit(Submission $submission)
    {
        return view('submissions.edit', compact('submission'));
    }

    public function update(Request $request, Submission $submission, GradeSubmissionAction $action)
    {
        $action->execute($submission->id, $request->only(['score', 'teacher_note']));

        return redirect()
            ->route('submissions.index')
            ->with('success', 'Nilai berhasil disimpan.');
    }

    public function destroy(Submission $submission, DeleteSubmissionAction $action)
    {
        $action->execute($submission);

        return back()->with('success', 'Submission dihapus.');
    }
}
