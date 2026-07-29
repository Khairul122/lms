<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Discussion extends Model
{
    use HasFactory;

    protected $fillable = [
        'class_id',
        'user_id',
        'meeting_id', // 🔥 Tambahkan ini agar kolom meeting_id bisa diisi data
        'message',
    ];

    public function classroom()
    {
        return $this->belongsTo(ClassRoom::class, 'class_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /**
     * 🔥 TAMBAHKAN RELASI INI
     * Mengubungkan model Discussion dengan model Meeting
     */
    public function meeting()
    {
        return $this->belongsTo(Meeting::class, 'meeting_id');
    }
}