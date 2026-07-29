<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
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
        return response()->json([

            'success' => true,

            'statistics' => [

                'total_guru' => User::where('role', 'guru')->count(),

                'total_siswa' => User::where('role', 'siswa')->count(),

                'total_kelas' => ClassRoom::count(),

                'total_pertemuan' => Meeting::count(),

                'total_materi' => Material::count(),

                'total_tugas' => Task::count(),

                'total_submission' => Submission::count(),

            ]

        ]);
    }
}