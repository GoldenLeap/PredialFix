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
        Schema::create('chamados', function (Blueprint $table) {
            $table->id();
            $table->foreignId('usuario_id')->constrained('users')->onDelete('cascade');
            $table->enum('tipo', ['Elétrica', 'Hidráulica', 'Infraestrutura', 'Outros']);
            $table->string('local');
            $table->text('descricao');
            $table->enum('prioridade', ['Baixa', 'Média', 'Alta']);
            $table->enum('status', ['Aberto', 'Em Análise', 'Em Execução', 'Concluído'])->default('Aberto');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('chamados');
    }
};
