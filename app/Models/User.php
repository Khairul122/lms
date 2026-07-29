<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable, HasRoles;

    protected $fillable = [
        'name',
        'email',
        'password',

        'role',
        'nip',
        'nisn',
        'phone',

        'ttl',
        'jenis_kelamin',
        'mata_pelajaran',
        'sekolah_asal',
        'alamat',

        'photo',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'birth_date' => 'date',
        ];
    }

    // =====================
    // RELATIONSHIP
    // =====================

    public function classesTeaching()
    {
        return $this->hasMany(ClassRoom::class, 'teacher_id');
    }

    /**
     * 🔥 Relasi Ke Kelas yang Diikuti Siswa via Pivot Table (class_student)
     */
    public function joinedClasses()
    {
        return $this->belongsToMany(ClassRoom::class, 'class_student', 'user_id', 'class_room_id');
    }

    public function classMembers()
    {
        return $this->hasMany(ClassMember::class);
    }

    public function submissions()
    {
        return $this->hasMany(Submission::class, 'user_id');
    }

    public function notifications()
    {
        return $this->hasMany(Notification::class);
    }

    public function discussions()
    {
        return $this->hasMany(Discussion::class, 'user_id');
    }

    public function recentlyViewed()
    {
        return $this->hasMany(RecentlyViewed::class);
    }
}