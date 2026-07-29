@extends('adminlte::page')

@section('title', 'Notifikasi System')

@section('content_header')
    <div class="d-flex justify-content-between align-items-center mb-2">
        <div>
            <h1 class="text-dark fw-bold m-0" style="font-size: 1.75rem; color: #0F172A;">
                <i class="fas fa-bell text-indigo me-2" style="color: #4F46E5;"></i> Manajemen Notifikasi
            </h1>
            <p class="text-muted mb-0" style="font-size: 0.9rem;">Kelola pengiriman notifikasi broadcast & pemberitahuan kepada pengajar atau siswa</p>
        </div>
        <a href="{{ route('notifications.create') }}" class="btn text-white px-4 py-2 shadow-sm" style="background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%); border-radius: 10px; font-weight: 600;">
            <i class="fas fa-plus-circle me-1"></i> Buat Notifikasi Baru
        </a>
    </div>
@endsection

@section('content')
<div class="container-fluid px-0">

    {{-- Main Table Card --}}
    <div class="card border-0 shadow-sm" style="border-radius: 16px; border: 1px solid #E2E8F0; overflow: hidden;">
        
        <div class="card-header bg-white py-3 px-4 d-flex align-items-center justify-content-between" style="border-bottom: 1px solid #F1F5F9;">
            <h5 class="fw-bold mb-0 text-dark d-flex align-items-center">
                <i class="fas fa-bell me-2" style="color: #4F46E5;"></i> Riwayat Notifikasi Diterbitkan
            </h5>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" style="font-size: 0.925rem;">
                    <thead style="background: #F8FAFC; color: #475569; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 2px solid #E2E8F0;">
                        <tr>
                            <th class="ps-4" width="60">No</th>
                            <th>Penerima (User)</th>
                            <th>Judul & Pesan Notifikasi</th>
                            <th>Tipe Notifikasi</th>
                            <th>Status Dibaca</th>
                            <th class="pe-4 text-end" width="140">Aksi</th>
                        </tr>
                    </thead>
                    <tbody style="color: #1E293B;">
                        @forelse($notifications as $notification)
                            <tr style="border-bottom: 1px solid #F1F5F9;">
                                <td class="ps-4 fw-semibold text-muted">{{ $loop->iteration }}</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 32px; height: 32px; background: #EEF2FF; color: #4F46E5; font-weight: bold; font-size: 0.8rem;">
                                            {{ strtoupper(substr($notification->user->name ?? 'U', 0, 1)) }}
                                        </div>
                                        <span class="fw-bold text-dark">{{ $notification->user->name ?? 'Pengguna' }}</span>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <span class="fw-bold text-dark d-block">{{ $notification->title }}</span>
                                        <small class="text-muted" style="font-size: 0.8rem;">{{ Str::limit($notification->message, 70) }}</small>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge px-3 py-2 fw-semibold" style="background: #EEF2FF; color: #4338CA; border-radius: 8px;">
                                        <i class="fas fa-tag me-1" style="font-size: 0.75rem;"></i> {{ ucfirst($notification->type) }}
                                    </span>
                                </td>
                                <td>
                                    @if($notification->is_read)
                                        <span class="badge px-3 py-2 fw-semibold" style="background: #DEF7EC; color: #03543F; border-radius: 20px;">
                                            <i class="fas fa-check-circle me-1" style="font-size: 0.65rem;"></i> Sudah Dibaca
                                        </span>
                                    @else
                                        <span class="badge px-3 py-2 fw-semibold" style="background: #FEF3C7; color: #92400E; border-radius: 20px;">
                                            <i class="fas fa-envelope me-1" style="font-size: 0.65rem;"></i> Belum Dibaca
                                        </span>
                                    @endif
                                </td>
                                <td class="pe-4 text-end">
                                    <div class="btn-group gap-1" role="group">
                                        <a href="{{ route('notifications.show', $notification) }}" class="btn btn-sm btn-light border text-info" title="Detail" style="border-radius: 8px;">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="{{ route('notifications.edit', $notification) }}" class="btn btn-sm btn-light border text-warning" title="Edit" style="border-radius: 8px;">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="6" class="text-center py-5">
                                    <div class="d-flex flex-column align-items-center justify-content-center">
                                        <div class="rounded-circle d-flex align-items-center justify-content-center mb-3" style="width: 80px; height: 80px; background: #EEF2FF; color: #4F46E5;">
                                            <i class="fas fa-bell fa-3x"></i>
                                        </div>
                                        <h6 class="fw-bold text-dark mb-1">Belum Ada Notifikasi</h6>
                                        <p class="text-muted mb-3" style="font-size: 0.875rem;">Kirim notifikasi atau pesan broadcast baru kepada pengajar atau siswa.</p>
                                        <a href="{{ route('notifications.create') }}" class="btn btn-sm text-white px-4 py-2" style="background: #4F46E5; border-radius: 8px;">
                                            <i class="fas fa-plus me-1"></i> Buat Notifikasi Baru
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>

        @if($notifications->hasPages())
            <div class="card-footer bg-white py-3 px-4" style="border-top: 1px solid #F1F5F9;">
                {{ $notifications->links() }}
            </div>
        @endif

    </div>
</div>
@endsection