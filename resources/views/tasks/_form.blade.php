<div class="row">

    <div class="col-md-6">

        <div class="form-group">
            <label>Kelas</label>

            <select name="class_id" class="form-control" required>

                <option value="">-- Pilih Kelas --</option>

                @foreach($classes as $class)

                    <option
                        value="{{ $class->id }}"
                        @selected(old('class_id',$task->class_id ?? '')==$class->id)>

                        {{ $class->class_name }}

                    </option>

                @endforeach

            </select>

        </div>

    </div>

    <div class="col-md-6">

        <div class="form-group">

            <label>Pertemuan</label>

            <select name="meeting_id" class="form-control" required>

                <option value="">-- Pilih Pertemuan --</option>

                @foreach($meetings as $meeting)

                    <option
                        value="{{ $meeting->id }}"
                        @selected(old('meeting_id',$task->meeting_id ?? '')==$meeting->id)>

                        Pertemuan {{ $meeting->pertemuan }}

                    </option>

                @endforeach

            </select>

        </div>

    </div>

</div>

<div class="form-group">

    <label>Judul Tugas</label>

    <input
        type="text"
        name="title"
        class="form-control"
        value="{{ old('title',$task->title ?? '') }}"
        required>

</div>

<div class="form-group">

    <label>Deskripsi</label>

    <textarea
        name="description"
        rows="5"
        class="form-control">{{ old('description',$task->description ?? '') }}</textarea>

</div>

<div class="row">

    <div class="col-md-6">

        <div class="form-group">

            <label>Deadline</label>

            <input
                type="datetime-local"
                name="deadline"
                class="form-control"
                value="{{ old('deadline',isset($task) ? \Carbon\Carbon::parse($task->deadline)->format('Y-m-d\TH:i') : '') }}"
                required>

        </div>

    </div>

    <div class="col-md-6">

        <div class="form-group">

            <label>Nilai Maksimum</label>

            <input
                type="number"
                name="max_score"
                class="form-control"
                value="{{ old('max_score',$task->max_score ?? 100) }}"
                required>

        </div>

    </div>

</div>

<div class="form-group">

    <label>Lampiran</label>

    <input
        type="file"
        name="attachment"
        class="form-control">

</div>

@if(isset($task))

<div class="form-group">

    <label>Status</label>

    <select name="is_active" class="form-control">

        <option value="1" @selected($task->is_active)>
            Aktif
        </option>

        <option value="0" @selected(!$task->is_active)>
            Nonaktif
        </option>

    </select>

</div>

@endif
