<?php

namespace App\Services;

use App\Models\User;

/**
 * Single source of truth for role checks.
 *
 * Note: this app only ever writes to the `role` string column (see
 * AuthController::register / RegisteredUserController) — Spatie's
 * laravel-permission role/permission tables are installed but the
 * RoleSeeder/PermissionSeeder are empty stubs and no code path ever
 * calls assignRole(). Checking Spatie's hasRole() here would silently
 * fail for every existing user, so this service normalizes against the
 * `role` column instead of duplicating ad hoc string comparisons.
 */
class RoleService
{
    public function isAdmin(User $user): bool
    {
        return $this->is($user, 'admin');
    }

    public function isGuru(User $user): bool
    {
        return $this->is($user, 'guru') || $this->is($user, 'teacher');
    }

    public function isSiswa(User $user): bool
    {
        return $this->is($user, 'siswa') || $this->is($user, 'student');
    }

    public function currentRole(User $user): ?string
    {
        return $user->role;
    }

    protected function is(User $user, string $role): bool
    {
        return strtolower((string) $user->role) === strtolower($role);
    }
}
