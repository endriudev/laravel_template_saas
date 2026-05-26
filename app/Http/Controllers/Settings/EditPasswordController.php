<?php

declare(strict_types=1);

namespace App\Http\Controllers\Settings;

use App\Http\Controllers\Controller;
use Inertia\Inertia;
use Inertia\Response;

final class EditPasswordController extends Controller
{
    public function __invoke(): Response
    {
        return Inertia::render('settings/password');
    }
}
