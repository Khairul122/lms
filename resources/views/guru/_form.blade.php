<div class="row">

    <div class="col-md-6">

        <div class="form-group">

            <label>Nama Guru</label>

            <input
                type="text"
                name="name"
                class="form-control"
                value="{{ old('name',$guru->name ?? '') }}"
                required>

        </div>

    </div>

    <div class="col-md-6">

        <div class="form-group">

            <label>Username</label>

            <input
                type="text"
                name="username"
                class="form-control"
                value="{{ old('username',$guru->username ?? '') }}"
                required>

        </div>

    </div>

</div>

<div class="row">

    <div class="col-md-6">

        <div class="form-group">

            <label>Email</label>

            <input
                type="email"
                name="email"
                class="form-control"
                value="{{ old('email',$guru->email ?? '') }}"
                required>

        </div>

    </div>

    <div class="col-md-6">

        <div class="form-group">

            <label>Password</label>

            <input
                type="password"
                name="password"
                class="form-control">

        </div>

    </div>

</div>

<div class="row">

    <div class="col-md-6">

        <div class="form-group">

            <label>NIP</label>

            <input
                type="text"
                name="nip"
                class="form-control"
                value="{{ old('nip',$guru->nip ?? '') }}">

        </div>

    </div>

    <div class="col-md-6">

        <div class="form-group">

            <label>Nomor HP</label>

            <input
                type="text"
                name="phone"
                class="form-control"
                value="{{ old('phone',$guru->phone ?? '') }}">

        </div>

    </div>

</div>

<div class="form-group">

    <label>Foto</label>

    <input
        type="file"
        name="photo"
        class="form-control">

</div>