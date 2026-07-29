@extends('adminlte::page')

@section('title', 'Dashboard EduSmart LMS')

@section('content_header')
    <div class="d-flex justify-content-between align-items-center mb-2">
        <div>
            <h1 class="text-dark fw-bold m-0" style="font-size: 1.75rem; color: #0F172A;">
                <i class="fas fa-chart-line text-indigo me-2" style="color: #4F46E5;"></i> Dashboard EduSmart LMS
            </h1>
            <p class="text-muted mb-0" style="font-size: 0.9rem;">Ikhtisar sistem statistik pengajar, siswa, kelas, dan aktivitas akademik</p>
        </div>
    </div>
@endsection

@section('content')
<div class="container-fluid px-0">

    {{-- Stats Row 1 --}}
    <div class="row g-3 mb-4">
        <div class="col-lg-3 col-6">
            <div class="card border-0 shadow-sm" style="border-radius: 16px; background: linear-gradient(135deg, #4F46E5 0%, #6366F1 100%); color: white;">
                <div class="card-body p-4 d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-white-50 text-uppercase fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.05em;">Total Guru</span>
                        <h2 class="display-6 fw-bold mb-0 text-white mt-1">{{ $guru }}</h2>
                    </div>
                    <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 52px; height: 52px; background: rgba(255,255,255,0.2);">
                        <i class="fas fa-chalkboard-teacher fa-2x text-white"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-6">
            <div class="card border-0 shadow-sm" style="border-radius: 16px; background: linear-gradient(135deg, #10B981 0%, #059669 100%); color: white;">
                <div class="card-body p-4 d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-white-50 text-uppercase fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.05em;">Total Siswa</span>
                        <h2 class="display-6 fw-bold mb-0 text-white mt-1">{{ $siswa }}</h2>
                    </div>
                    <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 52px; height: 52px; background: rgba(255,255,255,0.2);">
                        <i class="fas fa-user-graduate fa-2x text-white"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-6">
            <div class="card border-0 shadow-sm" style="border-radius: 16px; background: linear-gradient(135deg, #F59E0B 0%, #D97706 100%); color: white;">
                <div class="card-body p-4 d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-white-50 text-uppercase fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.05em;">Total Kelas</span>
                        <h2 class="display-6 fw-bold mb-0 text-white mt-1">{{ $kelas }}</h2>
                    </div>
                    <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 52px; height: 52px; background: rgba(255,255,255,0.2);">
                        <i class="fas fa-school fa-2x text-white"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-3 col-6">
            <div class="card border-0 shadow-sm" style="border-radius: 16px; background: linear-gradient(135deg, #EF4444 0%, #DC2626 100%); color: white;">
                <div class="card-body p-4 d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-white-50 text-uppercase fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.05em;">Pertemuan</span>
                        <h2 class="display-6 fw-bold mb-0 text-white mt-1">{{ $meeting }}</h2>
                    </div>
                    <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 52px; height: 52px; background: rgba(255,255,255,0.2);">
                        <i class="fas fa-calendar-alt fa-2x text-white"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {{-- Stats Row 2 --}}
    <div class="row g-3 mb-4">
        <div class="col-lg-4 col-12">
            <div class="card border-0 shadow-sm p-3" style="border-radius: 16px; border: 1px solid #E2E8F0; background: white;">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted text-uppercase fw-semibold" style="font-size: 0.75rem;">Materi Pembelajaran</span>
                        <h3 class="fw-bold mb-0 text-dark">{{ $materi }}</h3>
                    </div>
                    <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 48px; height: 48px; background: #EFF6FF; color: #2563EB;">
                        <i class="fas fa-book fa-lg"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4 col-12">
            <div class="card border-0 shadow-sm p-3" style="border-radius: 16px; border: 1px solid #E2E8F0; background: white;">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted text-uppercase fw-semibold" style="font-size: 0.75rem;">Tugas Diterbitkan</span>
                        <h3 class="fw-bold mb-0 text-dark">{{ $tugas }}</h3>
                    </div>
                    <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 48px; height: 48px; background: #FAF5FF; color: #9333EA;">
                        <i class="fas fa-file-alt fa-lg"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4 col-12">
            <div class="card border-0 shadow-sm p-3" style="border-radius: 16px; border: 1px solid #E2E8F0; background: white;">
                <div class="d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted text-uppercase fw-semibold" style="font-size: 0.75rem;">Submission Siswa</span>
                        <h3 class="fw-bold mb-0 text-dark">{{ $submission }}</h3>
                    </div>
                    <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 48px; height: 48px; background: #ECFDF5; color: #059669;">
                        <i class="fas fa-upload fa-lg"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {{-- Main Charts & Activity Row --}}
    <div class="row g-3">
        <div class="col-md-8">
            <div class="card border-0 shadow-sm" style="border-radius: 16px; border: 1px solid #E2E8F0;">
                <div class="card-header bg-white py-3 px-4" style="border-bottom: 1px solid #F1F5F9;">
                    <h5 class="fw-bold mb-0 text-dark">
                        <i class="fas fa-chart-bar me-2" style="color: #4F46E5;"></i> Ringkasan Data Akademik
                    </h5>
                </div>
                <div class="card-body p-4">
                    <canvas id="dashboardChart" height="130"></canvas>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card border-0 shadow-sm" style="border-radius: 16px; border: 1px solid #E2E8F0;">
                <div class="card-header bg-white py-3 px-4" style="border-bottom: 1px solid #F1F5F9;">
                    <h5 class="fw-bold mb-0 text-dark">
                        <i class="fas fa-user-clock me-2" style="color: #4F46E5;"></i> User Terbaru
                    </h5>
                </div>
                <div class="card-body p-3">
                    @forelse($users as $user)
                        <div class="d-flex align-items-center justify-content-between py-2 border-bottom">
                            <div class="d-flex align-items-center">
                                <div class="rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 36px; height: 36px; background: #EEF2FF; color: #4F46E5; font-weight: bold;">
                                    {{ strtoupper(substr($user->name, 0, 1)) }}
                                </div>
                                <div>
                                    <span class="fw-bold text-dark d-block" style="font-size: 0.875rem;">{{ $user->name }}</span>
                                    <small class="text-muted" style="font-size: 0.75rem;">{{ $user->email }}</small>
                                </div>
                            </div>
                            <span class="badge px-2 py-1 fw-semibold" style="background: #EEF2FF; color: #4338CA; border-radius: 6px; font-size: 0.75rem;">
                                {{ ucfirst($user->role) }}
                            </span>
                        </div>
                    @empty
                        <p class="text-center text-muted py-3">Tidak ada user terbaru.</p>
                    @endforelse
                </div>
            </div>
        </div>
    </div>

</div>
@endsection

@section('js')
<script>
const ctx = document.getElementById('dashboardChart');
new Chart(ctx, {
    type: 'bar',
    data: {
        labels: ['Guru', 'Siswa', 'Kelas', 'Pertemuan', 'Materi', 'Tugas', 'Submission'],
        datasets: [{
            label: 'Jumlah Data',
            data: [{{ $guru }}, {{ $siswa }}, {{ $kelas }}, {{ $meeting }}, {{ $materi }}, {{ $tugas }}, {{ $submission }}],
            backgroundColor: [
                '#4F46E5', '#10B981', '#F59E0B', '#EF4444', '#2563EB', '#9333EA', '#059669'
            ],
            borderRadius: 8,
            borderSkipped: false,
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: { display: false }
        },
        scales: {
            y: { beginAtZero: true, grid: { borderDash: [4, 4] } },
            x: { grid: { display: false } }
        }
    }
});
</script>
@endsection