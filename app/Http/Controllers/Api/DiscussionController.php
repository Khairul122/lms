<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Classroom;
use App\Models\Discussion;
use Illuminate\Http\Request;


class DiscussionController extends Controller
{
    public function index(Request $request)
{
    $query = Discussion::with(['classroom','user']);

    if ($request->filled('class_code')) {

        $classroom = Classroom::where(
            'class_code',
            $request->class_code
        )->first();

        if ($classroom) {

            $query->where(
                'class_id',
                $classroom->id
            );

        }

    }

    $discussions = $query
        ->latest()
        ->get()
        ->map(function ($discussion){

            return [

                'id'=>$discussion->id,

                'class_code'=>optional($discussion->classroom)->class_code,

                'class_name'=>optional($discussion->classroom)->class_name,

                'user_name'=>optional($discussion->user)->name,

                'message'=>$discussion->message,

                'created_at'=>$discussion->created_at,

            ];

        });

    return response()->json([

        'success'=>true,

        'data'=>$discussions,

    ]);
}

public function store(Request $request)
{
    $request->validate([
        'class_code' => 'required|string',
        'message' => 'required|string',
    ]);

    $classroom = Classroom::where(
        'class_code',
        $request->class_code
    )->first();

    if (!$classroom) {
        return response()->json([
            'success' => false,
            'message' => 'Kelas tidak ditemukan.'
        ], 404);
    }

    $discussion = Discussion::create([
        'class_id' => $classroom->id,
        'user_id' => auth()->id(),
        'message' => $request->message,
    ]);

    return response()->json([
        'success' => true,
        'message' => 'Diskusi berhasil ditambahkan.',
        'data' => $discussion,
    ]);
}
}
