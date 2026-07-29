@extends('adminlte::page')

@section('title', 'Data Tugas')

@section('content_header')
    <div class="d-flex justify-content-between align-items-center mb-2">
        <div>
            <h1 class="text-dark fw-bold m-0" style="font-size: 1.75rem; color: #0F172A;">
                <i class="fas fa-tasks text-indigo me-2" style="color: #4F46E5;"></i> Data Tugas
            </h1>
            <p class="text-muted mb-0" style="font-size: 0.9rem;">Kelola seluruh penugasan siswa, batas waktu, dan nilai pada EduSmart LMS</p>
        </div>
        <a href="{{ route('tasks.create') }}" class="btn text-white px-4 py-2 shadow-sm" style="background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%); border-radius: 10px; font-weight: 600;">
            <i class="fas fa-plus-circle me-1"></i> Tambah Tugas Baru
        </a>
    </div>
@endsection

@section('content')
<div class="container-fluid px-0">

    {{-- Main Table Card --}}
    <div class="card border-0 shadow-sm" style="border-radius: 16px; border: 1px solid #E2E8F0; overflow: hidden;">
        
        <div class="card-header bg-white py-3 px-4 d-flex align-items-center justify-content-between" style="border-bottom: 1px solid #F1F5F9;">
            <h5 class="fw-bold mb-0 text-dark d-flex align-items-center">
                <i class="fas fa-list me-2" style="color: #4F46E5;"></i> Daftar Seluruh Tugas Siswa
            </h5>
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
                            <th>Kelas</th>
                            <th>Pertemuan</th>
                            <th>Judul Tugas</th>
                            <th>Deadline</th>
                            <th>Max Skor</th>
                            <th>Lampiran</th>
                            <th>Status</th>
                            <th class="pe-4 text-end" width="160">Aksi</th>
                        </tr>
                    </thead>
                    <tbody style="color: #1E293B;">
                        @forelse($tasks as $task)
                            <tr style="border-bottom: 1px solid #F1F5F9;">
                                <td class="ps-4 fw-semibold text-muted">{{ $loop->iteration + ($tasks->currentPage()-1)*$tasks->perPage() }}</td>
                                <td>
                                    <span class="badge px-3 py-2 fw-semibold" style="background: #EEF2FF; color: #4338CA; border-radius: 8px;">
                                        {{ optional($task->classroom)->class_name ?? '-' }}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge px-3 py-2 fw-bold" style="background: #FEF3C7; color: #92400E; border-radius: 8px;">
                                        Pertemuan {{ optional($task->meeting)->pertemuan ?? '-' }}
                                    </span>
                                </td>
                                <td>
                                    <span class="fw-bold text-dark d-block">{{ $task->title }}</span>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center text-muted" style="font-size: 0.85rem;">
                                        <i class="far fa-clock me-1 text-warning"></i>
                                        {{ \Carbon\Carbon::parse($task->deadline)->format('d M Y, H:i') }}
                                    </div>
                                </td>
                                <td>
                                    <span class="badge px-3 py-2 fw-bold" style="background: #E0E7FF; color: #3730A3; border-radius: 8px;">
                                        {{ $task->max_score }} Poin
                                    </span>
                                </td>
                                <td>
                                    @if($task->attachment)
                                        <a href="{{ asset('storage/'.$task->attachment) }}" target="_blank" class="btn btn-sm btn-light border text-success fw-medium" style="border-radius: 8px;">
                                            <i class="fas fa-paperclip me-1"></i> File
                                        </a>
                                    @else
                                        <span class="badge bg-light text-muted border px-2 py-1" style="border-radius: 6px;">Tidak ada</span>
                                    @endif
                                </td>
                                <td>
                                    @if($task->is_active)
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
                                        <a href="{{ route('tasks.show', $task->id) }}" class="btn btn-sm btn-light border text-info" title="Detail" style="border-radius: 8px;">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="{{ route('tasks.edit', $task->id) }}" class="btn btn-sm btn-light border text-warning" title="Edit" style="border-radius: 8px;">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <form action="{{ route('tasks.destroy', $task->id) }}" method="POST" class="d-inline">
                                            @csrf
                                            @method('DELETE')
                                            <button onclick="return confirm('Yakin ingin menghapus tugas ini?')" class="btn btn-sm btn-light border text-danger" title="Hapus" style="border-radius: 8px;">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="9" class="text-center py-5">
                                    <div class="d-flex flex-column align-items-center justify-content-center">
                                        <div class="rounded-circle d-flex align-items-center justify-content-center mb-3" style="width: 80px; height: 80px; background: #EEF2FF; color: #4F46E5;">
                                            <i class="fas fa-tasks fa-3x"></i>
                                        </div>
                                        <h6 class="fw-bold text-dark mb-1">Belum Ada Data Tugas</h6>
                                        <p class="text-muted mb-3" style="font-size: 0.875rem;">Terbitkan tugas pertama Anda untuk mengukur tingkat pemahaman siswa.</p>
                                        <a href="{{ route('tasks.create') }}" class="btn btn-sm text-white px-4 py-2" style="background: #4F46E5; border-radius: 8px;">
                                            <i class="fas fa-plus me-1"></i> Tambah Tugas Baru
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>

        @if($tasks->hasPages())
            <div class="card-footer bg-white py-3 px-4" style="border-top: 1px solid #F1F5F9;">
                {{ $tasks->links() }}
            </div>
        @endif

    </div>
</div>
@endsection