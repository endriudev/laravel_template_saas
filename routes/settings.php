<?php

use App\Http\Controllers\Settings\DeleteProfileController;
use App\Http\Controllers\Settings\EditPasswordController;
use App\Http\Controllers\Settings\EditProfileController;
use App\Http\Controllers\Settings\ShowTwoFactorAuthenticationController;
use App\Http\Controllers\Settings\UpdatePasswordController;
use App\Http\Controllers\Settings\UpdateProfileController;
use Illuminate\Support\Facades\Route;

Route::middleware(['auth'])->group(function () {
    Route::redirect('settings', '/settings/profile');

    Route::get('settings/profile', EditProfileController::class)->name('profile.edit');
    Route::patch('settings/profile', UpdateProfileController::class)->name('profile.update');
});

Route::middleware(['auth', 'verified'])->group(function () {
    Route::delete('settings/profile', DeleteProfileController::class)->name('profile.destroy');

    Route::get('settings/password', EditPasswordController::class)->name('user-password.edit');

    Route::put('settings/password', UpdatePasswordController::class)
        ->middleware('throttle:6,1')
        ->name('user-password.update');

    Route::inertia('settings/appearance', 'settings/appearance')->name('appearance.edit');

    Route::get('settings/two-factor', ShowTwoFactorAuthenticationController::class)
        ->name('two-factor.show');
});
