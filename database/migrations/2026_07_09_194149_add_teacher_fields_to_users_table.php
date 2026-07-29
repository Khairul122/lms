<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // Menambahkan kolom pelengkap profil guru sesuai AuthController
            if (!Schema::hasColumn('users', 'ttl')) {
                $table->string('ttl')->nullable()->after('phone');
            }
            if (!Schema::hasColumn('users', 'jenis_kelamin')) {
                $table->string('jenis_kelamin')->nullable()->after('ttl');
            }
            if (!Schema::hasColumn('users', 'mata_pelajaran')) {
                $table->string('mata_pelajaran')->nullable()->after('jenis_kelamin');
            }
            if (!Schema::hasColumn('users', 'sekolah_asal')) {
                $table->string('sekolah_asal')->nullable()->after('mata_pelajaran');
            }
            if (!Schema::hasColumn('users', 'alamat')) {
                $table->text('alamat')->nullable()->after('sekolah_asal');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // Menghapus kembali kolom jika migration di-rollback
            $table->dropColumn(['ttl', 'jenis_kelamin', 'mata_pelajaran', 'sekolah_asal', 'alamat']);
        });
    }
};