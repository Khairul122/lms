<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Http\Requests\UserRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;

class UserController extends Controller
{
    /**
     * Data Semua User
     */
    public function index(Request $request)
    {
        $keyword = $request->keyword;

        $users = User::when($keyword, function ($query) use ($keyword) {
                $query->where(function ($q) use ($keyword) {
                    $q->where('name', 'like', "%{$keyword}%")
                      ->orWhere('email', 'like', "%{$keyword}%")
                      ->orWhere('username', 'like', "%{$keyword}%");
                });
            })
            ->latest()
            ->paginate(10);

        return view('users.index', compact('users'));
    }

    /**
     * Data Guru
     */
    public function guru(Request $request)
    {
        $keyword = $request->keyword;

        $users = User::where('role', 'guru')
            ->when($keyword, function ($query) use ($keyword) {
                $query->where(function ($q) use ($keyword) {
                    $q->where('name', 'like', "%{$keyword}%")
                      ->orWhere('email', 'like', "%{$keyword}%")
                      ->orWhere('username', 'like', "%{$keyword}%");
                });
            })
            ->latest()
            ->paginate(10);

        return view('guru.index', compact('users'));
    }

    /**
     * Data Siswa
     */
    public function siswa(Request $request)
    {
        $keyword = $request->keyword;

        $users = User::where('role', 'siswa')
            ->when($keyword, function ($query) use ($keyword) {
                $query->where(function ($q) use ($keyword) {
                    $q->where('name', 'like', "%{$keyword}%")
                      ->orWhere('email', 'like', "%{$keyword}%")
                      ->orWhere('username', 'like', "%{$keyword}%");
                });
            })
            ->latest()
            ->paginate(10);

        return view('siswa.index', compact('users'));
    }

    /**
     * Form Tambah User
     */
    public function create()
    {
        return view('users.create');
    }

    /**
     * Simpan User
     */
    public function store(UserRequest $request)
    {
        $request->validate([
            'name'      => 'required|max:150',
            'username'  => 'nullable|unique:users',
            'email'     => 'required|email|unique:users',
            'password'  => 'required|min:6',
            'role'      => 'required',
            'photo'     => 'nullable|image|max:2048',
        ]);

        $photo = null;

        if ($request->hasFile('photo')) {
            $photo = $request->file('photo')->store('users', 'public');
        }

        User::create([
            'name'       => $request->name,
            'username'   => $request->username,
            'email'      => $request->email,
            'password'   => Hash::make($request->password),
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

    /**
     * Detail User
     */
    public function show(User $user)
    {
        return view('users.show', compact('user'));
    }

    /**
     * Form Edit User
     */
    public function edit(User $user)
    {
        return view('users.edit', compact('user'));
    }

    /**
     * Update User
     */
    public function update(UserRequest $request, User $user)
    {
        if ($request->hasFile('photo')) {

            if ($user->photo) {
                Storage::disk('public')->delete($user->photo);
            }

            $user->photo = $request->file('photo')->store('users', 'public');
        }

        $user->name       = $request->name;
        $user->username   = $request->username;
        $user->email      = $request->email;
        $user->role       = $request->role;
        $user->nisn       = $request->nisn;
        $user->nip        = $request->nip;
        $user->phone      = $request->phone;
        $user->gender     = $request->gender;
        $user->birth_date = $request->birth_date;

        if ($request->filled('password')) {
            $user->password = Hash::make($request->password);
        }

        $user->save();

        return redirect()
            ->route('users.index')
            ->with('success', 'User berhasil diupdate');
    }

    /**
     * Hapus User
     */
    public function destroy(User $user)
    {
        if ($user->photo) {
            Storage::disk('public')->delete($user->photo);
        }

        $user->delete();

        return redirect()
            ->route('users.index')
            ->with('success', 'User berhasil dihapus');
    }
}