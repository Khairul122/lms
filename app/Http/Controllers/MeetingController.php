<?php

namespace App\Http\Controllers;

use App\Http\Requests\MeetingRequest;
use App\Models\Meeting;
use App\Models\ClassRoom;
use Illuminate\Http\Request;

class MeetingController extends Controller
{
    public function index(Request $request)
    {
        $meetings = Meeting::with('classroom')
            ->when($request->search, function ($query) use ($request) {
                $query->where('nama_pertemuan', 'like', '%' . $request->search . '%');
            })
            ->latest()
            ->paginate(10);

        return view('meetings.index', compact('meetings'));
    }

    public function create()
    {
        $classes = ClassRoom::orderBy('class_name')->get();

        return view('meetings.create', compact('classes'));
    }

    public function store(MeetingRequest $request)
    {
        Meeting::create($request->validated());

        return redirect()
            ->route('meetings.index')
            ->with('success', 'Pertemuan berhasil ditambahkan.');
    }

    public function show(Meeting $meeting)
    {
        $meeting->load('classroom');

        return view('meetings.show', compact('meeting'));
    }

    public function edit(Meeting $meeting)
    {
        $classes = ClassRoom::orderBy('class_name')->get();

        return view('meetings.edit', compact('meeting', 'classes'));
    }

    public function update(MeetingRequest $request, Meeting $meeting)
    {
        $meeting->update($request->validated());

        return redirect()
            ->route('meetings.index')
            ->with('success', 'Pertemuan berhasil diperbarui.');
    }

    public function destroy(Meeting $meeting)
    {
        $meeting->delete();

        return redirect()
            ->route('meetings.index')
            ->with('success', 'Pertemuan berhasil dihapus.');
    }
}