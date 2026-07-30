@extends('adminlte::page')

@section('title', 'Edit Guru')

@section('content')
<div class="container-fluid px-0">
    <div class="card border-0 shadow-sm" style="border-radius: 16px; border: 1px solid #E2E8F0; overflow: hidden;">
        <form action="{{ route('guru.update', $guru->id) }}" method="POST" enctype="multipart/form-data">
            @csrf
            @method('PUT')

            <div class="card-header bg-white py-3 px-4" style="border-bottom: 1px solid #F1F5F9;">
                <h5 class="fw-bold mb-0 text-dark d-flex align-items-center">
                    <i class="fas fa-user-edit me-2" style="color: #4F46E5;"></i> Edit Data Guru: {{ $guru->name }}
                </h5>
            </div>

            <div class="card-body p-4">
                @if ($errors->any())
                    <div class="alert alert-danger border-0 rounded-3 mb-4" style="background: #FEF2F2; color: #991B1B;">
                        <ul class="mb-0 ps-3">
                            @foreach ($errors->all() as $error)
                                <li>{{ $error }}</li>
                            @endforeach
                        </ul>
                    </div>
                @endif

                @include('guru._form')
            </div>

            <div class="card-footer bg-white py-3 px-4 d-flex justify-content-between align-items-center" style="border-top: 1px solid #F1F5F9;">
                <a href="{{ route('guru.index') }}" class="btn btn-light border text-secondary px-4 py-2" style="border-radius: 8px; font-weight: 500;">
                    <i class="fas fa-arrow-left me-1"></i> Kembali
                </a>
                <button type="submit" class="btn text-white px-4 py-2" style="background: #4F46E5; border-radius: 8px; font-weight: 600;">
                    <i class="fas fa-save me-1"></i> Simpan Perubahan
                </button>
            </div>
        </form>
    </div>
</div>
@endsection
