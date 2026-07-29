@extends('adminlte::page')

@section('title','Detail Pertemuan')

@section('content')

<div class="card">
    <div class="card-header bg-primary text-white">
        <h4 class="mb-0">
            {{ $meeting->nama_pertemuan }}
        </h4>
    </div>

    <div class="card-body">
        <table class="table table-striped">
            <tr>
                <th style="width: 200px;">Kelas</th>
                <td>{{ $meeting->classroom->class_name ?? '-' }}</td>
            </tr>
            <tr>
                <th>Pertemuan</th>
                <td>{{ $meeting->pertemuan }}</td>
            </tr>
            <tr>
                <th>Nama</th>
                <td>{{ $meeting->nama_pertemuan }}</td>
            </tr>
            <tr>
                <th>Tema</th>
                <td>{{ $meeting->tema_pertemuan }}</td>
            </tr>
        </table>

        {{-- BAGIAN DAFTAR MATERI --}}
        <div class="mt-4">
            <h5 class="font-weight-bold text-primary"><i class="fas fa-book mr-2"></i>Daftar Materi</h5>
            <div class="table-responsive">
                <table class="table table-bordered table-hover">
                    <thead class="thead-light">
                        <tr>
                            <th style="width: 50px;">#</th>
                            <th>Judul Materi</th>
                            <th>Deskripsi</th>
                            <th>Lampiran / Media</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($meeting->materials as $key => $material)
                            <tr>
                                <td>{{ $key + 1 }}</td>
                                <td><strong>{{ $material->title }}</strong></td>
                                <td>{{ $material->description ?? '-' }}</td>
                                <td>
                                    @if($material->file_url)
                                        <a href="{{ asset('storage/' . $material->file_url) }}" target="_blank" class="btn btn-sm btn-info">
                                            <i class="fas fa-download mr-1"></i> File
                                        </a>
                                    @endif
                                    @if($material->youtube_url)
                                        <a href="{{ $material->youtube_url }}" target="_blank" class="btn btn-sm btn-danger">
                                            <i class="fab fa-youtube mr-1"></i> YouTube
                                        </a>
                                    @endif
                                    @if(!$material->file_url && !$material->youtube_url)
                                        <span class="text-muted">Tidak ada lampiran</span>
                                    @endif
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="4" class="text-center text-muted">Belum ada materi untuk pertemuan ini.</td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>

        {{-- BAGIAN DAFTAR TUGAS --}}
        <div class="mt-4">
            <h5 class="font-weight-bold text-success"><i class="fas fa-tasks mr-2"></i>Daftar Tugas</h5>
            <div class="table-responsive">
                <table class="table table-bordered table-hover">
                    <thead class="thead-light">
                        <tr>
                            <th style="width: 50px;">#</th>
                            <th>Judul Tugas</th>
                            <th>Deskripsi</th>
                            <th>Deadline</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($meeting->assignments ?? [] as $key => $assignment)
                            <tr>
                                <td>{{ $key + 1 }}</td>
                                <td><strong>{{ $assignment->title }}</strong></td>
                                <td>{{ $assignment->description ?? '-' }}</td>
                                <td>{{ $assignment->due_date ?? '-' }}</td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="4" class="text-center text-muted">Belum ada tugas untuk pertemuan ini.</td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>

        <div class="mt-4">
            <a href="{{ route('meetings.index') }}" class="btn btn-secondary">
                <i class="fas fa-arrow-left mr-1"></i> Kembali
            </a>
        </div>

    </div>
</div>

@endsection