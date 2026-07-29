<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Meeting extends Model
{
    use HasFactory;

    protected $fillable = [
        'class_id',
        'pertemuan',
        'nama_pertemuan',
        'tema_pertemuan',
    ];

    public function classroom()
    {
        return $this->belongsTo(ClassRoom::class, 'class_id');
    }

    public function materials()
    {
        return $this->hasMany(Material::class, 'meeting_id');
    }

    public function tasks()
    {
        return $this->hasMany(Task::class, 'meeting_id');
    }
    
}