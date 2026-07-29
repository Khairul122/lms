<div class="form-group">
    <label>User</label>

    <select name="user_id" class="form-control">

        @foreach($users as $user)

            <option value="{{ $user->id }}"
                @selected(old('user_id',$notification->user_id ?? '')==$user->id)>

                {{ $user->name }}

            </option>

        @endforeach

    </select>

</div>

<div class="form-group">

<label>Judul</label>

<input
type="text"
name="title"
class="form-control"
value="{{ old('title',$notification->title ?? '') }}">

</div>

<div class="form-group">

<label>Pesan</label>

<textarea
name="message"
rows="5"
class="form-control">{{ old('message',$notification->message ?? '') }}</textarea>

</div>

<div class="form-group">

<label>Tipe</label>

<select name="type" class="form-control">

<option value="info">Info</option>

<option value="success">Success</option>

<option value="warning">Warning</option>

<option value="danger">Danger</option>

</select>

</div>

@if(isset($notification))

<div class="form-group">

<label>Status</label>

<select name="is_read" class="form-control">

<option value="0">Belum Dibaca</option>

<option value="1">Sudah Dibaca</option>

</select>

</div>

@endif