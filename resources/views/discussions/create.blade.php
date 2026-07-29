@extends('adminlte::page')

@section('title','Diskusi Baru')

@section('content')

<div class="card">

<form
action="{{ route('discussions.store') }}"
method="POST">

@csrf

<div class="card-header">

<h3>Diskusi Baru</h3>

</div>

<div class="card-body">

@include('discussions._form')

</div>

<div class="card-footer">

<button class="btn btn-primary">

Simpan

</button>

</div>

</form>

</div>

@endsection