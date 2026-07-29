@extends('adminlte::page')

@section('title', 'Diskusi')

@section('content')

<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h3>Diskusi</h3>
        <a href="{{ route('discussions.create') }}" class="btn btn-primary">
            Diskusi Baru
        </a>
    </div>

    <div class="card-body">
        <table class="table table-bordered table-hover">
            <thead>
                <tr>
                    <th>No</th>
                    <th>Pengguna</th>
                    <th>Kelas</th>
                    <th>Pertemuan</th>
                    <th>Pesan</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                @forelse($discussions as $discussion)
                    <tr>
                        <td>{{ $loop->iteration }}</td>
                        <td>{{ $discussion->user->name }}</td>
                        <td>{{ $discussion->classroom->class_name }}</td>
                        {{-- 🔥 Perbaikan Null-safe operator di sini --}}
                        <td>{{ $discussion->meeting?->pertemuan ?? 'Diskusi Umum (Tanpa Pertemuan)' }}</td>
                        <td>{{ Str::limit($discussion->message, 60) }}</td>
                        <td>
                            <a href="{{ route('discussions.show', $discussion) }}" class="btn btn-info btn-sm">
                                Detail
                            </a>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="6" class="text-center">
                            Belum ada diskusi.
                        </td>
                    </tr>
                @endforelse
            </tbody>
        </table>

        <div class="mt-3">
            {{ $discussions->links() }}
        </div>
    </div>
</div>

@endsection