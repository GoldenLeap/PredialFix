<?php

use Illuminate\Support\Facades\Route;
use Laravel\Fortify\Features;
use Inertia\Inertia;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\Settings\ProfileController;
use App\Http\Controllers\Settings\PasswordController;

Route::inertia('/', 'Home', [
    'canRegister' => Features::enabled(Features::registration()),
])->name('home');

Route::get('/dashboard', DashboardController::class)->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware(['auth', 'verified'])->group(function () {
    Route::resource('chamados', App\Http\Controllers\ChamadoController::class);
});


require __DIR__.'/settings.php';
