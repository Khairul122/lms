@extends('adminlte::page')

@section('title','Detail Tugas')

@section('content')

<div class="card">

<div class="card-header">

<h3>{{ $task->title }}</h3>

</div>

<div class="card-body">

<table class="table table-bordered">

<tr>
<th>Kelas</th>
<td>{{ $task->classroom->class_name }}</td>
</tr>

<tr>
<th>Pertemuan</th>
<td>Pertemuan {{ $task->meeting->pertemuan }}</td>
</tr>

<tr>
<th>Deskripsi</th>
<td>{{ $task->description }}</td>
</tr>

<tr>
<th>Deadline</th>
<td>{{ $task->deadline }}</td>
</tr>

<tr>
<th>Nilai Maksimum</th>
<td>{{ $task->max_score }}</td>
</tr>

<tr>
<th>Lampiran</th>
<td>

@if($task->attachment)

<a
href="{{ asset('storage/'.$task->attachment) }}"
target="_blank"
class="btn btn-primary btn-sm">

Download Lampiran

</a>

@else

-

@endif

</td>

</tr>

</table>

</div>

</div>

@endsection