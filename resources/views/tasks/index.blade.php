@extends('adminlte::page')

@section('title', 'Data Tugas')

@section('content')

<div class="card">

    <div class="card-header d-flex justify-content-between align-items-center">

        <h3 class="card-title">
            <i class="fas fa-tasks"></i>
            Data Tugas
        </h3>

        <a href="{{ route('tasks.create') }}" class="btn btn-primary">
            <i class="fas fa-plus"></i>
            Tambah Tugas
        </a>

    </div>

    <div class="card-body">

        @if(session('success'))

            <div class="alert alert-success alert-dismissible fade show">

                {{ session('success') }}

                <button
                    type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
                </button>

            </div>

        @endif

        <div class="table-responsive">

            <table class="table table-bordered table-hover">

                <thead class="table-dark">

                    <tr>

                        <th width="60">No</th>

                        <th>Kelas</th>

                        <th>Pertemuan</th>

                        <th>Judul Tugas</th>

                        <th>Deadline</th>

                        <th>Nilai</th>

                        <th>Lampiran</th>

                        <th>Status</th>

                        <th width="220">Aksi</th>

                    </tr>

                </thead>

                <tbody>

                @forelse($tasks as $task)

                    <tr>

                        <td>

                            {{ $loop->iteration + ($tasks->currentPage()-1)*$tasks->perPage() }}

                        </td>

                        <td>

                            {{ optional($task->classroom)->class_name }}

                        </td>

                        <td>

                            Pertemuan

                            {{ optional($task->meeting)->pertemuan }}

                        </td>

                        <td>

                            <strong>

                                {{ $task->title }}

                            </strong>

                        </td>

                        <td>

                            {{ \Carbon\Carbon::parse($task->deadline)->format('d M Y H:i') }}

                        </td>

                        <td>

                            <span class="badge bg-primary">

                                {{ $task->max_score }}

                            </span>

                        </td>

                        <td>

                            @if($task->attachment)

                                <a
                                    href="{{ asset('storage/'.$task->attachment) }}"
                                    target="_blank"
                                    class="btn btn-success btn-xs">

                                    <i class="fas fa-download"></i>

                                    Download

                                </a>

                            @else

                                <span class="badge bg-secondary">

                                    Tidak Ada

                                </span>

                            @endif

                        </td>

                        <td>

                            @if($task->is_active)

                                <span class="badge bg-success">

                                    Aktif

                                </span>

                            @else

                                <span class="badge bg-danger">

                                    Nonaktif

                                </span>

                            @endif

                        </td>

                        <td>

                            <a
                                href="{{ route('tasks.show',$task->id) }}"
                                class="btn btn-info btn-sm">

                                <i class="fas fa-eye"></i>

                            </a>

                            <a
                                href="{{ route('tasks.edit',$task->id) }}"
                                class="btn btn-warning btn-sm">

                                <i class="fas fa-edit"></i>

                            </a>

                            <form
                                action="{{ route('tasks.destroy',$task->id) }}"
                                method="POST"
                                class="d-inline">

                                @csrf

                                @method('DELETE')

                                <button
                                    class="btn btn-danger btn-sm"
                                    onclick="return confirm('Yakin ingin menghapus tugas ini?')">

                                    <i class="fas fa-trash"></i>

                                </button>

                            </form>

                        </td>

                    </tr>

                @empty

                    <tr>

                        <td colspan="9" class="text-center">

                            <i class="fas fa-folder-open"></i>

                            Belum ada data tugas.

                        </td>

                    </tr>

                @endforelse

                </tbody>

            </table>

        </div>

        <div class="mt-3 d-flex justify-content-end">

            {{ $tasks->links() }}

        </div>

    </div>

</div>

@endsection