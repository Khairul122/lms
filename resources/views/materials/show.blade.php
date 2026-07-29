@extends('adminlte::page')

@section('title','Detail Materi')

@section('content_header')

<h1>

    <i class="fas fa-book-open"></i>

    Detail Materi

</h1>

@stop

@section('content')

<div class="card">

    <div class="card-header">

        <h3 class="card-title">

            {{ $material->title }}

        </h3>

    </div>

    <div class="card-body">

        <table class="table table-bordered">

            <tr>

                <th width="250">Kelas</th>

                <td>

                    {{ $material->classroom->class_name ?? '-' }}

                </td>

            </tr>

            <tr>

                <th>Pertemuan</th>

                <td>

                    {{ $material->meeting->nama_pertemuan ?? '-' }}

                </td>

            </tr>

            <tr>

                <th>Nomor Pertemuan</th>

                <td>

                    {{ $material->pertemuan }}

                </td>

            </tr>

            <tr>

                <th>Judul Materi</th>

                <td>

                    {{ $material->title }}

                </td>

            </tr>

            <tr>

                <th>Deskripsi</th>

                <td>

                    {!! nl2br(e($material->description)) !!}

                </td>

            </tr>

            <tr>

                <th>File Materi</th>

                <td>

                    @if($material->file_url)

                        <a
                            href="{{ asset('storage/'.$material->file_url) }}"
                            target="_blank"
                            class="btn btn-success">

                            <i class="fas fa-download"></i>

                            Download File

                        </a>

                    @else

                        <span class="text-danger">

                            Tidak ada file.

                        </span>

                    @endif

                </td>

            </tr>

            <tr>

                <th>Video Youtube</th>

                <td>

                    @if($material->youtube_url)

                        <a
                            href="{{ $material->youtube_url }}"
                            target="_blank"
                            class="btn btn-danger">

                            <i class="fab fa-youtube"></i>

                            Buka Youtube

                        </a>

                    @else

                        <span class="text-danger">

                            Tidak ada video.

                        </span>

                    @endif

                </td>

            </tr>

            <tr>

                <th>Dibuat</th>

                <td>

                    {{ $material->created_at->format('d M Y H:i') }}

                </td>

            </tr>

        </table>

    </div>

    <div class="card-footer">

        <a
            href="{{ route('materials.index') }}"
            class="btn btn-secondary">

            <i class="fas fa-arrow-left"></i>

            Kembali

        </a>

        <a
            href="{{ route('materials.edit',$material) }}"
            class="btn btn-warning">

            <i class="fas fa-edit"></i>

            Edit

        </a>

    </div>

</div>

@stop