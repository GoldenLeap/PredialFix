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
        Schema::create('historico_chamados', function (Blueprint $table) {
            $table->id();
            $table->foreignId('chamado_id')->constrained('chamados')->onDelete('cascade');
            $table->string('status_anterior');
            $table->string('status_novo');
            $table->foreignId('alterado_por')->constrained('users')->onDelete('cascade');
            $table->timestamp('data_alteracao')->useCurrent();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('historico_chamados');
    }
};
