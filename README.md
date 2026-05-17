# Laravel SaaS Template

Template para iniciar projetos SaaS com Laravel 13, Inertia v3 e Filament 5. Stack pré-configurada com Docker, Postgres, Pest e Wayfinder — `Use this template` no GitHub e em minutos você tem auth, painel admin e SSR rodando.

## Stack

| Camada | Tecnologia |
| --- | --- |
| Backend | PHP 8.4, Laravel 13, Fortify (auth headless), Spatie Permission |
| Admin | Filament 5 (em `/admin`) |
| Frontend | React 19 + TypeScript, Inertia v3 (auto-mode com `@inertiajs/vite`), Tailwind v4 |
| Build | Vite 8, Wayfinder (rotas tipadas), React Compiler |
| Banco | Postgres 17 |
| Testes | Pest 4 + PHPUnit 12 |
| DevEx | Pint, ESLint 9, Prettier 3, Laravel Boost (MCP) |

## Início rápido

Requer Docker e Docker Compose v2.

```bash
# 1. Criar repo a partir do template no GitHub e clonar
git clone git@github.com:<seu-user>/<seu-projeto>.git
cd <seu-projeto>

# 2. Subir os containers (app + nginx + postgres)
cp .env.example .env
docker compose up -d

# 3. Instalar deps e gerar key
docker compose exec app composer install
docker compose exec app php artisan key:generate
docker compose exec app npm install

# 4. Migrar banco
docker compose exec app php artisan migrate

# 5. Build de assets (ou rodar dev server abaixo)
docker compose exec app npm run build
```

Acesse:

- **App**: <http://localhost>
- **Painel admin (Filament)**: <http://localhost/admin>
- **Vite dev server**: <http://localhost:5173>

## Comandos do dia a dia

Todos rodam dentro do container `app` via `docker compose exec app …`.

### Dev

```bash
# Hot reload do frontend
docker compose exec app npm run dev

# Stack completa em paralelo (server + queue + logs + vite)
docker compose exec app composer dev
```

### Testes

```bash
docker compose exec app php artisan test --compact
# Filtrar por nome:
docker compose exec app php artisan test --compact --filter=login
```

### Qualidade

```bash
# PHP — formatação
docker compose exec app vendor/bin/pint --dirty

# Frontend — lint + format + types
docker compose exec app npm run lint
docker compose exec app npm run format
docker compose exec app npm run types:check
```

### Build de produção

```bash
docker compose exec app npm run build:ssr
```

## Estrutura

```
app/
├── Http/Controllers/         # Controllers invocáveis por domínio (Course/, Dashboard/, …)
├── Actions/                  # Lógica reutilizável (use Action quando o caso aparece em 2+ controllers)
├── Filament/Resources/       # Resources do painel admin
└── Providers/Filament/       # AdminPanelProvider

resources/js/
├── app.tsx                   # Bootstrap do Inertia (auto-mode, sem resolve/setup)
├── pages/                    # Páginas do Inertia (resolve automático via @inertiajs/vite)
├── layouts/                  # AppLayout, AuthLayout, SettingsLayout
├── components/ui/            # Primitives (Radix + Tailwind)
└── hooks/                    # Hooks compartilhados

docker/
├── nginx/                    # Configs nginx
├── php/                      # php.ini de produção
└── supervisor/               # supervisord configs (prod)

routes/
├── web.php                   # Rotas Inertia
└── auth.php                  # Rotas geradas pelo Fortify

tests/Feature/                # Pest features (auth, settings, …)
```

## Convenções

- **Invokable controllers**: cada controller faz uma coisa só, com `__invoke`. Organize por domínio em `app/Http/Controllers/{Domain}/{Action}Controller.php`.
- **Wayfinder**: nunca hardcode rotas no frontend. Use `import { store } from '@/routes/login'` ou `import Controller from '@/actions/App/Http/Controllers/…'`.
- **Inertia v3 auto-mode**: páginas declaram layouts via `Page.layout = { breadcrumbs, title, description }` em vez de wrapping JSX. O layout é resolvido em [resources/js/app.tsx](resources/js/app.tsx) pela função `layout: (name) => …`.
- **Pest**: todo PR muda comportamento, todo comportamento tem teste. `php artisan make:test --pest NomeTest`.

## Customização ao iniciar um novo projeto

Quando criar via `Use this template`, lembre de trocar:

1. `composer.json` → `name` e `description`
2. `package.json` → `name`
3. `docker-compose.yml` → `name: laravel_template_saas` para o nome do projeto novo
4. `.env` → `APP_NAME`, `APP_URL`, credenciais do Postgres (`DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`)
5. Rodar `php artisan key:generate`

Para reset do banco (se já subiu o postgres com credenciais antigas):

```bash
docker compose down -v   # destrutivo — apaga o volume do postgres
docker compose up -d
```

## Notas de migração

Este template já está atualizado para:

- **Laravel 13.9** com `PreventRequestForgery` no lugar do `VerifyCsrfToken` deprecado
- **Inertia v3.1** em modo auto (sem `resolve`/`setup` manual; SSR gerenciado pelo `@inertiajs/vite`)
- **PHP 8.4**, Vite 8, React 19, Tailwind v4

A imagem `laravel-app-base:dev` referenciada no `docker-compose.yml` é uma imagem base dev externa (PHP 8.4 + intl + composer). A imagem de produção é construída pelo [Dockerfile](Dockerfile) na raiz (multi-stage com Nginx + Supervisor).

## Licença

MIT.
