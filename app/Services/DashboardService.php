<?php

namespace App\Services;

use App\Models\ClassRoom;
use App\Models\Material;
use App\Models\Meeting;
use App\Models\Submission;
use App\Models\Task;
use App\Models\User;

class DashboardService
{
    /**
     * @return array{guru:int,siswa:int,kelas:int,pertemuan:int,materi:int,tugas:int,submission:int}
     */
    public function getCounts(): array
    {
        return [
            'guru'      => User::where('role', 'guru')->count(),
            'siswa'     => User::where('role', 'siswa')->count(),
            'kelas'     => ClassRoom::count(),
            'pertemuan' => Meeting::count(),
            'materi'    => Material::count(),
            'tugas'     => Task::count(),
            'submission' => Submission::count(),
        ];
    }

    public function getRecentUsers(int $limit = 5)
    {
        return User::latest()->take($limit)->get();
    }
}
