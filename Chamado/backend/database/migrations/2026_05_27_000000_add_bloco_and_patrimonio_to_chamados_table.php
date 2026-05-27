<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('chamados', function (Blueprint $table) {
            $table->string('bloco')->nullable()->after('local');
            $table->boolean('patrimonio_sim')->default(false)->after('prioridade');
            $table->string('numero_patrimonio')->nullable()->after('patrimonio_sim');
        });
    }

    public function down(): void
    {
        Schema::table('chamados', function (Blueprint $table) {
            $table->dropColumn(['bloco', 'patrimonio_sim', 'numero_patrimonio']);
        });
    }
};