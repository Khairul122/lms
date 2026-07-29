@extends('adminlte::page')

@section('title','Tambah Guru')

@section('content')

<div class="card">

<form
action="{{ route('guru.store') }}"
method="POST"
enctype="multipart/form-data">

@csrf

<div class="card-header">

<h3>Tambah Guru</h3>

</div>

<div class="card-body">

@include('guru._form')

</div>

<div class="card-footer">

<button class="btn btn-primary">

Simpan

</button>

<a
href="{{ route('guru.index') }}"
class="btn btn-secondary">

Kembali

</a>

</div>

</form>

</div>

@endsection