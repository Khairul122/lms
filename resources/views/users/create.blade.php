@extends('adminlte::page')

@section('title','Tambah User')

@section('content')

<div class="card">

<div class="card-header">

Tambah User

</div>

<div class="card-body">

<form
action="{{ route('users.store') }}"
method="POST"
enctype="multipart/form-data">

@csrf

@include('users._form')

<button
class="btn btn-success">

Simpan

</button>

</form>

</div>

</div>

@endsection