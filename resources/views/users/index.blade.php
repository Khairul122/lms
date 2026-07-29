@extends('adminlte::page')

@section('title', 'Manajemen User')

@section('content')

<div class="card">

    <div class="card-header d-flex justify-content-between">

        <h4>Data User</h4>

        <a href="{{ route('users.create') }}"
           class="btn btn-primary">

            <i class="fas fa-plus"></i>

            Tambah User

        </a>

    </div>

    <div class="card-body">

        <form method="GET">

            <div class="input-group mb-3">

                <input
                    type="text"
                    name="keyword"
                    class="form-control"
                    placeholder="Cari user..."
                    value="{{ request('keyword') }}">

                <button class="btn btn-primary">

                    Cari

                </button>

            </div>

        </form>

        <table class="table table-bordered table-hover">

            <thead>

            <tr>

                <th width="60">Foto</th>

                <th>Nama</th>

                <th>Email</th>

                <th>Role</th>

                <th width="180">Aksi</th>

            </tr>

            </thead>

            <tbody>

            @forelse($users as $user)

            <tr>

                <td>

                    @if($user->photo)

                        <img
                            src="{{ asset('storage/'.$user->photo) }}"
                            width="45"
                            class="rounded-circle">

                    @else

                        -

                    @endif

                </td>

                <td>{{ $user->name }}</td>

                <td>{{ $user->email }}</td>

                <td>

                    <span class="badge bg-success">

                        {{ ucfirst($user->role) }}

                    </span>

                </td>

                <td>

                    <a
                        href="{{ route('users.show',$user) }}"
                        class="btn btn-info btn-sm">

                        Detail

                    </a>

                    <a
                        href="{{ route('users.edit',$user) }}"
                        class="btn btn-warning btn-sm">

                        Edit

                    </a>

                    <form
                        action="{{ route('users.destroy',$user) }}"
                        method="POST"
                        style="display:inline">

                        @csrf

                        @method('DELETE')

                        <button
                            onclick="return confirm('Hapus user?')"
                            class="btn btn-danger btn-sm">

                            Hapus

                        </button>

                    </form>

                </td>

            </tr>

            @empty

            <tr>

                <td colspan="5">

                    Tidak ada data.

                </td>

            </tr>

            @endforelse

            </tbody>

        </table>

        {{ $users->links() }}

    </div>

</div>

@endsection