@extends('adminlte::page')

@section('title','Tambah Tugas')

@section('content')

<div class="card">

    <form
        action="{{ route('tasks.store') }}"
        method="POST"
        enctype="multipart/form-data">

        @csrf

        <div class="card-header">

            <h3>Tambah Tugas</h3>

        </div>

        <div class="card-body">

            @include('tasks._form')

        </div>

        <div class="card-footer">

            <button class="btn btn-primary">

                Simpan

            </button>

            <a
                href="{{ route('tasks.index') }}"
                class="btn btn-secondary">

                Kembali

            </a>

        </div>

    </form>

</div>

@endsection