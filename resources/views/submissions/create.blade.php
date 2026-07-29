@extends('adminlte::page')

@section('title','Upload Tugas')

@section('content')

<div class="card">

<form
action="{{ route('submissions.store') }}"
method="POST"
enctype="multipart/form-data">

@csrf

<div class="card-header">

<h3>Upload Tugas</h3>

</div>

<div class="card-body">

@include('submissions._form')

</div>

<div class="card-footer">

<button class="btn btn-primary">

Upload

</button>

<a
href="{{ route('submissions.index') }}"
class="btn btn-secondary">

Kembali

</a>

</div>

</form>

</div>

@endsection