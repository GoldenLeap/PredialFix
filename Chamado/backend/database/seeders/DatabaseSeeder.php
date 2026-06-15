<?php

namespace Database\Seeders;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        User::factory()->create([
            'name' => 'Test User',
            'email' => 'taeste@example.com',
            'password' => bcrypt('password'),
        ]);

        User::factory()->create([
            'name' => 'Admin User',
            'email' => 'resp@resp.com',
            'password' => Hash::make("senha"),
            'cargo' => 'responsavel']);
        User::factory()->create([
            "name" => "Macaquilson da Silvon Pererelson Mendelson Souzelson",
            "email" => 'macaquilson@example.com',
            "password" => Hash::make("senha"),
            "cargo" => 'solicitante'
        ]);
    }
}
