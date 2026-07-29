@extends('adminlte::page')

@section('title','Penilaian Submission')

@section('content_header')

<h1>

    <i class="fas fa-star"></i>

    Penilaian Submission

</h1>

@stop

@section('content')

<div class="card">

    <div class="card-body">

        <form
            method="POST"
            action="{{ route('submissions.update',$submission) }}">

            @csrf

            @method('PUT')

            <div class="form-group">

                <label>

                    Nama Siswa

                </label>

                <input
                    class="form-control"
                    value="{{ $submission->student->name }}"
                    readonly>

            </div>

            <div class="form-group">

                <label>

                    Judul Tugas

                </label>

                <input
                    class="form-control"
                    value="{{ $submission->task->title }}"
                    readonly>

            </div>

            <div class="form-group">

                <label>

                    Nilai

                </label>

                <input
                    type="number"
                    name="score"
                    class="form-control"
                    min="0"
                    max="{{ $submission->task->max_score }}"
                    value="{{ $submission->score }}">

            </div>

            <div class="form-group">

                <label>

                    Feedback Guru

                </label>

                <textarea
                    name="teacher_note"
                    rows="5"
                    class="form-control">{{ $submission->teacher_note }}</textarea>

            </div>

            <button
                class="btn btn-success">

                <i class="fas fa-save"></i>

                Simpan Nilai

            </button>

            <a
                href="{{ route('submissions.index') }}"
                class="btn btn-secondary">

                Kembali

            </a>

        </form>

    </div>

</div>

@stop