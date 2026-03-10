<?php

namespace App\Http\Responses;

use App\Enums\RolesEnum;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Laravel\Fortify\Contracts\LoginResponse as LoginResponseContract;
use Symfony\Component\HttpFoundation\Response;

class LoginResponse implements LoginResponseContract
{
    public function toResponse($request): Response
    {
        /** @var \App\Models\User $user */
        $user = Auth::user();

        if ($user->hasRole([RolesEnum::ADMIN->value])) {
            return $request->wantsJson()
                ? new JsonResponse('', 204)
                : \Inertia\Inertia::location(route('filament.admin.pages.dashboard'));
        }

        return $request->wantsJson()
            ? new JsonResponse('', 204)
            : redirect()->intended(route('dashboard'));
    }
}
