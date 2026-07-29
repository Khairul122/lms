@extends('adminlte::page')

@section('title','Tambah Kelas')

@section('content')

<div class="card">

<div class="card-header">

Tambah Kelas

</div>

<div class="card-body">

<form
action="{{ route('classes.store') }}"
method="POST">

@csrf

@include('classes._form')

<button class="btn btn-primary">

Simpan

</button>

<a href="{{ route('classes.index') }}"
class="btn btn-secondary">

Kembali

</a>

</form>

</div>

</div>

@endsection