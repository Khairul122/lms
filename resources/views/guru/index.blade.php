@extends('adminlte::page')

@section('title', 'Data Guru')

@section('content_header')
    <div class="d-flex justify-content-between align-items-center mb-2">
        <div>
            <h1 class="text-dark fw-bold m-0" style="font-size: 1.75rem; color: #0F172A;">
                <i class="fas fa-chalkboard-teacher text-indigo me-2" style="color: #4F46E5;"></i> Data Guru & Pengajar
            </h1>
            <p class="text-muted mb-0" style="font-size: 0.9rem;">Kelola seluruh akun pengajar, NIP, serta profil guru pada EduSmart LMS</p>
        </div>
        <a href="{{ route('guru.create') }}" class="btn text-white px-4 py-2 shadow-sm" style="background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%); border-radius: 10px; font-weight: 600;">
            <i class="fas fa-plus-circle me-1"></i> Tambah Guru Baru
        </a>
    </div>
@endsection

@section('content')
<div class="container-fluid px-0">

    {{-- Main Table Card --}}
    <div class="card border-0 shadow-sm" style="border-radius: 16px; border: 1px solid #E2E8F0; overflow: hidden;">
        
        <div class="card-header bg-white py-3 px-4 d-flex align-items-center justify-content-between" style="border-bottom: 1px solid #F1F5F9;">
            <h5 class="fw-bold mb-0 text-dark d-flex align-items-center">
                <i class="fas fa-users me-2" style="color: #4F46E5;"></i> Daftar Seluruh Guru
            </h5>
            <form method="GET" class="d-flex gap-2" style="max-width: 380px; width: 100%;">
                <div class="input-group">
                    <span class="input-group-text bg-light border-end-0" style="border-radius: 10px 0 0 10px; border-color: #CBD5E1;">
                        <i class="fas fa-search text-muted"></i>
                    </span>
                    <input type="text" name="keyword" class="form-control border-start-0 bg-light" placeholder="Cari nama atau NIP guru..." value="{{ request('keyword') }}" style="border-radius: 0 10px 10px 0; border-color: #CBD5E1;">
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
                            <th class="ps-4" width="60">No</th>
                            <th width="70">Foto</th>
                            <th>Nama Lengkap</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>NIP</th>
                            <th>No. Telepon</th>
                            <th class="pe-4 text-end" width="160">Aksi</th>
                        </tr>
                    </thead>
                    <tbody style="color: #1E293B;">
                        @forelse($gurus as $guru)
                            <tr style="border-bottom: 1px solid #F1F5F9;">
                                <td class="ps-4 fw-semibold text-muted">{{ $loop->iteration + ($gurus->currentPage()-1)*$gurus->perPage() }}</td>
                                <td>
                                    @if($guru->photo)
                                        <img src="{{ asset('storage/'.$guru->photo) }}" class="rounded-circle shadow-sm" width="40" height="40" style="object-fit: cover;">
                                    @else
                                        <img src="https://ui-avatars.com/api/?name={{ urlencode($guru->name) }}&background=4F46E5&color=fff" class="rounded-circle shadow-sm" width="40" height="40">
                                    @endif
                                </td>
                                <td>
                                    <span class="fw-bold text-dark d-block">{{ $guru->name }}</span>
                                </td>
                                <td>
                                    <span class="badge px-3 py-2 fw-semibold" style="background: #EEF2FF; color: #4338CA; border-radius: 8px;">
                                        {{ $guru->username }}
                                    </span>
                                </td>
                                <td>
                                    <span class="text-muted">{{ $guru->email }}</span>
                                </td>
                                <td>
                                    <span class="fw-medium text-dark">{{ $guru->nip ?? '-' }}</span>
                                </td>
                                <td>
                                    <span class="text-secondary">{{ $guru->phone ?? '-' }}</span>
                                </td>
                                <td class="pe-4 text-end">
                                    <div class="btn-group gap-1" role="group">
                                        <a href="{{ route('guru.show', $guru->id) }}" class="btn btn-sm btn-light border text-info" title="Detail" style="border-radius: 8px;">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="{{ route('guru.edit', $guru->id) }}" class="btn btn-sm btn-light border text-warning" title="Edit" style="border-radius: 8px;">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <form action="{{ route('guru.destroy', $guru->id) }}" method="POST" class="d-inline">
                                            @csrf
                                            @method('DELETE')
                                            <button onclick="return confirm('Yakin ingin menghapus guru ini?')" class="btn btn-sm btn-light border text-danger" title="Hapus" style="border-radius: 8px;">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="8" class="text-center py-5">
                                    <div class="d-flex flex-column align-items-center justify-content-center">
                                        <div class="rounded-circle d-flex align-items-center justify-content-center mb-3" style="width: 80px; height: 80px; background: #EEF2FF; color: #4F46E5;">
                                            <i class="fas fa-chalkboard-teacher fa-3x"></i>
                                        </div>
                                        <h6 class="fw-bold text-dark mb-1">Belum Ada Data Guru</h6>
                                        <p class="text-muted mb-3" style="font-size: 0.875rem;">Tambahkan akun pengajar baru ke dalam sistem EduSmart LMS.</p>
                                        <a href="{{ route('guru.create') }}" class="btn btn-sm text-white px-4 py-2" style="background: #4F46E5; border-radius: 8px;">
                                            <i class="fas fa-plus me-1"></i> Tambah Guru Baru
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>

        @if($gurus->hasPages())
            <div class="card-footer bg-white py-3 px-4" style="border-top: 1px solid #F1F5F9;">
                {{ $gurus->links() }}
            </div>
        @endif

    </div>
</div>
@endsection