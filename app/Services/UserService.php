<?php

namespace App\Services;

use App\Models\User;

class UserService
{
    public function paginateByKeyword(?string $keyword, ?string $role = null, int $perPage = 10)
    {
        return User::when($role, fn ($query) => $query->where('role', $role))
            ->when($keyword, function ($query) use ($keyword) {
                $query->where(function ($q) use ($keyword) {
                    $q->where('name', 'like', "%{$keyword}%")
                      ->orWhere('email', 'like', "%{$keyword}%")
                      ->orWhere('username', 'like', "%{$keyword}%");
                });
            })
            ->latest()
            ->paginate($perPage);
    }
}
