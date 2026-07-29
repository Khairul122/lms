<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;

class GuruController extends Controller
{
    public function index()
    {
        $gurus = User::where('role', 'guru')
            ->latest()
            ->paginate(10);

        return view('guru.index', compact('gurus'));
    }

    public function create()
    {
        return view('guru.create');
    }

    public function store(Request $request)
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

        $guru = User::create([
            'name'       => $request->name,
            'username'   => $request->username,
            'email'      => $request->email,
            'password'   => Hash::make($request->password),
            'role'       => 'guru',
            'nip'        => $request->nip,
            'phone'      => $request->phone,
            'gender'     => $request->gender,
            'birth_date' => $request->birth_date,
            'photo'      => $photo,
        ]);

        if (method_exists($guru, 'assignRole')) {
            $guru->assignRole('guru');
        }

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

    public function update(Request $request, User $guru)
    {
        $request->validate([
            'name'     => 'required|max:150',
            'username' => 'required|unique:users,username,' . $guru->id,
            'email'    => 'required|email|unique:users,email,' . $guru->id,
            'nip'      => 'required',
        ]);

        if ($request->hasFile('photo')) {

            if ($guru->photo) {
                Storage::disk('public')->delete($guru->photo);
            }

            $guru->photo = $request->file('photo')
                ->store('guru', 'public');
        }

        $guru->name       = $request->name;
        $guru->username   = $request->username;
        $guru->email      = $request->email;
        $guru->nip        = $request->nip;
        $guru->phone      = $request->phone;
        $guru->gender     = $request->gender;
        $guru->birth_date = $request->birth_date;

        if ($request->filled('password')) {
            $guru->password = Hash::make($request->password);
        }

        $guru->save();

        return redirect()
            ->route('guru.index')
            ->with('success', 'Data guru berhasil diupdate.');
    }

    public function destroy(User $guru)
    {
        if ($guru->photo) {
            Storage::disk('public')->delete($guru->photo);
        }

        $guru->delete();

        return back()->with('success', 'Guru berhasil dihapus.');
    }
}