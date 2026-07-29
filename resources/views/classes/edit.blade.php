@extends('adminlte::page')

@section('title','Edit Kelas')

@section('content')

<div class="card">

<div class="card-header">

Edit Kelas

</div>

<div class="card-body">

<form
action="{{ route('classes.update',$class) }}"
method="POST">

@csrf

@method('PUT')

@include('classes._form')

<button class="btn btn-success">

Update

</button>

<a href="{{ route('classes.index') }}"
class="btn btn-secondary">

Kembali

</a>

</form>

</div>

</div>

@endsection