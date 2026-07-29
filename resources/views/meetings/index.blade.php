@extends('adminlte::page')

@section('title', 'Data Pertemuan')

@section('content_header')
    <div class="d-flex justify-content-between align-items-center mb-2">
        <div>
            <h1 class="text-dark fw-bold m-0" style="font-size: 1.75rem; color: #0F172A;">
                <i class="fas fa-calendar-alt text-indigo me-2" style="color: #4F46E5;"></i> Data Pertemuan
            </h1>
            <p class="text-muted mb-0" style="font-size: 0.9rem;">Kelola sesi dan modul pertemuan per kelas pada EduSmart LMS</p>
        </div>
        <a href="{{ route('meetings.create') }}" class="btn text-white px-4 py-2 shadow-sm" style="background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%); border-radius: 10px; font-weight: 600;">
            <i class="fas fa-plus-circle me-1"></i> Tambah Pertemuan Baru
        </a>
    </div>
@endsection

@section('content')
<div class="container-fluid px-0">

    {{-- Main Table Card --}}
    <div class="card border-0 shadow-sm" style="border-radius: 16px; border: 1px solid #E2E8F0; overflow: hidden;">
        
        <div class="card-header bg-white py-3 px-4 d-flex align-items-center justify-content-between" style="border-bottom: 1px solid #F1F5F9;">
            <h5 class="fw-bold mb-0 text-dark d-flex align-items-center">
                <i class="fas fa-list me-2" style="color: #4F46E5;"></i> Daftar Seluruh Pertemuan
            </h5>
            <form method="GET" class="d-flex gap-2" style="max-width: 380px; width: 100%;">
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0" style="border-radius: 10px 0 0 10px; border-color: #CBD5E1;">
                        <i class="fas fa-search text-muted"></i>
                    </span>
                    <input type="text" name="search" class="form-control border-start-0 bg-light" placeholder="Cari nama pertemuan..." value="{{ request('search') }}" style="border-radius: 0 10px 10px 0; border-color: #CBD5E1;">
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
                            <th>Kelas</th>
                            <th>Sesi Pertemuan</th>
                            <th>Nama & Tema Pertemuan</th>
                            <th class="pe-4 text-end" width="160">Aksi</th>
                        </tr>
                    </thead>
                    <tbody style="color: #1E293B;">
                        @forelse($meetings as $meeting)
                            <tr style="border-bottom: 1px solid #F1F5F9;">
                                <td class="ps-4 fw-semibold text-muted">{{ $loop->iteration }}</td>
                                <td>
                                    <span class="badge px-3 py-2 fw-semibold" style="background: #EEF2FF; color: #4338CA; border-radius: 8px;">
                                        {{ optional($meeting->classroom)->class_name ?? 'Kelas Tidak Ditemukan' }}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge px-3 py-2 fw-bold" style="background: #FEF3C7; color: #92400E; border-radius: 8px;">
                                        Pertemuan {{ $meeting->pertemuan }}
                                    </span>
                                </td>
                                <td>
                                    <div>
                                        <span class="fw-bold text-dark d-block">{{ $meeting->nama_pertemuan }}</span>
                                        @if($meeting->tema_pertemuan)
                                            <small class="text-muted"><i class="fas fa-tag me-1" style="font-size: 0.75rem;"></i> {{ $meeting->tema_pertemuan }}</small>
                                        @endif
                                    </div>
                                </td>
                                <td class="pe-4 text-end">
                                    <div class="btn-group gap-1" role="group">
                                        <a href="{{ route('meetings.show', $meeting) }}" class="btn btn-sm btn-light border text-info" title="Detail" style="border-radius: 8px;">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="{{ route('meetings.edit', $meeting) }}" class="btn btn-sm btn-light border text-warning" title="Edit" style="border-radius: 8px;">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <form action="{{ route('meetings.destroy', $meeting) }}" method="POST" class="d-inline">
                                            @csrf
                                            @method('DELETE')
                                            <button onclick="return confirm('Yakin menghapus pertemuan ini?')" class="btn btn-sm btn-light border text-danger" title="Hapus" style="border-radius: 8px;">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="5" class="text-center py-5">
                                    <div class="d-flex flex-column align-items-center justify-content-center">
                                        <div class="rounded-circle d-flex align-items-center justify-content-center mb-3" style="width: 80px; height: 80px; background: #EEF2FF; color: #4F46E5;">
                                            <i class="fas fa-calendar-alt fa-3x"></i>
                                        </div>
                                        <h6 class="fw-bold text-dark mb-1">Belum Ada Data Pertemuan</h6>
                                        <p class="text-muted mb-3" style="font-size: 0.875rem;">Tambahkan pertemuan baru untuk mengorganisir modul dan diskusi kelas.</p>
                                        <a href="{{ route('meetings.create') }}" class="btn btn-sm text-white px-4 py-2" style="background: #4F46E5; border-radius: 8px;">
                                            <i class="fas fa-plus me-1"></i> Tambah Pertemuan Baru
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>

        @if($meetings->hasPages())
            <div class="card-footer bg-white py-3 px-4" style="border-top: 1px solid #F1F5F9;">
                {{ $meetings->links() }}
            </div>
        @endif

    </div>
</div>
@endsection