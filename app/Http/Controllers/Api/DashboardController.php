<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\DashboardService;
use App\Traits\ApiResponse;

class DashboardController extends Controller
{
    use ApiResponse;

    public function __construct(protected DashboardService $dashboardService)
    {
    }

    public function index()
    {
        $counts = $this->dashboardService->getCounts();

        return response()->json([
            'success' => true,
            'statistics' => [
                'total_guru'       => $counts['guru'],
                'total_siswa'      => $counts['siswa'],
                'total_kelas'      => $counts['kelas'],
                'total_pertemuan'  => $counts['pertemuan'],
                'total_materi'     => $counts['materi'],
                'total_tugas'      => $counts['tugas'],
                'total_submission' => $counts['submission'],
            ],
        ]);
    }
}
