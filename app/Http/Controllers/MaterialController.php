<?php

namespace App\Http\Controllers;

use App\Models\Material;
use App\Models\ClassRoom;
use App\Models\Meeting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class MaterialController extends Controller
{
    public function index()
    {
        $materials = Material::with(['classroom','meeting'])
            ->latest()
            ->paginate(10);

        return view('materials.index', compact('materials'));
    }

    public function create()
    {
        $classes = ClassRoom::orderBy('class_name')->get();
        $meetings = Meeting::orderBy('pertemuan')->get();

        return view('materials.create', compact(
            'classes',
            'meetings'
        ));
    }

    public function store(Request $request)
    {
        $request->validate([
            'class_id'=>'required',
            'meeting_id'=>'required',
            'title'=>'required',
            'file'=>'nullable|file|max:20480',
            'youtube_url'=>'nullable|url'
        ]);

        $file = null;

        if($request->hasFile('file')){
            $file = $request->file('file')
                    ->store('materials','public');
        }

        Material::create([
            'class_id'=>$request->class_id,
            'meeting_id'=>$request->meeting_id,
            'pertemuan'=>$request->pertemuan,
            'title'=>$request->title,
            'description'=>$request->description,
            'file_url'=>$file,
            'youtube_url'=>$request->youtube_url,
        ]);

        return redirect()
            ->route('materials.index')
            ->with('success','Materi berhasil ditambahkan');
    }

    public function show(Material $material)
    {
        return view('materials.show', compact('material'));
    }

    public function edit(Material $material)
    {
        $classes = ClassRoom::all();
        $meetings = Meeting::all();

        return view('materials.edit', compact(
            'material',
            'classes',
            'meetings'
        ));
    }

    public function update(Request $request, Material $material)
    {
        if($request->hasFile('file')){

            if($material->file_url){
                Storage::disk('public')
                    ->delete($material->file_url);
            }

            $material->file_url = $request->file('file')
                    ->store('materials','public');
        }

        $material->update([
            'class_id'=>$request->class_id,
            'meeting_id'=>$request->meeting_id,
            'pertemuan'=>$request->pertemuan,
            'title'=>$request->title,
            'description'=>$request->description,
            'youtube_url'=>$request->youtube_url,
            'file_url'=>$material->file_url
        ]);

        return redirect()
            ->route('materials.index')
            ->with('success','Materi berhasil diupdate');
    }

    public function destroy(Material $material)
    {
        if($material->file_url){
            Storage::disk('public')
                ->delete($material->file_url);
        }

        $material->delete();

        return back()->with('success','Materi berhasil dihapus');
    }
}