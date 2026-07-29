<?php

namespace App\Http\Controllers;

use App\Actions\User\CreateUserAction;
use App\Actions\User\DeleteUserAction;
use App\Actions\User\UpdateUserAction;
use App\Models\User;
use App\Http\Requests\User\StoreUserRequest;
use App\Http\Requests\User\UpdateUserRequest;
use App\Services\UserService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class UserController extends Controller
{
    public function __construct(protected UserService $userService)
    {
    }

    public function index(Request $request)
    {
        $users = $this->userService->paginateByKeyword($request->keyword);

        return view('users.index', compact('users'));
    }

    public function guru(Request $request)
    {
        $users = $this->userService->paginateByKeyword($request->keyword, 'guru');

        return view('guru.index', compact('users'));
    }

    public function siswa(Request $request)
    {
        $users = $this->userService->paginateByKeyword($request->keyword, 'siswa');

        return view('siswa.index', compact('users'));
    }

    public function create()
    {
        return view('users.create');
    }

    public function store(StoreUserRequest $request, CreateUserAction $action)
    {
        $photo = null;
        if ($request->hasFile('photo')) {
            $photo = $request->file('photo')->store('users', 'public');
        }

        $action->execute([
            'name'       => $request->name,
            'username'   => $request->username,
            'email'      => $request->email,
            'password'   => $request->password,
            'role'       => $request->role,
            'nisn'       => $request->nisn,
            'nip'        => $request->nip,
            'phone'      => $request->phone,
            'gender'     => $request->gender,
            'birth_date' => $request->birth_date,
            'photo'      => $photo,
        ]);

        return redirect()
            ->route('users.index')
            ->with('success', 'User berhasil ditambahkan');
    }

    public function show(User $user)
    {
        return view('users.show', compact('user'));
    }

    public function edit(User $user)
    {
        return view('users.edit', compact('user'));
    }

    public function update(UpdateUserRequest $request, User $user, UpdateUserAction $action)
    {
        $photo = null;
        if ($request->hasFile('photo')) {
            if ($user->photo) {
                Storage::disk('public')->delete($user->photo);
            }
            $photo = $request->file('photo')->store('users', 'public');
        }

        $action->execute($user, [
            'name'       => $request->name,
            'username'   => $request->username,
            'email'      => $request->email,
            'role'       => $request->role,
            'nisn'       => $request->nisn,
            'nip'        => $request->nip,
            'phone'      => $request->phone,
            'gender'     => $request->gender,
            'birth_date' => $request->birth_date,
            'photo'      => $photo,
            'password'   => $request->password,
        ]);

        return redirect()
            ->route('users.index')
            ->with('success', 'User berhasil diupdate');
    }

    public function destroy(User $user, DeleteUserAction $action)
    {
        $action->execute($user);

        return redirect()
            ->route('users.index')
            ->with('success', 'User berhasil dihapus');
    }
}
