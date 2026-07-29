<?php

namespace App\Http\Controllers;

use App\Actions\Meeting\CreateMeetingAction;
use App\Actions\Meeting\DeleteMeetingAction;
use App\Actions\Meeting\UpdateMeetingAction;
use App\Http\Requests\Meeting\StoreMeetingRequest;
use App\Http\Requests\Meeting\UpdateMeetingRequest;
use App\Models\ClassRoom;
use App\Models\Meeting;
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

    public function store(StoreMeetingRequest $request, CreateMeetingAction $action)
    {
        $action->execute($request->validated());

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

    public function update(UpdateMeetingRequest $request, Meeting $meeting, UpdateMeetingAction $action)
    {
        $action->execute($meeting, $request->validated());

        return redirect()
            ->route('meetings.index')
            ->with('success', 'Pertemuan berhasil diperbarui.');
    }

    public function destroy(Meeting $meeting, DeleteMeetingAction $action)
    {
        $action->execute($meeting);

        return redirect()
            ->route('meetings.index')
            ->with('success', 'Pertemuan berhasil dihapus.');
    }
}
