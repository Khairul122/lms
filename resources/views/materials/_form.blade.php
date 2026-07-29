<div class="row">

    <div class="col-md-6">

        <div class="form-group">

            <label>Kelas</label>

            <select
                name="class_id"
                class="form-control"
                required>

                <option value="">-- Pilih Kelas --</option>

                @foreach($classes as $class)

                <option
                    value="{{ $class->id }}"
                    @selected(old('class_id',$material->class_id ?? '')==$class->id)>

                    {{ $class->class_name }}

                </option>

                @endforeach

            </select>

        </div>

    </div>

    <div class="col-md-6">

        <div class="form-group">

            <label>Pertemuan</label>

            <select
                name="meeting_id"
                class="form-control"
                required>

                <option value="">-- Pilih Pertemuan --</option>

                @foreach($meetings as $meeting)

                <option
                    value="{{ $meeting->id }}"
                    @selected(old('meeting_id',$material->meeting_id ?? '')==$meeting->id)>

                    Pertemuan {{ $meeting->pertemuan }}
                    -
                    {{ $meeting->nama_pertemuan }}

                </option>

                @endforeach

            </select>

        </div>

    </div>

</div>

<div class="form-group">

    <label>Judul Materi</label>

    <input
        type="text"
        name="title"
        class="form-control"
        value="{{ old('title',$material->title ?? '') }}"
        required>

</div>

<div class="form-group">

    <label>Deskripsi</label>

    <textarea
        name="description"
        rows="5"
        class="form-control">{{ old('description',$material->description ?? '') }}</textarea>

</div>

<div class="form-group">

    <label>Upload File</label>

    <input
        type="file"
        name="file"
        class="form-control">

</div>

<div class="form-group">

    <label>Link Youtube</label>

    <input
        type="url"
        name="youtube_url"
        class="form-control"
        value="{{ old('youtube_url',$material->youtube_url ?? '') }}">

</div>