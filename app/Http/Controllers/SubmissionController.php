<?php

namespace App\Http\Controllers;

use App\Models\Submission;
use App\Models\Task;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class SubmissionController extends Controller
{
    public function index()
    {
        $submissions = Submission::with([
            'task',
            'student'
        ])
        ->latest()
        ->paginate(10);

        return view(
            'submissions.index',
            compact('submissions')
        );
    }

    public function create()
    {
        $tasks = Task::where('is_active', true)->get();

        return view(
            'submissions.create',
            compact('tasks')
        );
    }

    public function store(Request $request)
    {
        $request->validate([
            'task_id' => 'required',
            'file' => 'required|file|max:20480',
            'note' => 'nullable|string'
        ]);

        $file = $request->file('file')
            ->store('submissions', 'public');

        Submission::create([
            'task_id' => $request->task_id,
            'user_id' => Auth::id(),
            'file_path' => $file,
            'note' => $request->note,
            'submitted_at' => now(),
        ]);

        return redirect()
            ->route('submissions.index')
            ->with('success', 'Tugas berhasil dikumpulkan.');
    }

    public function show(Submission $submission)
    {
        return view(
            'submissions.show',
            compact('submission')
        );
    }

    public function edit(Submission $submission)
    {
        return view(
            'submissions.edit',
            compact('submission')
        );
    }

    public function update(Request $request, Submission $submission)
    {
        $submission->update([
            'score' => $request->score,
            'teacher_note' => $request->teacher_note,
        ]);

        return redirect()
            ->route('submissions.index')
            ->with('success', 'Nilai berhasil disimpan.');
    }

    public function destroy(Submission $submission)
    {
        if ($submission->file_path) {
            Storage::disk('public')
                ->delete($submission->file_path);
        }

        $submission->delete();

        return back()->with('success', 'Submission dihapus.');
    }
}