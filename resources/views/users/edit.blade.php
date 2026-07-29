@extends('adminlte::page')

@section('title','Edit User')

@section('content')

<div class="card">

<div class="card-header">

Edit User

</div>

<div class="card-body">

<form
action="{{ route('users.update',$user) }}"
method="POST"
enctype="multipart/form-data">

@csrf

@method('PUT')

@include('users._form')

<button
class="btn btn-primary">

Update

</button>

</form>

</div>

</div>

@endsection