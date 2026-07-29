@extends('adminlte::page')

@section('title', 'Data Siswa')

@section('content_header')
    <div class="d-flex justify-content-between align-items-center mb-2">
        <div>
            <h1 class="text-dark fw-bold m-0" style="font-size: 1.75rem; color: #0F172A;">
                <i class="fas fa-user-graduate text-indigo me-2" style="color: #4F46E5;"></i> Data Siswa / Peserta Didik
            </h1>
            <p class="text-muted mb-0" style="font-size: 0.9rem;">Kelola data siswa terdaftar, NISN, serta status akun pada EduSmart LMS</p>
        </div>
    </div>
@endsection

@section('content')
<div class="container-fluid px-0">

    {{-- Main Table Card --}}
    <div class="card border-0 shadow-sm" style="border-radius: 16px; border: 1px solid #E2E8F0; overflow: hidden;">
        
        <div class="card-header bg-white py-3 px-4 d-flex align-items-center justify-content-between" style="border-bottom: 1px solid #F1F5F9;">
            <h5 class="fw-bold mb-0 text-dark d-flex align-items-center">
                <i class="fas fa-users me-2" style="color: #4F46E5;"></i> Daftar Seluruh Siswa
            </h5>
            <form method="GET" class="d-flex gap-2" style="max-width: 380px; width: 100%;">
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0" style="border-radius: 10px 0 0 10px; border-color: #CBD5E1;">
                        <i class="fas fa-search text-muted"></i>
                    </span>
                    <input type="text" name="keyword" class="form-control border-start-0 bg-light" placeholder="Cari nama atau NISN siswa..." value="{{ request('keyword') }}" style="border-radius: 0 10px 10px 0; border-color: #CBD5E1;">
                </div>
            </form>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" style="font-size: 0.925rem;">
                    <thead style="background: #F8FAFC; color: #475569; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 2px solid #E2E8F0;">
                        <tr>
                            <th class="ps-4" width="60">No</th>
                            <th width="70">Foto</th>
                            <th>Nama Siswa</th>
                            <th>Email</th>
                            <th>NISN</th>
                            <th>No. Telepon</th>
                        </tr>
                    </thead>
                    <tbody style="color: #1E293B;">
                        @forelse($users as $user)
                            <tr style="border-bottom: 1px solid #F1F5F9;">
                                <td class="ps-4 fw-semibold text-muted">{{ $loop->iteration }}</td>
                                <td>
                                    @if($user->photo)
                                        <img src="{{ asset('storage/'.$user->photo) }}" class="rounded-circle shadow-sm" width="40" height="40" style="object-fit: cover;">
                                    @else
                                        <img src="https://ui-avatars.com/api/?name={{ urlencode($user->name) }}&background=6366F1&color=fff" class="rounded-circle shadow-sm" width="40" height="40">
                                    @endif
                                </td>
                                <td>
                                    <span class="fw-bold text-dark d-block">{{ $user->name }}</span>
                                </td>
                                <td>
                                    <span class="text-muted">{{ $user->email }}</span>
                                </td>
                                <td>
                                    <span class="badge px-3 py-2 fw-semibold" style="background: #EEF2FF; color: #4338CA; border-radius: 8px;">
                                        {{ $user->nisn ?? '-' }}
                                    </span>
                                </td>
                                <td>
                                    <span class="text-secondary">{{ $user->phone ?? '-' }}</span>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="6" class="text-center py-5">
                                    <div class="d-flex flex-column align-items-center justify-content-center">
                                        <div class="rounded-circle d-flex align-items-center justify-content-center mb-3" style="width: 80px; height: 80px; background: #EEF2FF; color: #4F46E5;">
                                            <i class="fas fa-user-graduate fa-3x"></i>
                                        </div>
                                        <h6 class="fw-bold text-dark mb-1">Belum Ada Data Siswa</h6>
                                        <p class="text-muted mb-0" style="font-size: 0.875rem;">Siswa dapat mendaftar melalui aplikasi mobile EduSmart Siswa.</p>
                                    </div>
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>

        @if($users->hasPages())
            <div class="card-footer bg-white py-3 px-4" style="border-top: 1px solid #F1F5F9;">
                {{ $users->links() }}
            </div>
        @endif

    </div>
</div>
@endsection