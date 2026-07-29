@extends('adminlte::page')

@section('title','Edit Pertemuan')

@section('content')

<div class="card">

<div class="card-header">

Edit Pertemuan

</div>

<div class="card-body">

<form
action="{{ route('meetings.update',$meeting) }}"
method="POST">

@csrf

@method('PUT')

@include('meetings._form')

<button class="btn btn-success">

Update

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