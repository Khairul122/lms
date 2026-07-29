@extends('adminlte::page')

@section('title', 'Dashboard EduSmart')

@section('content_header')
    <h1>
        <i class="fas fa-graduation-cap text-primary"></i>
        Dashboard EduSmart LMS
    </h1>
@stop

@section('content')

<div class="container-fluid">

    {{-- Statistik --}}
    <div class="row">

        <div class="col-lg-3 col-6">

            <div class="small-box bg-primary">

                <div class="inner">

                    <h3>{{ $guru }}</h3>

                    <p>Guru</p>

                </div>

                <div class="icon">

                    <i class="fas fa-chalkboard-teacher"></i>

                </div>

            </div>

        </div>

        <div class="col-lg-3 col-6">

            <div class="small-box bg-success">

                <div class="inner">

                    <h3>{{ $siswa }}</h3>

                    <p>Siswa</p>

                </div>

                <div class="icon">

                    <i class="fas fa-user-graduate"></i>

                </div>

            </div>

        </div>

        <div class="col-lg-3 col-6">

            <div class="small-box bg-warning">

                <div class="inner">

                    <h3>{{ $kelas }}</h3>

                    <p>Kelas</p>

                </div>

                <div class="icon">

                    <i class="fas fa-school"></i>

                </div>

            </div>

        </div>

        <div class="col-lg-3 col-6">

            <div class="small-box bg-danger">

                <div class="inner">

                    <h3>{{ $meeting }}</h3>

                    <p>Pertemuan</p>

                </div>

                <div class="icon">

                    <i class="fas fa-calendar-alt"></i>

                </div>

            </div>

        </div>

    </div>

    <div class="row">

        <div class="col-lg-3 col-6">

            <div class="small-box bg-info">

                <div class="inner">

                    <h3>{{ $materi }}</h3>

                    <p>Materi</p>

                </div>

                <div class="icon">

                    <i class="fas fa-book"></i>

                </div>

            </div>

        </div>

        <div class="col-lg-3 col-6">

            <div class="small-box bg-secondary">

                <div class="inner">

                    <h3>{{ $tugas }}</h3>

                    <p>Tugas</p>

                </div>

                <div class="icon">

                    <i class="fas fa-file-alt"></i>

                </div>

            </div>

        </div>

        <div class="col-lg-3 col-6">

            <div class="small-box bg-dark">

                <div class="inner">

                    <h3>{{ $submission }}</h3>

                    <p>Submission</p>

                </div>

                <div class="icon">

                    <i class="fas fa-upload"></i>

                </div>

            </div>

        </div>

    </div>

    {{-- Grafik --}}
    <div class="row">

        <div class="col-md-8">

            <div class="card">

                <div class="card-header bg-primary text-white">

                    <h3 class="card-title">

                        <i class="fas fa-chart-bar"></i>

                        Statistik EduSmart LMS

                    </h3>

                </div>

                <div class="card-body">

                    <canvas id="dashboardChart" height="120"></canvas>

                </div>

            </div>

        </div>

        <div class="col-md-4">

            <div class="card">

                <div class="card-header bg-success text-white">

                    <h3 class="card-title">

                        <i class="fas fa-users"></i>

                        User Terbaru

                    </h3>

                </div>

                <div class="card-body">

                    @forelse($users as $user)

                        <div class="d-flex justify-content-between">

                            <div>

                                <strong>{{ $user->name }}</strong>

                                <br>

                                <small class="text-muted">

                                    {{ $user->email }}

                                </small>

                            </div>

                            <span class="badge bg-primary">

                                {{ ucfirst($user->role) }}

                            </span>

                        </div>

                        <hr>

                    @empty

                        <p class="text-center">

                            Tidak ada user.

                        </p>

                    @endforelse

                </div>

            </div>

        </div>

    </div>

</div>

@stop

@section('js')

<script>

const ctx = document.getElementById('dashboardChart');

new Chart(ctx, {

    type: 'bar',

    data: {

        labels: [

            'Guru',

            'Siswa',

            'Kelas',

            'Meeting',

            'Materi',

            'Tugas',

            'Submission'

        ],

        datasets: [{

            label: 'Jumlah Data',

            data: [

                {{ $guru }},

                {{ $siswa }},

                {{ $kelas }},

                {{ $meeting }},

                {{ $materi }},

                {{ $tugas }},

                {{ $submission }}

            ],

            borderWidth: 1

        }]

    },

    options: {

        responsive: true,

        plugins: {

            legend: {

                display: true

            }

        },

        scales: {

            y: {

                beginAtZero: true

            }

        }

    }

});

</script>

@stop