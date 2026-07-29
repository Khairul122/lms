@extends('adminlte::page')

@section('title','Detail User')

@section('content')

<div class="card">

<div class="card-body text-center">

@if($user->photo)

<img
src="{{ asset('storage/'.$user->photo) }}"
width="150"
class="rounded-circle mb-3">

@endif

<h3>{{ $user->name }}</h3>

<p>{{ $user->email }}</p>

<p>{{ ucfirst($user->role) }}</p>

<a
href="{{ route('users.index') }}"
class="btn btn-secondary">

Kembali

</a>

</div>

</div>

@endsection