<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ClassRoom extends Model
{
    use HasFactory;

    protected $table = 'class_rooms';

    protected $fillable = [
        'class_code',
        'class_name',
        'subject',
        'teacher_id',
        'description',
        'is_active',
    ];

    public function teacher()
    {
        return $this->belongsTo(User::class, 'teacher_id');
    }

    /**
     * 🔥 Relasi ke Murid via Pivot Table (class_student)
     */
    public function students()
    {
        return $this->belongsToMany(User::class, 'class_student', 'class_room_id', 'user_id');
    }

    public function meetings()
    {
        return $this->hasMany(Meeting::class, 'class_id');
    }

    public function materials()
    {
        return $this->hasMany(Material::class, 'class_id');
    }

    public function tasks()
    {
        return $this->hasMany(Task::class, 'class_id');
    }

    public function members()
    {
        return $this->hasMany(ClassMember::class, 'class_id');
    }
}