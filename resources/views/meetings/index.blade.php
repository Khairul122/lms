@extends('adminlte::page')

@section('title','Data Pertemuan')

@section('content')

<div class="container-fluid">

<div class="card shadow">

<div class="card-header d-flex justify-content-between">

<h4>

<i class="fas fa-calendar-alt"></i>

Data Pertemuan

</h4>

<a
href="{{ route('meetings.create') }}"
class="btn btn-primary">

<i class="fas fa-plus"></i>

Tambah Pertemuan

</a>

</div>

<div class="card-body">

@if(session('success'))

<div class="alert alert-success">

{{ session('success') }}

</div>

@endif

<form method="GET">

<div class="row mb-3">

<div class="col-md-4">

<input
type="text"
name="search"
class="form-control"
placeholder="Cari pertemuan..."
value="{{ request('search') }}">

</div>

<div class="col-md-2">

<button class="btn btn-primary">

Cari

</button>

</div>

</div>

</form>

<div class="table-responsive">

<table class="table table-striped table-hover">

<thead class="table-dark">

<tr>

<th>No</th>

<th>Kelas</th>

<th>Pertemuan</th>

<th>Nama</th>

<th width="170">

Aksi

</th>

</tr>

</thead>

<tbody>

@forelse($meetings as $meeting)

<tr>

<td>{{ $loop->iteration }}</td>

<td>

{{ $meeting->classroom->class_name }}

</td>

<td>

{{ $meeting->pertemuan }}

</td>

<td>

{{ $meeting->nama_pertemuan }}

</td>

<td>

<a
href="{{ route('meetings.show',$meeting) }}"
class="btn btn-info btn-sm">

<i class="fas fa-eye"></i>

</a>

<a
href="{{ route('meetings.edit',$meeting) }}"
class="btn btn-warning btn-sm">

<i class="fas fa-edit"></i>

</a>

<form
action="{{ route('meetings.destroy',$meeting) }}"
method="POST"
class="d-inline">

@csrf

@method('DELETE')

<button
onclick="return confirm('Hapus?')"
class="btn btn-danger btn-sm">

<i class="fas fa-trash"></i>

</button>

</form>

</td>

</tr>

@empty

<tr>

<td colspan="5">

Belum ada data.

</td>

</tr>

@endforelse

</tbody>

</table>

</div>

{{ $meetings->links() }}

</div>

</div>

</div>

@endsection