<div class="form-group">

    <label>Tugas</label>

    <select
        name="task_id"
        class="form-control"
        required>

        <option value="">-- Pilih Tugas --</option>

        @foreach($tasks as $task)

        <option
            value="{{ $task->id }}"
            @selected(old('task_id',$submission->task_id ?? '')==$task->id)>

            {{ $task->title }}

        </option>

        @endforeach

    </select>

</div>

<div class="form-group">

    <label>Upload Jawaban</label>

    <input
        type="file"
        name="file"
        class="form-control">

</div>

<div class="form-group">

    <label>Catatan</label>

    <textarea
        name="note"
        class="form-control"
        rows="4">{{ old('note',$submission->note ?? '') }}</textarea>

</div>