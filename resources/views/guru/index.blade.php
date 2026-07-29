@extends('adminlte::page')

@section('title', 'Data Guru')

@section('content')

<div class="card">

    <div class="card-header d-flex justify-content-between align-items-center">

        <h3 class="card-title">
            <i class="fas fa-chalkboard-teacher"></i>
            Data Guru
        </h3>

        <a href="{{ route('guru.create') }}" class="btn btn-primary">
            <i class="fas fa-plus"></i>
            Tambah Guru
        </a>

    </div>

    <div class="card-body">

        @if(session('success'))

            <div class="alert alert-success alert-dismissible fade show">

                {{ session('success') }}

                <button
                    type="button"
                    class="close"
                    data-dismiss="alert">

                    <span>&times;</span>

                </button>

            </div>

        @endif

        <form method="GET">

            <div class="row mb-3">

                <div class="col-md-4">

                    <input
                        type="text"
                        name="keyword"
                        class="form-control"
                        placeholder="Cari guru..."
                        value="{{ request('keyword') }}">

                </div>

                <div class="col-md-2">

                    <button class="btn btn-primary">

                        <i class="fas fa-search"></i>

                        Cari

                    </button>

                </div>

            </div>

        </form>

        <div class="table-responsive">

            <table class="table table-bordered table-hover">

                <thead class="table-dark">

                    <tr>

                        <th width="60">No</th>

                        <th width="80">Foto</th>

                        <th>Nama</th>

                        <th>Username</th>

                        <th>Email</th>

                        <th>NIP</th>

                        <th>Telepon</th>

                        <th width="180">Aksi</th>

                    </tr>

                </thead>

                <tbody>

                @forelse($gurus as $guru)

                    <tr>

                        <td>

                            {{ $loop->iteration + ($gurus->currentPage()-1)*$gurus->perPage() }}

                        </td>

                        <td>

                            @if($guru->photo)

                                <img
                                    src="{{ asset('storage/'.$guru->photo) }}"
                                    class="img-circle elevation-2"
                                    width="50"
                                    height="50">

                            @else

                                <img
                                    src="https://ui-avatars.com/api/?name={{ urlencode($guru->name) }}"
                                    class="img-circle elevation-2"
                                    width="50"
                                    height="50">

                            @endif

                        </td>

                        <td>{{ $guru->name }}</td>

                        <td>{{ $guru->username }}</td>

                        <td>{{ $guru->email }}</td>

                        <td>{{ $guru->nip }}</td>

                        <td>{{ $guru->phone }}</td>

                        <td>

                            <a
                                href="{{ route('guru.show',$guru->id) }}"
                                class="btn btn-info btn-sm">

                                <i class="fas fa-eye"></i>

                            </a>

                            <a
                                href="{{ route('guru.edit',$guru->id) }}"
                                class="btn btn-warning btn-sm">

                                <i class="fas fa-edit"></i>

                            </a>

                            <form
                                action="{{ route('guru.destroy',$guru->id) }}"
                                method="POST"
                                class="d-inline">

                                @csrf

                                @method('DELETE')

                                <button
                                    class="btn btn-danger btn-sm"
                                    onclick="return confirm('Yakin ingin menghapus guru ini?')">

                                    <i class="fas fa-trash"></i>

                                </button>

                            </form>

                        </td>

                    </tr>

                @empty

                    <tr>

                        <td colspan="8" class="text-center">

                            Belum ada data guru.

                        </td>

                    </tr>

                @endforelse

                </tbody>

            </table>

        </div>

        <div class="mt-3">

            {{ $gurus->links() }}

        </div>

    </div>

</div>

@endsection