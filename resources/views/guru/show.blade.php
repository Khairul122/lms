@extends('adminlte::page')

@section('title', 'Detail Guru')

@section('content')
<div class="container-fluid px-0">
    <div class="card border-0 shadow-sm" style="border-radius: 16px; border: 1px solid #E2E8F0; overflow: hidden;">
        <div class="card-header bg-white py-3 px-4 d-flex align-items-center justify-content-between" style="border-bottom: 1px solid #F1F5F9;">
            <h5 class="fw-bold mb-0 text-dark d-flex align-items-center">
                <i class="fas fa-id-card me-2" style="color: #4F46E5;"></i> Detail Profil Guru
            </h5>
            <div>
                <a href="{{ route('guru.edit', $guru->id) }}" class="btn btn-sm btn-warning text-white px-3 py-2 me-1" style="border-radius: 8px; font-weight: 600;">
                    <i class="fas fa-edit me-1"></i> Edit Guru
                </a>
                <a href="{{ route('guru.index') }}" class="btn btn-sm btn-light border text-secondary px-3 py-2" style="border-radius: 8px; font-weight: 500;">
                    <i class="fas fa-arrow-left me-1"></i> Kembali
                </a>
            </div>
        </div>

        <div class="card-body p-4">
            <div class="row align-items-center">
                <div class="col-md-3 text-center mb-4 mb-md-0">
                    @if($guru->photo)
                        <img src="{{ asset('storage/'.$guru->photo) }}" class="rounded-circle shadow-sm mb-3" width="140" height="140" style="object-fit: cover; border: 4px solid #EEF2FF;">
                    @else
                        <img src="https://ui-avatars.com/api/?name={{ urlencode($guru->name) }}&background=4F46E5&color=fff&size=140" class="rounded-circle shadow-sm mb-3" width="140" height="140" style="border: 4px solid #EEF2FF;">
                    @endif
                    <h5 class="fw-bold text-dark mb-1">{{ $guru->name }}</h5>
                    <span class="badge px-3 py-2 fw-semibold" style="background: #EEF2FF; color: #4338CA; border-radius: 8px;">
                        Guru / Pengajar
                    </span>
                </div>
                <div class="col-md-9">
                    <div class="row g-3">
                        <div class="col-sm-6 mb-3">
                            <div class="p-3 rounded-3" style="background: #F8FAFC; border: 1px solid #F1F5F9;">
                                <small class="text-muted d-block text-uppercase fw-semibold mb-1" style="font-size: 0.75rem;">Nama Lengkap</small>
                                <span class="fw-bold text-dark fs-6">{{ $guru->name }}</span>
                            </div>
                        </div>
                        <div class="col-sm-6 mb-3">
                            <div class="p-3 rounded-3" style="background: #F8FAFC; border: 1px solid #F1F5F9;">
                                <small class="text-muted d-block text-uppercase fw-semibold mb-1" style="font-size: 0.75rem;">NIP</small>
                                <span class="fw-bold text-dark fs-6">{{ $guru->nip ?? '-' }}</span>
                            </div>
                        </div>
                        <div class="col-sm-6 mb-3">
                            <div class="p-3 rounded-3" style="background: #F8FAFC; border: 1px solid #F1F5F9;">
                                <small class="text-muted d-block text-uppercase fw-semibold mb-1" style="font-size: 0.75rem;">Username</small>
                                <span class="fw-bold text-dark fs-6">{{ $guru->username }}</span>
                            </div>
                        </div>
                        <div class="col-sm-6 mb-3">
                            <div class="p-3 rounded-3" style="background: #F8FAFC; border: 1px solid #F1F5F9;">
                                <small class="text-muted d-block text-uppercase fw-semibold mb-1" style="font-size: 0.75rem;">Email</small>
                                <span class="fw-bold text-dark fs-6">{{ $guru->email }}</span>
                            </div>
                        </div>
                        <div class="col-sm-6 mb-3">
                            <div class="p-3 rounded-3" style="background: #F8FAFC; border: 1px solid #F1F5F9;">
                                <small class="text-muted d-block text-uppercase fw-semibold mb-1" style="font-size: 0.75rem;">No. Telepon / HP</small>
                                <span class="fw-bold text-dark fs-6">{{ $guru->phone ?? '-' }}</span>
                            </div>
                        </div>
                        <div class="col-sm-6 mb-3">
                            <div class="p-3 rounded-3" style="background: #F8FAFC; border: 1px solid #F1F5F9;">
                                <small class="text-muted d-block text-uppercase fw-semibold mb-1" style="font-size: 0.75rem;">Terdaftar Pada</small>
                                <span class="fw-bold text-dark fs-6">{{ $guru->created_at ? $guru->created_at->format('d M Y, H:i') : '-' }}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
