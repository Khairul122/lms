<?php

namespace App\Http\Controllers;

use App\Models\ClassRoom;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use App\Http\Requests\ClassRoomRequest;

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

    public function store(ClassRoomRequest $request)
    {
        $request->validate([
            'class_name' => 'required',
            'subject' => 'required',
            'teacher_id' => 'nullable|exists:users,id',
        ]);

        ClassRoom::create([
            'class_code' => strtoupper(Str::random(6)),
            'class_name' => $request->class_name,
            'subject' => $request->subject,
            'teacher_id' => $request->teacher_id,
            'description' => $request->description,
            'is_active' => true,
        ]);

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
        'members'
    ]);

    return view(
        'classes.show',
        compact('class')
    );
}


    public function edit(ClassRoom $class)
    {
        $teachers = User::where('role', 'guru')->get();

        return view('classes.edit', compact('class', 'teachers'));
    }

    public function update(ClassRoomRequest $request, ClassRoom $class)
    {
        $class->update($request->only([
            'class_name',
            'subject',
            'teacher_id',
            'description',
            'is_active'
        ]));

        return redirect()
            ->route('classes.index')
            ->with('success', 'Kelas berhasil diperbarui.');
    }

    public function destroy(ClassRoom $class)
    {
        $class->delete();

        return back()->with('success', 'Kelas berhasil dihapus.');
    }
}