---
name: api-integration
description: Use when integrating external APIs in this Laravel project: HTTP clients, provider clients, DTOs, retries, webhooks, cache, and tests with Http::fake().
---

# API Integration

Use this with `laravel-best-practices` when adding or changing integrations with external providers.

## Project Rules

- Read `PROJECT.md` first for local architecture, Docker Compose commands, and Laravel Actions policy.
- Use the official provider documentation for current endpoints, auth, headers, rate limits, webhooks, and SDK availability.
- Prefer Laravel's HTTP client unless an official PHP SDK clearly reduces risk or is already used in the codebase.
- Store credentials in `config/services.php` and `.env.example`; never call `env()` outside config.
- Keep provider-specific code under `app/Integrations/{Provider}`.
- Do not put direct external HTTP calls in Services, Controllers, Jobs, or Filament actions.
- Services and Actions orchestrate use cases; Integrations encapsulate provider transport, authentication, payloads, retries, and errors.

## Implementation Pattern

- Create a small provider client, e.g. `App\Integrations\Asaas\AsaasClient`.
- Use DTOs or typed value objects for request/response shapes when arrays would leak provider details into the app.
- Add explicit `baseUrl`, auth headers, `timeout`, `connectTimeout`, `retry`, and `throw`.
- Translate provider failures into app exceptions with safe user-facing messages and structured log context.
- Use Laravel Actions when the integration operation is reused by controllers, jobs, listeners, commands, or Filament actions.
- Use jobs for slow or retryable external I/O.

## Webhooks

- Webhook controllers must be invokable and domain/provider grouped, e.g. `App\Http\Controllers\Webhook\HandleAsaasPaymentController`.
- Verify signatures before trusting payloads.
- Persist idempotency keys or provider event IDs before dispatching side effects.
- Return quickly; dispatch jobs for heavy work.

## Tests

- Use `Http::fake()` and `Http::preventStrayRequests()` for HTTP integrations.
- Test success, provider validation errors, server errors/retries, auth failure, timeout behavior where practical, and webhook signature/idempotency.
