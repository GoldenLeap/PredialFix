<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class AdminUserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        \App\Models\User::updateOrCreate(
            ['email' => 'admin@predialfix.com'],
            [
                'name' => 'Administrador',
                'password' => \Illuminate\Support\Facades\Hash::make('admin123'),
                'cargo' => 'responsavel',
            ]
        );

        \App\Models\User::updateOrCreate(
            ['email' => 'solicitante@predialfix.com'],
            [
                'name' => 'Solicitante',
                'password' => \Illuminate\Support\Facades\Hash::make('admin123'),
                'cargo' => 'solicitante',
            ]
        );
    }
}
