<?php

namespace Database\Seeders;

use App\Enums\RolesEnum;
use App\Enums\PermissionsEnum;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

class RoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $adminRole = Role::create(['name' => RolesEnum::ADMIN->value]);
        $userRole = Role::create(['name' => RolesEnum::USER->value]);
        $employeeRole = Role::create(['name' => RolesEnum::EMPLOYEE->value]);

        $releasePurchasePermission = Permission::create(['name' => PermissionsEnum::ReleasePurchase->value]);
        // $affiliateWithdrawal = Permission::create(['name' => PermissionsEnum::AffiliateWithdrawal->value]);

        // $userRole->syncPermissions([]);
        // $affiliateRole->syncPermissions([$affiliateWithdrawal]);
        $adminRole->syncPermissions([$releasePurchasePermission]);
    }
    
}
