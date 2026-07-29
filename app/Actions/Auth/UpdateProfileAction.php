<?php

namespace App\Actions\Auth;

use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

class UpdateProfileAction
{
    public function execute(User $user, array $data): User
    {
        $updateData = [];

        if (array_key_exists('name', $data) && $data['name'] !== null) $updateData['name'] = $data['name'];
        if (array_key_exists('phone', $data)) $updateData['phone'] = $data['phone'];
        if (array_key_exists('nip', $data)) $updateData['nip'] = $data['nip'];
        if (array_key_exists('ttl', $data)) $updateData['ttl'] = $data['ttl'];
        if (array_key_exists('jenis_kelamin', $data)) $updateData['jenis_kelamin'] = $data['jenis_kelamin'];
        if (array_key_exists('mata_pelajaran', $data)) $updateData['mata_pelajaran'] = $data['mata_pelajaran'];
        if (array_key_exists('sekolah_asal', $data)) $updateData['sekolah_asal'] = $data['sekolah_asal'];
        if (array_key_exists('alamat', $data)) $updateData['alamat'] = $data['alamat'];

        if (array_key_exists('photo', $data) && !empty($data['photo'])) {
            $photo = $data['photo'];

            if ($photo instanceof UploadedFile) {
                $filename = 'photo_' . $user->id . '_' . time() . '.' . $photo->getClientOriginalExtension();
                $photo->storeAs('photos', $filename, 'public');
                $updateData['photo'] = 'storage/photos/' . $filename;
            } elseif (is_string($photo) && preg_match('/^data:image\/(\w+);base64,/', $photo, $type)) {
                $base64Data = substr($photo, strpos($photo, ',') + 1);
                $ext = strtolower($type[1]);
                if ($ext === 'jpeg') $ext = 'jpg';

                $decoded = base64_decode($base64Data);
                if ($decoded !== false) {
                    $filename = 'photo_' . $user->id . '_' . time() . '.' . $ext;
                    Storage::disk('public')->put('photos/' . $filename, $decoded);
                    $updateData['photo'] = 'storage/photos/' . $filename;
                }
            } elseif (is_string($photo)) {
                $updateData['photo'] = $photo;
            }
        }

        if (!empty($updateData)) {
            $user->update($updateData);
        }

        return $user->fresh();
    }
}
