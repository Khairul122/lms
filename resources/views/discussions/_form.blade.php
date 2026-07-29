<div class="form-group">
    <label>Kelas</label>

    <select name="class_id" class="form-control">

        @foreach($classes as $class)

        <option value="{{ $class->id }}">

            {{ $class->class_name }}

        </option>

        @endforeach

    </select>
</div>

<div class="form-group">

<label>Pertemuan</label>

<select name="meeting_id" class="form-control">

@foreach($meetings as $meeting)

<option value="{{ $meeting->id }}">

Pertemuan {{ $meeting->pertemuan }}

</option>

@endforeach

</select>

</div>

<div class="form-group">

<label>Pesan</label>

<textarea
name="message"
rows="6"
class="form-control"></textarea>

</div>