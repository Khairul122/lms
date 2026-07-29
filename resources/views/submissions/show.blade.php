@extends('adminlte::page')

@section('title','Detail Submission')

@section('content_header')

<h1>

    <i class="fas fa-file-upload"></i>

    Detail Submission

</h1>

@stop

@section('content')

<div class="card">

    <div class="card-header bg-primary text-white">

        Detail Jawaban Siswa

    </div>

    <div class="card-body">

        <table class="table table-bordered">

            <tr>

                <th width="250">

                    Nama Siswa

                </th>

                <td>

                    {{ $submission->student->name }}

                </td>

            </tr>

            <tr>

                <th>

                    Judul Tugas

                </th>

                <td>

                    {{ $submission->task->title }}

                </td>

            </tr>

            <tr>

                <th>

                    Catatan Siswa

                </th>

                <td>

                    {{ $submission->note ?? '-' }}

                </td>

            </tr>

            <tr>

                <th>

                    Waktu Upload

                </th>

                <td>

                    {{ $submission->submitted_at }}

                </td>

            </tr>

            <tr>

                <th>

                    Nilai

                </th>

                <td>

                    {{ $submission->score ?? '-' }}

                </td>

            </tr>

            <tr>

                <th>

                    Feedback Guru

                </th>

                <td>

                    {{ $submission->teacher_note ?? '-' }}

                </td>

            </tr>

            <tr>

                <th>

                    File Jawaban

                </th>

                <td>

                    @if($submission->file_path)

                        <a
                            href="{{ asset('storage/'.$submission->file_path) }}"
                            target="_blank"
                            class="btn btn-success">

                            <i class="fas fa-download"></i>

                            Download File

                        </a>

                    @endif

                </td>

            </tr>

        </table>

    </div>

    <div class="card-footer">

        <a
            href="{{ route('submissions.index') }}"
            class="btn btn-secondary">

            Kembali

        </a>

        <a
            href="{{ route('submissions.edit',$submission) }}"
            class="btn btn-warning">

            Beri Nilai

        </a>

    </div>

</div>

@stop