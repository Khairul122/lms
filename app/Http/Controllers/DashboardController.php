<?php

namespace App\Http\Controllers;

use App\Services\DashboardService;

class DashboardController extends Controller
{
    public function __construct(protected DashboardService $dashboardService)
    {
    }

    public function index()
    {
        $counts = $this->dashboardService->getCounts();

        return view('dashboard.index', [
            'guru'       => $counts['guru'],
            'siswa'      => $counts['siswa'],
            'kelas'      => $counts['kelas'],
            'materi'     => $counts['materi'],
            'meeting'    => $counts['pertemuan'],
            'tugas'      => $counts['tugas'],
            'submission' => $counts['submission'],
            'users'      => $this->dashboardService->getRecentUsers(),
        ]);
    }
}
