@extends('adminlte::page')

@section('title','Data Siswa')

@section('content')

<div class="card">

    <div class="card-header">

        <h3 class="card-title">

            <i class="fas fa-user-graduate"></i>

            Data Siswa

        </h3>

    </div>

    <div class="card-body">

        <form method="GET">

            <div class="row mb-3">

                <div class="col-md-4">

                    <input
                        type="text"
                        name="keyword"
                        class="form-control"
                        placeholder="Cari siswa..."
                        value="{{ request('keyword') }}">

                </div>

                <div class="col-md-2">

                    <button class="btn btn-primary">

                        Cari

                    </button>

                </div>

            </div>

        </form>

        <table class="table table-bordered table-hover">

            <thead class="table-dark">

                <tr>

                    <th width="70">No</th>

                    <th>Foto</th>

                    <th>Nama</th>

                    <th>Email</th>

                    <th>NISN</th>

                    <th>Telepon</th>

                </tr>

            </thead>

            <tbody>

            @forelse($users as $user)

                <tr>

                    <td>{{ $loop->iteration }}</td>

                    <td width="80">

                        @if($user->photo)

                            <img
                                src="{{ asset('storage/'.$user->photo) }}"
                                width="50"
                                class="img-circle">

                        @else

                            <img
                                src="https://ui-avatars.com/api/?name={{ urlencode($user->name) }}"
                                width="50"
                                class="img-circle">

                        @endif

                    </td>

                    <td>{{ $user->name }}</td>

                    <td>{{ $user->email }}</td>

                    <td>{{ $user->nisn }}</td>

                    <td>{{ $user->phone }}</td>

                </tr>

            @empty

                <tr>

                    <td colspan="6" class="text-center">

                        Belum ada data siswa.

                    </td>

                </tr>

            @endforelse

            </tbody>

        </table>

        <div class="mt-3">

            {{ $users->links() }}

        </div>

    </div>

</div>

@endsection