@extends('adminlte::page')

@section('title','Submission')

@section('content_header')
<h1>
    <i class="fas fa-upload"></i>
    Data Submission
</h1>
@stop

@section('content')

<div class="card">

    <div class="card-header">

        <form method="GET">

            <div class="row">

                <div class="col-md-10">

                    <input
                        type="text"
                        name="keyword"
                        class="form-control"
                        placeholder="Cari submission...">

                </div>

                <div class="col-md-2">

                    <button class="btn btn-primary btn-block">

                        Cari

                    </button>

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

            <thead>

            <tr>

                <th>No</th>

                <th>Siswa</th>

                <th>Tugas</th>

                <th>Upload</th>

                <th>Nilai</th>

                <th>Status</th>

                <th>Aksi</th>

            </tr>

            </thead>

            <tbody>

            @forelse($submissions as $submission)

            <tr>

                <td>

                    {{ $loop->iteration }}

                </td>

                <td>

                    {{ $submission->student->name }}

                </td>

                <td>

                    {{ $submission->task->title }}

                </td>

                <td>

                    <a
                        href="{{ asset('storage/'.$submission->file_path) }}"
                        target="_blank"
                        class="btn btn-info btn-sm">

                        Download

                    </a>

                </td>

                <td>

                    {{ $submission->score ?? '-' }}

                </td>

                <td>

                    @if($submission->score)

                        <span class="badge badge-success">

                            Sudah Dinilai

                        </span>

                    @else

                        <span class="badge badge-warning">

                            Belum Dinilai

                        </span>

                    @endif

                </td>

                <td>

                    <a
                        href="{{ route('submissions.show',$submission) }}"
                        class="btn btn-info btn-sm">

                        <i class="fas fa-eye"></i>

                    </a>

                    <a
                        href="{{ route('submissions.edit',$submission) }}"
                        class="btn btn-warning btn-sm">

                        <i class="fas fa-edit"></i>

                    </a>

                </td>

            </tr>

            @empty

            <tr>

                <td colspan="7" class="text-center">

                    Belum ada submission.

                </td>

            </tr>

            @endforelse

            </tbody>

        </table>

    </div>

    <div class="card-footer">

        {{ $submissions->links() }}

    </div>

</div>

@stop