@extends('adminlte::page')

@section('title', 'Tambah Materi')

@section('content_header')
<h1>
    <i class="fas fa-plus-circle"></i>
    Tambah Materi
</h1>
@stop

@section('content')

<div class="card">

    <div class="card-body">

        <form
            action="{{ route('materials.store') }}"
            method="POST"
            enctype="multipart/form-data">

            @csrf

            <div class="form-group">

                <label>Kelas</label>

                <select
                    name="class_id"
                    class="form-control"
                    required>

                    <option value="">-- Pilih Kelas --</option>

                    @foreach($classes as $class)

                    <option value="{{ $class->id }}">

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

                    <option value="">-- Pilih Pertemuan --</option>

                    @foreach($meetings as $meeting)

                    <option value="{{ $meeting->id }}">

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
                    required>

            </div>

            <div class="form-group">

                <label>Judul Materi</label>

                <input
                    type="text"
                    name="title"
                    class="form-control"
                    required>

            </div>

            <div class="form-group">

                <label>Deskripsi</label>

                <textarea
                    name="description"
                    rows="5"
                    class="form-control"></textarea>

            </div>

            <div class="form-group">

                <label>Upload File</label>

                <input
                    type="file"
                    name="file"
                    class="form-control">

                <small class="text-muted">

                    PDF, DOC, DOCX, PPT, PPTX

                </small>

            </div>

            <div class="form-group">

                <label>Link Youtube</label>

                <input
                    type="url"
                    name="youtube_url"
                    class="form-control">

            </div>

            <button class="btn btn-success">

                <i class="fas fa-save"></i>

                Simpan

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