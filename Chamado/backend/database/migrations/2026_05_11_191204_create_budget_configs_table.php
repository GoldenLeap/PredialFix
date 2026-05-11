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
        Schema::create('budget_configs', function (Blueprint $table) {
            $table->id();
            $table->integer('month');
            $table->integer('year');
            $table->decimal('total_budget', 15, 2);
            $table->json('allocations')->nullable(); // e.g., {"Encanação": 0.3, "Pintura": 0.2}
            $table->boolean('alert_enabled')->default(true);
            $table->timestamps();
            
            $table->unique(['month', 'year']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('budget_configs');
    }
};
