<?php

namespace App\Http\Controllers;

use App\Actions\Task\CreateTaskAction;
use App\Actions\Task\DeleteTaskAction;
use App\Actions\Task\UpdateTaskAction;
use App\Models\ClassRoom;
use App\Models\Meeting;
use App\Models\Task;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    public function index()
    {
        $tasks = Task::with(['classroom', 'meeting'])
            ->latest()
            ->paginate(10);

        return view('tasks.index', compact('tasks'));
    }

    public function create()
    {
        $classes = ClassRoom::all();
        $meetings = Meeting::all();

        return view('tasks.create', compact('classes', 'meetings'));
    }

    public function store(Request $request, CreateTaskAction $action)
    {
        $request->validate([
            'class_id'   => 'required',
            'meeting_id' => 'required',
            'title'      => 'required',
            'deadline'   => 'required',
            'max_score'  => 'required|numeric',
            'attachment' => 'nullable|file|max:20480',
        ]);

        $attachment = null;
        if ($request->hasFile('attachment')) {
            $attachment = $request->file('attachment')->store('tasks', 'public');
        }

        $action->execute([
            'class_id'    => $request->class_id,
            'meeting_id'  => $request->meeting_id,
            'title'       => $request->title,
            'description' => $request->description,
            'deadline'    => $request->deadline,
            'max_score'   => $request->max_score,
            'attachment'  => $attachment,
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

        return view('tasks.edit', compact('task', 'classes', 'meetings'));
    }

    public function update(Request $request, Task $task, UpdateTaskAction $action)
    {
        $newAttachmentPath = null;
        if ($request->hasFile('attachment')) {
            $newAttachmentPath = $request->file('attachment')->store('tasks', 'public');
        }

        $action->execute($task, [
            'class_id'            => $request->class_id,
            'meeting_id'          => $request->meeting_id,
            'title'               => $request->title,
            'description'         => $request->description,
            'deadline'            => $request->deadline,
            'max_score'           => $request->max_score,
            'is_active'           => $request->boolean('is_active'),
            'new_attachment_path' => $newAttachmentPath,
        ]);

        return redirect()
            ->route('tasks.index')
            ->with('success', 'Tugas berhasil diupdate.');
    }

    public function destroy(Task $task, DeleteTaskAction $action)
    {
        $action->execute($task);

        return back()->with('success', 'Tugas berhasil dihapus.');
    }
}
