---
name: project-architecture
description: Use when creating or refactoring project architecture in this Laravel app: invokable controllers, domain grouping, Laravel Actions, DTOs, services, events, jobs, and boundaries.
---

# Project Architecture

Use this with `laravel-best-practices` for backend architecture decisions in this project.

## Source of Truth

- Read `PROJECT.md` before making architecture changes.
- Laravel Boost rules are the baseline; these rules only define project-specific choices.
- Follow sibling files first, especially legacy Settings controllers until they are migrated.

## Controllers

- New controllers are invokable and do one thing.
- Group by domain: `App\Http\Controllers\{Domain}\{Action}Controller`.
- Route to the class directly: `Route::post('/orders/{order}/cancel', CancelOrderController::class)`.
- Keep controllers thin: authorize, validate via Form Request, call Action/Service, return response.

## Laravel Actions

- Reusable application operations live in `app/Actions/{Domain}`.
- Use `Lorisleiva\Actions\Concerns\AsAction` for new reusable Actions.
- Put core behavior in `handle()`.
- Add `asController`, `asJob`, `asListener`, or `asCommand` only when that action is actually used in that context.
- Do not replace every controller with an Action. Prefer invokable controllers for HTTP/Inertia presentation flow; use Actions for reusable business operations.

## Supporting Patterns

- Integrations live in `app/Integrations/{Provider}` and own external API transport, authentication, payload mapping, retries, and provider errors.
- Services and Actions may call Integrations, but must not contain direct external HTTP calls.
- DTOs should be `final readonly` when they clarify boundaries or provider payloads.
- Services are acceptable for cohesive domain workflows that are not a single command-style action.
- Events/listeners are for side effects after explicit business events.
- Jobs are for slow, retryable, or external I/O work.
- Avoid repositories unless a real persistence abstraction exists.

## Verification

- Add or update Pest tests for behavior changes.
- Run relevant tests and Pint inside Docker Compose.
