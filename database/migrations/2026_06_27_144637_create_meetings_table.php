<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('meetings', function (Blueprint $table) {

            $table->id();

            $table->foreignId('class_id')
                ->constrained('class_rooms')
                ->cascadeOnDelete();

            $table->integer('pertemuan');

            $table->string('nama_pertemuan');

            $table->text('tema_pertemuan')->nullable();

            $table->timestamps();

            $table->unique(['class_id','pertemuan']);

        });
    }

    public function down(): void
    {
        Schema::dropIfExists('meetings');
    }
};