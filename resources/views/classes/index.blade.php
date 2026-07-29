@extends('adminlte::page')

@section('title', 'Data Kelas')

@section('content')

<div class="container-fluid">

    {{-- Header --}}
    <div class="row mb-3">

        <div class="col-md-6">

            <h2>
                <i class="fas fa-school text-primary"></i>
                Manajemen Kelas
            </h2>

            <small class="text-muted">
                Kelola seluruh kelas pada EduSmart LMS
            </small>

        </div>

        <div class="col-md-6 text-end">

            <a href="{{ route('classes.create') }}" class="btn btn-primary">

                <i class="fas fa-plus-circle"></i>

                Tambah Kelas

            </a>

        </div>

    </div>

    {{-- Statistik --}}
    <div class="row mb-4">

        <div class="col-md-3">

            <div class="small-box bg-primary">

                <div class="inner">

                    <h3>{{ $classes->total() }}</h3>

                    <p>Total Kelas</p>

                </div>

                <div class="icon">

                    <i class="fas fa-school"></i>

                </div>

            </div>

        </div>

    </div>

    {{-- Card --}}
    <div class="card shadow">

        <div class="card-header bg-white">

            <div class="row">

                <div class="col-md-6">

                    <h5 class="mb-0">

                        <i class="fas fa-list"></i>

                        Daftar Kelas

                    </h5>

                </div>

                <div class="col-md-6">

                    <form method="GET">

                        <div class="input-group">

                            <input
                                type="text"
                                name="search"
                                class="form-control"
                                placeholder="Cari nama kelas atau mata pelajaran..."
                                value="{{ request('search') }}">

                            <button class="btn btn-primary">

                                <i class="fas fa-search"></i>

                            </button>

                        </div>

                    </form>

                </div>

            </div>

        </div>

        <div class="card-body">

            @if(session('success'))

                <div class="alert alert-success">

                    <i class="fas fa-check-circle"></i>

                    {{ session('success') }}

                </div>

            @endif

            <div class="table-responsive">

                <table class="table table-striped table-hover align-middle">

                    <thead class="table-dark">

                    <tr>

                        <th width="60">#</th>

                        <th>Kode</th>

                        <th>Nama Kelas</th>

                        <th>Mata Pelajaran</th>

                        <th>Guru</th>

                        <th>Status</th>

                        <th width="180">Aksi</th>

                    </tr>

                    </thead>

                    <tbody>

                    @forelse($classes as $item)

                        <tr>

                            <td>{{ $loop->iteration }}</td>

                            <td>

                                <span class="badge bg-primary">

                                    {{ $item->class_code }}

                                </span>

                            </td>

                            <td>

                                <strong>

                                    {{ $item->class_name }}

                                </strong>

                            </td>

                            <td>

                                {{ $item->subject }}

                            </td>

                            <td>

                                {{ optional($item->teacher)->name ?? '-' }}

                            </td>

                            <td>

                                @if($item->is_active)

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
                                    href="{{ route('classes.show',$item) }}"
                                    class="btn btn-info btn-sm">

                                    <i class="fas fa-eye"></i>

                                </a>

                                <a
                                    href="{{ route('classes.edit',$item) }}"
                                    class="btn btn-warning btn-sm">

                                    <i class="fas fa-edit"></i>

                                </a>

                                <form
                                    action="{{ route('classes.destroy',$item) }}"
                                    method="POST"
                                    class="d-inline">

                                    @csrf

                                    @method('DELETE')

                                    <button
                                        onclick="return confirm('Yakin ingin menghapus kelas ini?')"
                                        class="btn btn-danger btn-sm">

                                        <i class="fas fa-trash"></i>

                                    </button>

                                </form>

                            </td>

                        </tr>

                    @empty

                        <tr>

                            <td colspan="7" class="text-center">

                                <img
                                    src="https://cdn-icons-png.flaticon.com/512/7486/7486740.png"
                                    width="120">

                                <br><br>

                                <strong>

                                    Belum ada data kelas

                                </strong>

                            </td>

                        </tr>

                    @endforelse

                    </tbody>

                </table>

            </div>

        </div>

        <div class="card-footer">

            {{ $classes->withQueryString()->links() }}

        </div>

    </div>

</div>

@endsection