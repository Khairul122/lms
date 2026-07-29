@extends('adminlte::page')

@section('title','Tambah Pertemuan')

@section('content')

<div class="card">

<div class="card-header">

Tambah Pertemuan

</div>

<div class="card-body">

<form
action="{{ route('meetings.store') }}"
method="POST">

@csrf

@include('meetings._form')

<button class="btn btn-primary">

Simpan

</button>

<a
href="{{ route('meetings.index') }}"
class="btn btn-secondary">

Kembali

</a>

</form>

</div>

</div>

@endsection