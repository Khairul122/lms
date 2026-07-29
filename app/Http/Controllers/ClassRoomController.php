<?php

namespace App\Http\Controllers;

use App\Actions\Classroom\CreateClassroomAction;
use App\Actions\Classroom\DeleteClassroomAction;
use App\Actions\Classroom\UpdateClassroomAction;
use App\Models\ClassRoom;
use App\Models\User;
use App\Http\Requests\ClassRoom\StoreClassRoomRequest;
use App\Http\Requests\ClassRoom\UpdateClassRoomRequest;
use Illuminate\Http\Request;

class ClassRoomController extends Controller
{
    public function index(Request $request)
    {
        $classes = ClassRoom::with('teacher')
            ->when($request->search, function ($query) use ($request) {
                $query->where('class_name', 'like', '%' . $request->search . '%')
                      ->orWhere('subject', 'like', '%' . $request->search . '%')
                      ->orWhere('class_code', 'like', '%' . $request->search . '%');
            })
            ->latest()
            ->paginate(10);

        return view('classes.index', compact('classes'));
    }

    public function create()
    {
        $teachers = User::where('role', 'guru')->get();

        return view('classes.create', compact('teachers'));
    }

    public function store(StoreClassRoomRequest $request, CreateClassroomAction $action)
    {
        $data = $request->validated();
        $data['class_code'] = strtoupper(\Illuminate\Support\Str::random(6));

        $action->execute($request->user(), $data);

        return redirect()
            ->route('classes.index')
            ->with('success', 'Kelas berhasil ditambahkan.');
    }

    public function show(ClassRoom $class)
    {
        $class->load([
            'teacher',
            'meetings',
            'materials',
            'tasks',
            'members',
        ]);

        return view('classes.show', compact('class'));
    }

    public function edit(ClassRoom $class)
    {
        $teachers = User::where('role', 'guru')->get();

        return view('classes.edit', compact('class', 'teachers'));
    }

    public function update(UpdateClassRoomRequest $request, ClassRoom $class, UpdateClassroomAction $action)
    {
        $action->execute($class, $request->validated());

        return redirect()
            ->route('classes.index')
            ->with('success', 'Kelas berhasil diperbarui.');
    }

    public function destroy(ClassRoom $class, DeleteClassroomAction $action)
    {
        $action->execute($class);

        return back()->with('success', 'Kelas berhasil dihapus.');
    }
}
