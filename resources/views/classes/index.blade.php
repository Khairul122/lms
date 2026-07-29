@extends('adminlte::page')

@section('title', 'Manajemen Kelas')

@section('content_header')
    <div class="d-flex justify-content-between align-items-center mb-2">
        <div>
            <h1 class="text-dark fw-bold m-0" style="font-size: 1.75rem; color: #0F172A;">
                <i class="fas fa-school text-indigo me-2" style="color: #4F46E5;"></i> Manajemen Kelas
            </h1>
            <p class="text-muted mb-0" style="font-size: 0.9rem;">Kelola seluruh kelas, mata pelajaran, dan pengajar pada EduSmart LMS</p>
        </div>
        <a href="{{ route('classes.create') }}" class="btn text-white px-4 py-2 shadow-sm" style="background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%); border-radius: 10px; font-weight: 600;">
            <i class="fas fa-plus-circle me-1"></i> Tambah Kelas Baru
        </a>
    </div>
@endsection

@section('content')
<div class="container-fluid px-0">

    {{-- Stats Cards --}}
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm rounded-4" style="background: linear-gradient(135deg, #4F46E5 0%, #6366F1 100%); color: white; border-radius: 16px; transition: transform 0.2s;">
                <div class="card-body p-4 d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-white-50 text-uppercase fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.05em;">Total Kelas Active</span>
                        <h2 class="display-6 fw-bold mb-0 text-white mt-1">{{ $classes->total() }}</h2>
                    </div>
                    <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 56px; height: 56px; background: rgba(255,255,255,0.2); backdrop-filter: blur(8px);">
                        <i class="fas fa-school fa-2x text-white"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card border-0 shadow-sm rounded-4" style="background: #ffffff; border-radius: 16px; border: 1px solid #E2E8F0;">
                <div class="card-body p-4 d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted text-uppercase fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.05em;">Status Server</span>
                        <h2 class="h3 fw-bold mb-0 text-dark mt-1">Normal (MySQL)</h2>
                    </div>
                    <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 56px; height: 56px; background: #ECFDF5; color: #059669;">
                        <i class="fas fa-database fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card border-0 shadow-sm rounded-4" style="background: #ffffff; border-radius: 16px; border: 1px solid #E2E8F0;">
                <div class="card-body p-4 d-flex align-items-center justify-content-between">
                    <div>
                        <span class="text-muted text-uppercase fw-semibold" style="font-size: 0.75rem; letter-spacing: 0.05em;">REST API Service</span>
                        <h2 class="h3 fw-bold mb-0 text-dark mt-1">Terhubung (JWT)</h2>
                    </div>
                    <div class="rounded-circle d-flex align-items-center justify-content-center" style="width: 56px; height: 56px; background: #EEF2FF; color: #4F46E5;">
                        <i class="fas fa-network-wired fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {{-- Main Table Card --}}
    <div class="card border-0 shadow-sm" style="border-radius: 16px; border: 1px solid #E2E8F0; overflow: hidden;">
        
        <div class="card-header bg-white py-3 px-4 d-flex align-items-center justify-content-between" style="border-bottom: 1px solid #F1F5F9;">
            <h5 class="fw-bold mb-0 text-dark d-flex align-items-center">
                <i class="fas fa-list-ul me-2 text-indigo" style="color: #4F46E5;"></i> Daftar Kelas
            </h5>
            <form method="GET" class="d-flex gap-2" style="max-width: 380px; width: 100%;">
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0" style="border-radius: 10px 0 0 10px; border-color: #CBD5E1;">
                        <i class="fas fa-search text-muted"></i>
                    </span>
                    <input type="text" name="search" class="form-control border-start-0 bg-light" placeholder="Cari nama kelas atau mata pelajaran..." value="{{ request('search') }}" style="border-radius: 0 10px 10px 0; border-color: #CBD5E1;">
                </div>
            </form>
        </div>

        <div class="card-body p-0">
            @if(session('success'))
                <div class="alert alert-success border-0 m-3 rounded-3 d-flex align-items-center" style="background: #ECFDF5; color: #065F46;">
                    <i class="fas fa-check-circle me-2 fa-lg"></i>
                    <div>{{ session('success') }}</div>
                </div>
            @endif

            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" style="font-size: 0.925rem;">
                    <thead style="background: #F8FAFC; color: #475569; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 2px solid #E2E8F0;">
                        <tr>
                            <th class="ps-4" width="70">No</th>
                            <th>Kode Kelas</th>
                            <th>Nama Kelas</th>
                            <th>Mata Pelajaran</th>
                            <th>Pengajar (Guru)</th>
                            <th>Status</th>
                            <th class="pe-4 text-end" width="160">Aksi</th>
                        </tr>
                    </thead>
                    <tbody style="color: #1E293B;">
                        @forelse($classes as $item)
                            <tr style="border-bottom: 1px solid #F1F5F9;">
                                <td class="ps-4 fw-semibold text-muted">{{ $loop->iteration }}</td>
                                <td>
                                    <span class="badge px-3 py-2 fw-semibold" style="background: #EEF2FF; color: #4338CA; border-radius: 8px; font-size: 0.825rem;">
                                        {{ $item->class_code }}
                                    </span>
                                </td>
                                <td>
                                    <span class="fw-bold text-dark">{{ $item->class_name }}</span>
                                </td>
                                <td>
                                    <span class="text-secondary">{{ $item->subject }}</span>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 32px; height: 32px; background: #E0E7FF; color: #4338CA; font-weight: bold; font-size: 0.8rem;">
                                            {{ strtoupper(substr(optional($item->teacher)->name ?? 'G', 0, 1)) }}
                                        </div>
                                        <span class="fw-medium">{{ optional($item->teacher)->name ?? '-' }}</span>
                                    </div>
                                </td>
                                <td>
                                    @if($item->is_active)
                                        <span class="badge px-3 py-2 fw-semibold" style="background: #DEF7EC; color: #03543F; border-radius: 20px;">
                                            <i class="fas fa-dot-circle me-1" style="font-size: 0.6rem;"></i> Aktif
                                        </span>
                                    @else
                                        <span class="badge px-3 py-2 fw-semibold" style="background: #FDE8E8; color: #9B1C1C; border-radius: 20px;">
                                            <i class="fas fa-dot-circle me-1" style="font-size: 0.6rem;"></i> Nonaktif
                                        </span>
                                    @endif
                                </td>
                                <td class="pe-4 text-end">
                                    <div class="btn-group gap-1" role="group">
                                        <a href="{{ route('classes.show', $item) }}" class="btn btn-sm btn-light border text-info" title="Detail Kelas" style="border-radius: 8px;">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="{{ route('classes.edit', $item) }}" class="btn btn-sm btn-light border text-warning" title="Edit Kelas" style="border-radius: 8px;">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <form action="{{ route('classes.destroy', $item) }}" method="POST" class="d-inline">
                                            @csrf
                                            @method('DELETE')
                                            <button onclick="return confirm('Yakin ingin menghapus kelas ini?')" class="btn btn-sm btn-light border text-danger" title="Hapus Kelas" style="border-radius: 8px;">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="7" class="text-center py-5">
                                    <div class="d-flex flex-column align-items-center justify-content-center">
                                        <div class="rounded-circle d-flex align-items-center justify-content-center mb-3" style="width: 80px; height: 80px; background: #EEF2FF; color: #4F46E5;">
                                            <i class="fas fa-school fa-3x"></i>
                                        </div>
                                        <h6 class="fw-bold text-dark mb-1">Belum Ada Data Kelas</h6>
                                        <p class="text-muted mb-3" style="font-size: 0.875rem;">Mulai dengan menambahkan kelas baru ke dalam sistem EduSmart LMS.</p>
                                        <a href="{{ route('classes.create') }}" class="btn btn-sm text-white px-4 py-2" style="background: #4F46E5; border-radius: 8px;">
                                            <i class="fas fa-plus me-1"></i> Tambah Kelas Pertama
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>

        @if($classes->hasPages())
            <div class="card-footer bg-white py-3 px-4" style="border-top: 1px solid #F1F5F9;">
                {{ $classes->withQueryString()->links() }}
            </div>
        @endif

    </div>
</div>
@endsection