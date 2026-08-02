<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Attendance extends Model
{
    use HasFactory;

    protected $fillable = [
        'meeting_id',
        'user_id',
        'status',
        'note',
    ];

    public function meeting()
    {
        return $this->belongsTo(Meeting::class);
    }

    public function student()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
