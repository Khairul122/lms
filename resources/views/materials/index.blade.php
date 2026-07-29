@extends('adminlte::page')

@section('title', 'Data Materi')

@section('content_header')
<h1>
    <i class="fas fa-book"></i> Data Materi
</h1>
@stop

@section('content')

<div class="card">

    <div class="card-header">

        <form action="{{ route('materials.index') }}" method="GET">

            <div class="row">

                <div class="col-md-8">

                    <input
                        type="text"
                        name="keyword"
                        class="form-control"
                        placeholder="Cari materi..."
                        value="{{ request('keyword') }}">

                </div>

                <div class="col-md-2">

                    <button class="btn btn-primary btn-block">

                        <i class="fas fa-search"></i>

                        Cari

                    </button>

                </div>

                <div class="col-md-2 text-right">

                    <a
                        href="{{ route('materials.create') }}"
                        class="btn btn-success btn-block">

                        <i class="fas fa-plus"></i>

                        Tambah Materi

                    </a>

                </div>

            </div>

        </form>

    </div>

    <div class="card-body table-responsive">

        @if(session('success'))

        <div class="alert alert-success">

            {{ session('success') }}

        </div>

        @endif

        <table class="table table-bordered table-striped">

            <thead class="thead-dark">

                <tr>

                    <th width="60">No</th>

                    <th>Kelas</th>

                    <th>Pertemuan</th>

                    <th>Judul</th>

                    <th>File</th>

                    <th>Youtube</th>

                    <th width="180">Aksi</th>

                </tr>

            </thead>

            <tbody>

                @forelse($materials as $material)

                <tr>

                    <td>

                        {{ $loop->iteration }}

                    </td>

                    <td>

                        {{ $material->classroom->class_name ?? '-' }}

                    </td>

                    <td>

                        {{ $material->meeting->nama_pertemuan ?? '-' }}

                    </td>

                    <td>

                        {{ $material->title }}

                    </td>

                    <td>

                        @if($material->file_url)

                        <a
                            href="{{ asset('storage/'.$material->file_url) }}"
                            target="_blank"
                            class="btn btn-info btn-sm">

                            <i class="fas fa-download"></i>

                            Download

                        </a>

                        @else

                        -

                        @endif

                    </td>

                    <td>

                        @if($material->youtube_url)

                        <a
                            href="{{ $material->youtube_url }}"
                            target="_blank"
                            class="btn btn-danger btn-sm">

                            <i class="fab fa-youtube"></i>

                            Youtube

                        </a>

                        @else

                        -

                        @endif

                    </td>

                    <td>

                        <a
                            href="{{ route('materials.show',$material) }}"
                            class="btn btn-info btn-sm">

                            <i class="fas fa-eye"></i>

                        </a>

                        <a
                            href="{{ route('materials.edit',$material) }}"
                            class="btn btn-warning btn-sm">

                            <i class="fas fa-edit"></i>

                        </a>

                        <form
                            action="{{ route('materials.destroy',$material) }}"
                            method="POST"
                            class="d-inline">

                            @csrf

                            @method('DELETE')

                            <button
                                onclick="return confirm('Hapus materi?')"
                                class="btn btn-danger btn-sm">

                                <i class="fas fa-trash"></i>

                            </button>

                        </form>

                    </td>

                </tr>

                @empty

                <tr>

                    <td colspan="7" class="text-center">

                        Belum ada data materi.

                    </td>

                </tr>

                @endforelse

            </tbody>

        </table>

    </div>

    <div class="card-footer">

        {{ $materials->links() }}

    </div>

</div>

@stop