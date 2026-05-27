<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('chamados', function (Blueprint $table) {
            $table->unsignedBigInteger('tecnico_id')->nullable()->after('usuario_id');
            $table->decimal('custo_mao_obra', 10, 2)->nullable()->after('observacao');
            $table->decimal('custo_materiais', 10, 2)->nullable()->after('custo_mao_obra');

            $table->foreign('tecnico_id')->references('id')->on('users')->onDelete('set null');
        });
    }

    public function down(): void
    {
        Schema::table('chamados', function (Blueprint $table) {
            $table->dropForeign(['tecnico_id']);
            $table->dropColumn(['tecnico_id', 'custo_mao_obra', 'custo_materiais']);
        });
    }
};
