<div class="mb-3">

<label>Kelas</label>

<select
name="class_id"
class="form-control">

@foreach($classes as $class)

<option
value="{{ $class->id }}"
@selected(old('class_id',$meeting->class_id ?? '')==$class->id)>

{{ $class->class_name }}

</option>

@endforeach

</select>

</div>

<div class="mb-3">

<label>Pertemuan</label>

<input
type="number"
name="pertemuan"
class="form-control"
value="{{ old('pertemuan',$meeting->pertemuan ?? '') }}">

</div>

<div class="mb-3">

<label>Nama Pertemuan</label>

<input
type="text"
name="nama_pertemuan"
class="form-control"
value="{{ old('nama_pertemuan',$meeting->nama_pertemuan ?? '') }}">

</div>

<div class="mb-3">

<label>Tema</label>

<textarea
name="tema_pertemuan"
class="form-control"
rows="4">{{ old('tema_pertemuan',$meeting->tema_pertemuan ?? '') }}</textarea>

</div>