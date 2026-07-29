<?php

namespace App\Http\Controllers;

use App\Models\Task;
use App\Models\Meeting;
use App\Models\ClassRoom;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class TaskController extends Controller
{
    public function index()
    {
        $tasks = Task::with([
            'classroom',
            'meeting'
        ])
        ->latest()
        ->paginate(10);

        return view('tasks.index', compact('tasks'));
    }

    public function create()
    {
        $classes = ClassRoom::all();
        $meetings = Meeting::all();

        return view('tasks.create', compact(
            'classes',
            'meetings'
        ));
    }

    public function store(Request $request)
    {
        $request->validate([
            'class_id' => 'required',
            'meeting_id' => 'required',
            'title' => 'required',
            'deadline' => 'required',
            'max_score' => 'required|numeric',
            'attachment' => 'nullable|file|max:20480'
        ]);

        $file = null;

        if ($request->hasFile('attachment')) {
            $file = $request->file('attachment')
                ->store('tasks', 'public');
        }

        Task::create([
            'class_id' => $request->class_id,
            'meeting_id' => $request->meeting_id,
            'title' => $request->title,
            'description' => $request->description,
            'deadline' => $request->deadline,
            'max_score' => $request->max_score,
            'attachment' => $file,
            'is_active' => true,
        ]);

        return redirect()
            ->route('tasks.index')
            ->with('success', 'Tugas berhasil ditambahkan.');
    }

    public function show(Task $task)
    {
        return view('tasks.show', compact('task'));
    }

    public function edit(Task $task)
    {
        $classes = ClassRoom::all();
        $meetings = Meeting::all();

        return view('tasks.edit', compact(
            'task',
            'classes',
            'meetings'
        ));
    }

    public function update(Request $request, Task $task)
    {
        if ($request->hasFile('attachment')) {

            if ($task->attachment) {
                Storage::disk('public')->delete($task->attachment);
            }

            $task->attachment = $request->file('attachment')
                ->store('tasks', 'public');
        }

        $task->update([
            'class_id' => $request->class_id,
            'meeting_id' => $request->meeting_id,
            'title' => $request->title,
            'description' => $request->description,
            'deadline' => $request->deadline,
            'max_score' => $request->max_score,
            'attachment' => $task->attachment,
            'is_active' => $request->boolean('is_active'),
        ]);

        return redirect()
            ->route('tasks.index')
            ->with('success', 'Tugas berhasil diupdate.');
    }

    public function destroy(Task $task)
    {
        if ($task->attachment) {
            Storage::disk('public')->delete($task->attachment);
        }

        $task->delete();

        return back()->with('success', 'Tugas berhasil dihapus.');
    }
}