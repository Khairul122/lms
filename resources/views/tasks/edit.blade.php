@extends('adminlte::page')

@section('title','Edit Tugas')

@section('content')

<div class="card">

<form
action="{{ route('tasks.update',$task) }}"
method="POST"
enctype="multipart/form-data">

@csrf

@method('PUT')

<div class="card-body">

@include('tasks._form')

</div>

<div class="card-footer">

<button class="btn btn-success">

Update

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