<div class="mb-3">

    <label>Nama Kelas</label>

    <input
        type="text"
        name="class_name"
        class="form-control"
        value="{{ old('class_name',$class->class_name ?? '') }}">

</div>

<div class="mb-3">

    <label>Mata Pelajaran</label>

    <input
        type="text"
        name="subject"
        class="form-control"
        value="{{ old('subject',$class->subject ?? '') }}">

</div>

<div class="mb-3">

    <label>Guru</label>

    <select
        name="teacher_id"
        class="form-control">

        <option value="">-- Pilih Guru --</option>

        @foreach($teachers as $teacher)

            <option
                value="{{ $teacher->id }}"
                @selected(old('teacher_id',$class->teacher_id ?? '')==$teacher->id)>

                {{ $teacher->name }}

            </option>

        @endforeach

    </select>

</div>

<div class="mb-3">

    <label>Deskripsi</label>

    <textarea
        name="description"
        class="form-control"
        rows="4">{{ old('description',$class->description ?? '') }}</textarea>

</div>