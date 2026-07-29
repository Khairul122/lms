<?php

namespace App\Http\Controllers;

use App\Models\Discussion;
use App\Models\ClassRoom;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DiscussionController extends Controller
{
    public function index()
    {
        // Tambahkan relasi 'meeting' ke dalam array with agar ikut ter-load secara efisien
        $discussions = Discussion::with(['classroom', 'user', 'meeting'])
            ->latest()
            ->paginate(10);

        return view('discussions.index', compact('discussions'));
    }

    public function create()
    {
        $classes = ClassRoom::all();

        return view('discussions.create', compact('classes'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'class_id' => 'required|exists:class_rooms,id',
            'message' => 'required|string',
        ]);

        Discussion::create([
            'class_id' => $request->class_id,
            'user_id' => Auth::id(),
            'message' => $request->message,
        ]);

        return redirect()
            ->route('discussions.index')
            ->with('success','Diskusi berhasil ditambahkan.');
    }

    public function show(Discussion $discussion)
    {
        return view('discussions.show', compact('discussion'));
    }

    public function edit(Discussion $discussion)
    {
        $classes = ClassRoom::all();

        return view('discussions.edit', compact('discussion','classes'));
    }

    public function update(Request $request, Discussion $discussion)
    {
        $request->validate([
            'class_id' => 'required|exists:class_rooms,id',
            'message' => 'required|string',
        ]);

        $discussion->update([
            'class_id' => $request->class_id,
            'message' => $request->message,
        ]);

        return redirect()
            ->route('discussions.index')
            ->with('success','Diskusi berhasil diperbarui.');
    }

    public function destroy(Discussion $discussion)
    {
        $discussion->delete();

        return back()->with('success','Diskusi berhasil dihapus.');
    }
}