@extends('adminlte::page')

@section('title','Detail Kelas')

@section('content')

<div class="row">

<div class="col-md-12">

<div class="card">

<div class="card-header bg-primary">

<h3 class="card-title">

{{ $class->class_name }}

</h3>

</div>

<div class="card-body">

<div class="row">

<div class="col-md-6">

<table class="table">

<tr>

<th>Kode</th>

<td>{{ $class->class_code }}</td>

</tr>

<tr>

<th>Mapel</th>

<td>{{ $class->subject }}</td>

</tr>

<tr>

<th>Guru</th>

<td>{{ optional($class->teacher)->name }}</td>

</tr>

<tr>

<th>Status</th>

<td>

@if($class->is_active)

<span class="badge bg-success">

Aktif

</span>

@else

<span class="badge bg-danger">

Nonaktif

</span>

@endif

</td>

</tr>

</table>

</div>

<div class="col-md-6">

<div class="small-box bg-info">

<div class="inner">

<h3>

{{ $class->meetings->count() }}

</h3>

<p>Pertemuan</p>

</div>

</div>

<div class="small-box bg-success">

<div class="inner">

<h3>

{{ $class->materials->count() }}

</h3>

<p>Materi</p>

</div>

</div>

<div class="small-box bg-warning">

<div class="inner">

<h3>

{{ $class->tasks->count() }}

</h3>

<p>Tugas</p>

</div>

</div>

</div>

</div>

<hr>

<h4>

Daftar Pertemuan

</h4>

<a
href="{{ route('meetings.create') }}"
class="btn btn-primary mb-3">

Tambah Pertemuan

</a>

<table class="table table-bordered">

<thead>

<tr>

<th>No</th>

<th>Pertemuan</th>

<th>Nama</th>

</tr>

</thead>

<tbody>

@forelse($class->meetings as $meeting)

<tr>

<td>

{{ $loop->iteration }}

</td>

<td>

{{ $meeting->pertemuan }}

</td>

<td>

{{ $meeting->nama_pertemuan }}

</td>

</tr>

@empty

<tr>

<td colspan="3">

Belum ada pertemuan

</td>

</tr>

@endforelse

</tbody>

</table>

</div>

</div>

</div>

</div>

@endsection