<?php

namespace Database\Seeders;

use App\Models\User;
use App\Enums\RolesEnum;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::factory()->create([
            'email' => 'user@example.com',
        ])->assignRole(RolesEnum::USER->value);

        User::factory()->create([
            'email' => 'admin@example.com',
        ])->assignRole(RolesEnum::ADMIN->value);

        User::factory()->create([
            'email' => 'employee@example.com',
        ])->assignRole(RolesEnum::EMPLOYEE->value);
    }
}
