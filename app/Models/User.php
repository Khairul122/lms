<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Spatie\Permission\Traits\HasRoles;
use Tymon\JWTAuth\Contracts\JWTSubject;

class User extends Authenticatable implements JWTSubject
{
    use HasFactory, Notifiable, HasRoles;

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

    protected $appends = [
        'photo_url',
    ];

    public function getPhotoUrlAttribute(): ?string
    {
        if (!$this->photo) {
            return null;
        }

        if (str_starts_with($this->photo, 'http://') || str_starts_with($this->photo, 'https://') || str_starts_with($this->photo, 'data:image')) {
            return $this->photo;
        }

        try {
            return request()->schemeAndHttpHost() . '/' . ltrim($this->photo, '/');
        } catch (\Throwable $e) {
            return asset(ltrim($this->photo, '/'));
        }
    }

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

    // =====================
    // JWT (Tymon\JWTAuth\Contracts\JWTSubject)
    // =====================

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims()
    {
        return [];
    }
}