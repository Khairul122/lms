<?php

namespace App\Http\Controllers;

use App\Actions\Material\CreateMaterialAction;
use App\Actions\Material\DeleteMaterialAction;
use App\Actions\Material\UpdateMaterialAction;
use App\Models\ClassRoom;
use App\Models\Material;
use App\Models\Meeting;
use Illuminate\Http\Request;

class MaterialController extends Controller
{
    public function index()
    {
        $materials = Material::with(['classroom', 'meeting'])
            ->latest()
            ->paginate(10);

        return view('materials.index', compact('materials'));
    }

    public function create()
    {
        $classes = ClassRoom::orderBy('class_name')->get();
        $meetings = Meeting::orderBy('pertemuan')->get();

        return view('materials.create', compact('classes', 'meetings'));
    }

    public function store(Request $request, CreateMaterialAction $action)
    {
        $request->validate([
            'class_id'    => 'required',
            'meeting_id'  => 'required',
            'title'       => 'required',
            'file'        => 'nullable|file|max:20480',
            'youtube_url' => 'nullable|url',
        ]);

        $fileUrl = null;
        if ($request->hasFile('file')) {
            $fileUrl = $request->file('file')->store('materials', 'public');
        }

        $action->execute([
            'class_id'    => $request->class_id,
            'meeting_id'  => $request->meeting_id,
            'pertemuan'   => $request->pertemuan,
            'title'       => $request->title,
            'description' => $request->description,
            'file_url'    => $fileUrl,
            'youtube_url' => $request->youtube_url,
        ]);

        return redirect()
            ->route('materials.index')
            ->with('success', 'Materi berhasil ditambahkan');
    }

    public function show(Material $material)
    {
        return view('materials.show', compact('material'));
    }

    public function edit(Material $material)
    {
        $classes = ClassRoom::all();
        $meetings = Meeting::all();

        return view('materials.edit', compact('material', 'classes', 'meetings'));
    }

    public function update(Request $request, Material $material, UpdateMaterialAction $action)
    {
        $newFilePath = null;
        if ($request->hasFile('file')) {
            $newFilePath = $request->file('file')->store('materials', 'public');
        }

        $action->execute($material, [
            'class_id'      => $request->class_id,
            'meeting_id'    => $request->meeting_id,
            'pertemuan'     => $request->pertemuan,
            'title'         => $request->title,
            'description'   => $request->description,
            'youtube_url'   => $request->youtube_url,
            'new_file_path' => $newFilePath,
        ]);

        return redirect()
            ->route('materials.index')
            ->with('success', 'Materi berhasil diupdate');
    }

    public function destroy(Material $material, DeleteMaterialAction $action)
    {
        $action->execute($material);

        return back()->with('success', 'Materi berhasil dihapus');
    }
}
