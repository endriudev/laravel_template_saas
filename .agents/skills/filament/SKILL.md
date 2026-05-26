---
name: filament-project
description: Use when creating or modifying Filament v5 Resources, pages, schemas, tables, actions, widgets, or relation managers in this project.
---

# Filament Project Patterns

Use this with the Laravel Boost Filament guidelines.

## Source of Truth

- Read `PROJECT.md` first.
- Use `search-docs`/Boost docs when available for Filament v5 APIs.
- Use Filament Artisan commands; do not hand-create resources when a command exists.

## Resource Shape

- Keep a Resource class small. When forms, infolists, tables, actions, or widgets grow, delegate them into dedicated classes under the Resource domain folder.
- Use Filament v5 namespaces from Boost:
  - `Filament\Actions\*` for actions.
  - `Filament\Schemas\*` for schemas/layout.
  - `Filament\Forms\Components\*` for form fields.
  - `Filament\Tables\*` for tables.
  - `Filament\Support\Icons\Heroicon` for icons.
- Use `->visibility('public')` for uploads that must be publicly accessible.

## Actions and Domain Logic

- Filament actions should stay thin.
- Move reusable business behavior into `app/Actions/{Domain}` using Laravel Actions.
- Queue slow external I/O or heavy work.

## Tests

- Use Pest and Livewire testing helpers for panel behavior.
- Authenticate with a user factory before testing panel pages.
- For edit pages, call `save`; for create pages, call `create`.
