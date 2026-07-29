<?php

namespace App\Http\Controllers;

use App\Actions\User\CreateUserAction;
use App\Actions\User\DeleteUserAction;
use App\Actions\User\UpdateUserAction;
use App\Models\User;
use App\Services\UserService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class GuruController extends Controller
{
    public function __construct(protected UserService $userService)
    {
    }

    public function index()
    {
        $gurus = $this->userService->paginateByKeyword(null, 'guru');

        return view('guru.index', compact('gurus'));
    }

    public function create()
    {
        return view('guru.create');
    }

    public function store(Request $request, CreateUserAction $action)
    {
        $request->validate([
            'name'       => 'required|max:150',
            'username'   => 'required|unique:users',
            'email'      => 'required|email|unique:users',
            'password'   => 'required|min:6',
            'nip'        => 'required',
            'phone'      => 'nullable',
            'gender'     => 'nullable',
            'birth_date' => 'nullable',
            'photo'      => 'nullable|image|max:2048',
        ]);

        $photo = null;
        if ($request->hasFile('photo')) {
            $photo = $request->file('photo')->store('guru', 'public');
        }

        $action->execute([
            'name'               => $request->name,
            'username'           => $request->username,
            'email'              => $request->email,
            'password'           => $request->password,
            'role'               => 'guru',
            'nip'                => $request->nip,
            'phone'              => $request->phone,
            'gender'             => $request->gender,
            'birth_date'         => $request->birth_date,
            'photo'              => $photo,
            'assign_spatie_role' => true,
        ]);

        return redirect()
            ->route('guru.index')
            ->with('success', 'Guru berhasil ditambahkan.');
    }

    public function show(User $guru)
    {
        return view('guru.show', compact('guru'));
    }

    public function edit(User $guru)
    {
        return view('guru.edit', compact('guru'));
    }

    public function update(Request $request, User $guru, UpdateUserAction $action)
    {
        $request->validate([
            'name'     => 'required|max:150',
            'username' => 'required|unique:users,username,' . $guru->id,
            'email'    => 'required|email|unique:users,email,' . $guru->id,
            'nip'      => 'required',
        ]);

        $photo = null;
        if ($request->hasFile('photo')) {
            if ($guru->photo) {
                Storage::disk('public')->delete($guru->photo);
            }
            $photo = $request->file('photo')->store('guru', 'public');
        }

        $action->execute($guru, [
            'name'       => $request->name,
            'username'   => $request->username,
            'email'      => $request->email,
            'nip'        => $request->nip,
            'phone'      => $request->phone,
            'gender'     => $request->gender,
            'birth_date' => $request->birth_date,
            'photo'      => $photo,
            'password'   => $request->password,
        ]);

        return redirect()
            ->route('guru.index')
            ->with('success', 'Data guru berhasil diupdate.');
    }

    public function destroy(User $guru, DeleteUserAction $action)
    {
        $action->execute($guru);

        return back()->with('success', 'Guru berhasil dihapus.');
    }
}
