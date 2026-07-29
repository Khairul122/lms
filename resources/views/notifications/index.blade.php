@extends('adminlte::page')

@section('title','Notifikasi')

@section('content')

<div class="card">

<div class="card-header d-flex justify-content-between">

<h3>Notifikasi</h3>

<a
href="{{ route('notifications.create') }}"
class="btn btn-primary">

Tambah

</a>

</div>

<div class="card-body">

<table class="table table-bordered table-hover">

<thead>

<tr>

<th>No</th>

<th>User</th>

<th>Judul</th>

<th>Tipe</th>

<th>Status</th>

<th>Aksi</th>

</tr>

</thead>

<tbody>

@forelse($notifications as $notification)

<tr>

<td>{{ $loop->iteration }}</td>

<td>{{ $notification->user->name }}</td>

<td>{{ $notification->title }}</td>

<td>

<span class="badge bg-info">

{{ ucfirst($notification->type) }}

</span>

</td>

<td>

@if($notification->is_read)

<span class="badge bg-success">

Sudah Dibaca

</span>

@else

<span class="badge bg-warning">

Belum Dibaca

</span>

@endif

</td>

<td>

<a
href="{{ route('notifications.show',$notification) }}"
class="btn btn-info btn-sm">

Detail

</a>

<a
href="{{ route('notifications.edit',$notification) }}"
class="btn btn-warning btn-sm">

Edit

</a>

</td>

</tr>

@empty

<tr>

<td colspan="6">

Belum ada notifikasi.

</td>

</tr>

@endforelse

</tbody>

</table>

{{ $notifications->links() }}

</div>

</div>

@endsection