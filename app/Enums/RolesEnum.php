<?php

namespace App\Enums;

use Filament\Support\Contracts\HasColor;
use Filament\Support\Contracts\HasLabel;

enum RolesEnum: string implements HasLabel, HasColor
{
    case ADMIN = 'admin';
    case USER = 'user';
    case EMPLOYEE = 'employee';

    public function getLabel(): string
    {
        return match($this) {
            self::ADMIN => 'Administrador',
            self::USER => 'Usuário',
            self::EMPLOYEE => 'Funcionário',
        };
    }

    public function getColor(): string
    {
        return match($this) {
            self::ADMIN => 'text-red-500',
            self::USER => 'text-blue-500',
            self::EMPLOYEE => 'text-green-500',
        };
    }
}
