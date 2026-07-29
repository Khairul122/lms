<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\ClassRoom;
use App\Models\Meeting;
use App\Models\Material;
use App\Models\Task;
use App\Models\Submission;

class DashboardController extends Controller
{
    public function index()
    {
        return view('dashboard.index', [

            'guru' => User::where('role', 'guru')->count(),

            'siswa' => User::where('role', 'siswa')->count(),

            'kelas' => ClassRoom::count(),

            'materi' => Material::count(),

            'meeting' => Meeting::count(),

            'tugas' => Task::count(),

            'submission' => Submission::count(),

            'users' => User::latest()->take(5)->get()

        ]);
    }
}