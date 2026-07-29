@extends('adminlte::page')

@section('title', 'Edit Materi')

@section('content_header')
<h1>
    <i class="fas fa-edit"></i>
    Edit Materi
</h1>
@stop

@section('content')

<div class="card">

    <div class="card-body">

        <form
            action="{{ route('materials.update',$material) }}"
            method="POST"
            enctype="multipart/form-data">

            @csrf
            @method('PUT')

            <div class="form-group">

                <label>Kelas</label>

                <select
                    name="class_id"
                    class="form-control"
                    required>

                    @foreach($classes as $class)

                    <option
                        value="{{ $class->id }}"
                        {{ $material->class_id==$class->id ? 'selected':'' }}>

                        {{ $class->class_name }}

                    </option>

                    @endforeach

                </select>

            </div>

            <div class="form-group">

                <label>Pertemuan</label>

                <select
                    name="meeting_id"
                    class="form-control"
                    required>

                    @foreach($meetings as $meeting)

                    <option
                        value="{{ $meeting->id }}"
                        {{ $material->meeting_id==$meeting->id ? 'selected':'' }}>

                        Pertemuan {{ $meeting->pertemuan }}
                        -
                        {{ $meeting->nama_pertemuan }}

                    </option>

                    @endforeach

                </select>

            </div>

            <div class="form-group">

                <label>Nomor Pertemuan</label>

                <input
                    type="number"
                    name="pertemuan"
                    class="form-control"
                    value="{{ $material->pertemuan }}"
                    required>

            </div>

            <div class="form-group">

                <label>Judul Materi</label>

                <input
                    type="text"
                    name="title"
                    class="form-control"
                    value="{{ $material->title }}"
                    required>

            </div>

            <div class="form-group">

                <label>Deskripsi</label>

                <textarea
                    name="description"
                    rows="5"
                    class="form-control">{{ $material->description }}</textarea>

            </div>

            <div class="form-group">

                <label>Upload File Baru</label>

                <input
                    type="file"
                    name="file"
                    class="form-control">

            </div>

            @if($material->file_url)

            <div class="alert alert-info">

                File sekarang :

                <a
                    href="{{ asset('storage/'.$material->file_url) }}"
                    target="_blank">

                    Download

                </a>

            </div>

            @endif

            <div class="form-group">

                <label>Youtube</label>

                <input
                    type="url"
                    name="youtube_url"
                    class="form-control"
                    value="{{ $material->youtube_url }}">

            </div>

            <button class="btn btn-primary">

                <i class="fas fa-save"></i>

                Update

            </button>

            <a
                href="{{ route('materials.index') }}"
                class="btn btn-secondary">

                Kembali

            </a>

        </form>

    </div>

</div>

@stop