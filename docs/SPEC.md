# ReactPix — Especificação Técnica MVP

## Stack

### Implementado
- **Backend**: Laravel 12 + PHP 8.4 + Fortify (auth com 2FA) + Filament v5 (admin panel)
- **Frontend**: Inertia.js v2 + React 19 + Tailwind CSS v4 + shadcn/ui (Radix UI + CVA + tailwind-merge)
- **Routing**: Wayfinder (type-safe routes via Vite plugin)
- **Permissões**: Spatie Laravel Permission v7.2 (roles: ADMIN, USER, EMPLOYEE)
- **Database**: PostgreSQL 16 (JSONB) como baseline oficial em dev, teste, CI e produção
- **Cache/Queue/Session**: Redis (phpredis)
- **SSR**: Configurado via Vite (resources/js/ssr.tsx)
- **Build**: Vite + React Compiler (babel-plugin-react-compiler)
- **Testing**: Pest 4

### A Implementar
- **Queue Management**: Laravel Horizon (produção — `composer require laravel/horizon`)
- **WebSocket**: Laravel Reverb (Feature 6 — `composer require laravel/reverb`)
- **WebSocket Frontend**: `@laravel/echo-react` com hooks `useEcho` / `useEchoPublic` (Feature 6 — `npm install @laravel/echo-react`)

---

## Enums

### Existentes (`app/Enums/`)

- `RolesEnum` — ADMIN, USER, EMPLOYEE (implements Filament `HasLabel`, `HasColor`)
- `PermissionsEnum` — ReleasePurchase

### A criar (Feature 1)

- `DonationStatusEnum`: Pending, Paid, Failed, Refunded, Expired
- `WidgetTypeEnum`: QrCode, Alert, Ranking, Chat
- `WalletTransactionTypeEnum`: PendingCredit, ReleasePending, HoldWithdrawal, CompleteWithdrawal, FailWithdrawal, Refund, Fee, Adjustment
- `WithdrawalStatusEnum`: Pending, Processing, Completed, Failed
- `IntegrationPlatformEnum`: Twitch, Kick, Youtube, StreamElements, StreamLabs
- `PixKeyTypeEnum`: Cpf, Email, Phone, Random
- `RankingPeriodEnum`: Daily, Weekly, Monthly, All

**Padrão obrigatório** (seguir `RolesEnum`):
- Sufixo `Enum` no nome da classe
- `enum NomeEnum: string` (backed string)
- Cases em TitleCase: `case Pending = 'pending'`, `case QrCode = 'qrcode'`
- Implements `HasLabel` (Filament) quando relevante para admin panel
- Método `defaultConfig()` no `WidgetTypeEnum` que retorna o JSONB padrão de cada tipo

---

## Design System — Paleta de Cores

### Estado Atual

O projeto usa o tema shadcn/ui do Inertia starter kit com variáveis OKLch em `resources/css/app.css`. Suporte a light/dark/system via `HandleAppearance` middleware e cookie `appearance`. Custom variant: `@custom-variant dark (&:is(.dark *))`.

Os tokens shadcn/ui existentes (`--color-background`, `--color-primary`, `--color-card`, etc.) são a base e **não devem ser removidos**.

### Cor Principal: Teal

Accent teal com PIX green como cor de sucesso/pagamento. Os tokens abaixo são **extensões** que devem ser ADICIONADOS ao bloco `@theme` existente, sem substituir os tokens shadcn/ui.

### Tokens ReactPix (adicionar ao `@theme` existente)

```css
@theme {
  /* ── Tokens shadcn/ui existentes (NÃO remover) ── */
  /* --color-background, --color-primary, --color-card, etc. */

  /* ── Teal (accent principal ReactPix) ── */
  --color-brand-50:  oklch(0.96 0.05 175);
  --color-brand-100: oklch(0.92 0.08 175);
  --color-brand-200: oklch(0.85 0.12 175);
  --color-brand-300: oklch(0.78 0.14 175);
  --color-brand-400: oklch(0.72 0.14 175);
  --color-brand-500: oklch(0.65 0.13 175);  /* ← primary / botões */
  --color-brand-600: oklch(0.57 0.12 175);  /* ← hover */
  --color-brand-700: oklch(0.50 0.10 175);
  --color-brand-800: oklch(0.43 0.08 175);
  --color-brand-900: oklch(0.37 0.07 175);
  --color-brand-950: oklch(0.25 0.05 175);

  /* ── Surfaces (dark mode — usados em features ReactPix) ── */
  --color-surface-base:     oklch(0.13 0.005 285);
  --color-surface-raised:   oklch(0.17 0.005 285);
  --color-surface-overlay:  oklch(0.21 0.005 285);
  --color-surface-elevated: oklch(0.25 0.005 285);

  /* ── Borders ReactPix ── */
  --color-border-default:  oklch(0.30 0.005 285);
  --color-border-subtle:   oklch(0.23 0.005 285);
  --color-border-emphasis: oklch(0.38 0.005 285);

  /* ── Texto ReactPix ── */
  --color-text-primary:   oklch(0.98 0 0);
  --color-text-secondary: oklch(0.70 0.01 285);
  --color-text-muted:     oklch(0.55 0.01 285);
  --color-text-inverse:   oklch(0.13 0 0);

  /* ── Semânticos ── */
  --color-success:  oklch(0.65 0.17 160);  /* PIX confirmado */
  --color-warning:  oklch(0.75 0.16 85);
  --color-danger:   oklch(0.58 0.22 27);
  --color-info:     oklch(0.65 0.15 200);

  /* ── PIX (accent secundário) ── */
  --color-pix: oklch(0.72 0.20 150);  /* verde PIX */
}
```

### Aplicação Visual

| Elemento | Token | Uso |
|----------|-------|-----|
| Componentes base | Tokens shadcn/ui | `bg-background`, `bg-card`, `bg-primary` (starter kit) |
| Botão teal ReactPix | `brand-500` | `bg-brand-500 hover:bg-brand-600` |
| Botão danger | `danger` | `bg-danger hover:bg-danger/80` |
| Toggle ativo | `brand-500` | Bolinha teal |
| Badge sucesso | `success` | Doação confirmada |
| Badge pendente | `warning` | Pagamento pendente |
| QR Code PIX | `pix` | Verde PIX no botão de pagamento |
| Donation page | `brand-*` + `surface-*` | Tema customizado do streamer |
| Widget overlay | `surface-*` + `brand-*` | Embed OBS com fundo transparente |

### Regras visuais
- `rounded-xl` (12px) padrão em cards e inputs ReactPix
- Toggles com transição suave e cor `brand-500` quando ativo
- Preview ao vivo na sidebar direita (página de widgets)
- Ícones: Lucide React
- Font: Instrument Sans (do starter kit, sem customização forçada)
- Componentes shadcn/ui existentes: manter como estão, aplicar brand tokens apenas em features ReactPix
- Usar CVA para variantes de componentes (skill `tailwind-design-system`)
- Usar `cn()` de `@/lib/utils` para merge de classes

---

## Schema Completo (PostgreSQL)

> Usar string columns + PHP enum cast em vez de database-level enums (melhor portabilidade e type safety).
> Centavos como integer (nunca decimal pra dinheiro).
> Usar `$table->uuid()` (tipo nativo PostgreSQL) para colunas UUID, não `$table->string()`.
> Usar CHECK constraints do PostgreSQL para validações financeiras críticas (saldos >= 0, valores > 0).
> Usar partial indexes para queries frequentes em subconjuntos de dados (ex: só registros pendentes/ativos).
> Toda alteração de schema deve ser implementada como **Laravel migration** em `database/migrations`, criada via `php artisan make:migration --no-interaction`.
> Em PostgreSQL, usar `Schema` / `Blueprint` como padrão e `DB::statement()` apenas para `jsonb`, CHECK constraints e índices parciais/composite que o Schema Builder não cobrir.

### users (Fortify starter kit)

| Coluna | Tipo | Notas |
|--------|------|-------|
| id | bigint PK | |
| name | string | |
| email | string unique | |
| username | string unique | **[A adicionar — Feature 1]** Handle público em lowercase, usado na rota `/{username}` |
| avatar_url | string nullable | **[A adicionar — Feature 1]** |
| password | string | |
| two_factor_secret | text nullable | **[EXISTE]** Encrypted (Fortify 2FA) |
| two_factor_recovery_codes | text nullable | **[EXISTE]** Encrypted (Fortify 2FA) |
| two_factor_confirmed_at | timestamp nullable | **[EXISTE]** (Fortify 2FA) |
| email_verified_at | timestamp nullable | |
| remember_token | string nullable | |
| created_at / updated_at | timestamps | |

> **Roles**: gerenciados via Spatie Laravel Permission (tabelas `roles`, `model_has_roles`, `permissions`, etc. já existem).
> **Usernames reservados**: bloquear via config/validation nomes como `admin`, `dashboard`, `settings`, `login`, `register`, `password`, `verify-email`, `two-factor`, `logout`, `up`, `webhooks`.
> **Rota pública**: `/{username}` deve ser a última rota de `routes/web.php`. Qualquer nova rota top-level futura precisa entrar na lista de usernames reservados.

### donation_pages (1:1 — perfil público / checkout do criador)

| Coluna | Tipo | Notas |
|--------|------|-------|
| id | bigint PK | |
| user_id | bigint unique FK | |
| title | string nullable | Ex: "Envie uma mensagem!" |
| description | text nullable | |
| background_image_url | string nullable | |
| profile_image_url | string nullable | Fallback: user.avatar_url |
| primary_color | string default '#14b8a6' | Teal 500 |
| min_amount_cents | int default 100 | Centavos (R$1,00) |
| suggested_amounts | jsonb default '[500,1000,2000,5000]' | |
| is_active | bool default true | |
| created_at / updated_at | timestamps | |
| | CHECK(min_amount_cents > 0) | |

> **URL pública**: a rota `/{username}` usa `users.username` diretamente. Não há slug separado na donation_page.
> **Estado da página**: `donation_pages.is_active` controla se a página pública recebe novas doações. Não reutilizar `message_settings.is_accepting_messages` para pausar o perfil.

### message_settings (1:1 — config de mensagens do streamer)

| Coluna | Tipo | Notas |
|--------|------|-------|
| id | bigint PK | |
| user_id | bigint unique FK | |
| is_accepting_messages | bool default true | Habilita/desabilita texto/áudio quando a donation page estiver ativa |
| max_message_length | int default 250 | |
| accept_audio | bool default true | Mensagens de voz |
| max_audio_duration | int default 15 | Segundos |
| min_audio_amount_cents | int default 100 | Centavos mín pra áudio |
| tts_enabled | bool default false | Ler mensagem em voz alta (IA) |
| tts_read_donor_name | bool default false | Ler nome do doador |
| ai_voice_enabled | bool default false | Voz de IA [beta] |
| ai_moderation_enabled | bool default false | Censurar com IA |
| blocked_words | jsonb default '[]' | Palavras censuradas manualmente |
| created_at / updated_at | timestamps | |

> **Escopo**: esta tabela controla intake de mensagens. A disponibilidade pública da página continua sendo responsabilidade de `donation_pages.is_active`.

### widget_settings (1:1 — cores globais dos widgets OBS)

| Coluna | Tipo | Notas |
|--------|------|-------|
| id | bigint PK | |
| user_id | bigint unique FK | |
| primary_color | string default '#14b8a6' | Teal 500 |
| secondary_color | string default '#fafafa' | Zinc 50 |
| created_at / updated_at | timestamps | |

### widget_configs (1:N — lazy-creation na primeira vez que o user acessa cada tipo)

| Coluna | Tipo | Notas |
|--------|------|-------|
| id | bigint PK | |
| user_id | bigint FK | |
| type | string | Cast: `WidgetTypeEnum` |
| token | uuid unique | Pra embed URL `/embed/{token}` (tipo nativo PG `uuid`) |
| config | jsonb | Config específica por tipo (ver abaixo) |
| is_active | bool default true | |
| created_at / updated_at | timestamps | |
| | UNIQUE(user_id, type) | |
| | INDEX(token) WHERE is_active = true | Partial index — embed público |

#### Config JSONB por tipo:

**QrCode:**
```json
{
    "primary_color": null,
    "secondary_color": null,
    "auto_hide": true,
    "hide_interval": 300,
    "show_duration": 30,
    "show_link": true,
    "show_message": true,
    "custom_message": "Aponte a câmera do celular"
}
```

**Alert:**
```json
{
    "primary_color": null,
    "secondary_color": null,
    "play_sound": true,
    "sound_url": null,
    "animation": "fade_in",
    "duration": 8,
    "tts_enabled": false,
    "tts_voice": "pt-BR-female",
    "min_amount_tts_cents": 500
}
```

**Ranking:**
```json
{
    "primary_color": null,
    "secondary_color": null,
    "period": "monthly",
    "max_entries": 10,
    "show_amount": true
}
```

**Chat:**
```json
{
    "primary_color": null,
    "secondary_color": null,
    "show_username_color": true,
    "font_size": 16,
    "max_messages": 20
}
```

> **Regra de cores**: `primary_color: null` → usa `widget_settings.primary_color` do user. Se tiver valor, usa o override do widget.
> **Escopo do enum**: `Goals` não faz parte de `WidgetTypeEnum`. Metas continuam sendo uma entidade separada, com token e histórico próprios.

### goals (1:N — criados manualmente pelo streamer)

| Coluna | Tipo | Notas |
|--------|------|-------|
| id | bigint PK | |
| user_id | bigint FK | |
| title | string | "Meta da stream" |
| target_amount_cents | int | Centavos |
| current_amount_cents | int default 0 | Centavos (cache de leitura rápida) |
| bar_color | string nullable | Fallback: widget_settings.primary_color |
| token | uuid unique | Pra embed URL (tipo nativo PG `uuid`) |
| is_active | bool default true | |
| ends_at | timestamp nullable | |
| created_at / updated_at | timestamps | |
| | CHECK(target_amount_cents > 0) | |
| | CHECK(current_amount_cents >= 0) | |
| | INDEX(user_id) WHERE is_active = true | Partial index — busca metas ativas na doação |

> **Regra de produto**: múltiplas goals podem ficar ativas ao mesmo tempo. Quando uma doação é confirmada, ela contribui para todas as goals ativas do usuário naquele instante.

### donations (doações — core do negócio)

| Coluna | Tipo | Notas |
|--------|------|-------|
| id | bigint PK | |
| user_id | bigint FK | Streamer que recebe |
| donor_name | string | |
| donor_email | string nullable | |
| message | text nullable | Texto da doação |
| audio_url | string nullable | Se mensagem de áudio |
| gross_amount_cents | int | Valor total pago pelo doador |
| platform_fee_cents | int default 0 | Taxa da plataforma |
| gateway_fee_cents | int default 0 | Taxa do gateway |
| net_amount_cents | int | Valor líquido do criador |
| status | string | Cast: `DonationStatusEnum` |
| flagged | bool default false | Moderação |
| is_anonymous | bool default false | |
| metadata | jsonb nullable | Dados extras |
| paid_at | timestamp nullable | |
| created_at / updated_at | timestamps | |
| | CHECK(gross_amount_cents > 0) | |
| | CHECK(platform_fee_cents >= 0) | |
| | CHECK(gateway_fee_cents >= 0) | |
| | CHECK(net_amount_cents > 0) | |
| | CHECK(gross_amount_cents >= net_amount_cents) | |
| | INDEX(user_id, status) | Dashboard filtra por status |
| | INDEX(user_id, paid_at DESC) | Ordenação cronológica |
| | INDEX(user_id, status, paid_at) WHERE status = 'paid' | Partial index — query do ranking widget |

### payment_attempts (1:N — cobranças PIX / idempotência / reprocesso)

| Coluna | Tipo | Notas |
|--------|------|-------|
| id | bigint PK | |
| donation_id | bigint FK | |
| gateway | string | Ex: `mercadopago`, `pagarme`, `fake` |
| gateway_reference | string | ID externo do gateway |
| idempotency_key | string unique | Chave interna pra criação segura da cobrança |
| gateway_status | string | Status retornado pelo provedor |
| qr_code_payload | text nullable | Código copia-e-cola |
| qr_code_image_url | string nullable | URL/asset do QR renderizado |
| expires_at | timestamp nullable | Expiração da cobrança |
| paid_at | timestamp nullable | Quando o gateway confirmou |
| request_payload | jsonb nullable | Payload enviado ao gateway |
| response_payload | jsonb nullable | Payload devolvido ao criar cobrança |
| webhook_payload | jsonb nullable | Último payload de webhook relevante |
| created_at / updated_at | timestamps | |
| | UNIQUE(gateway, gateway_reference) | Lookup externo + idempotência |
| | INDEX(donation_id, created_at DESC) | Busca da cobrança mais recente |
| | INDEX(gateway, gateway_status) | Operação / debugging |

> **Responsabilidade**: `donations` guarda a intenção e o conteúdo público; `payment_attempts` guarda o ciclo de cobrança PIX.

### goal_contributions (N:N auditável entre doações pagas e goals ativas)

| Coluna | Tipo | Notas |
|--------|------|-------|
| id | bigint PK | |
| goal_id | bigint FK | |
| donation_id | bigint FK | |
| amount_cents | int | Valor creditado nesta goal |
| created_at | timestamp | Registrado no momento do `DonationPaid` |
| | UNIQUE(goal_id, donation_id) | Evita dupla contribuição |
| | CHECK(amount_cents > 0) | |
| | INDEX(goal_id, created_at DESC) | Histórico da goal |
| | INDEX(donation_id) | Auditoria por doação |

> **Rastreabilidade**: toda doação paga gera um registro por goal ativa no momento da confirmação. `goals.current_amount_cents` é derivado e mantido como cache de leitura.

### wallets (1:1 por moeda)

| Coluna | Tipo | Notas |
|--------|------|-------|
| id | bigint PK | |
| user_id | bigint FK | |
| currency | string default 'BRL' | |
| available_cents | int default 0 | Saldo disponível |
| held_cents | int default 0 | Saldo retido em saque |
| pending_cents | int default 0 | Saldo aguardando liberação |
| created_at / updated_at | timestamps | |
| | UNIQUE(user_id, currency) | |
| | CHECK(available_cents >= 0) | Previne saldo negativo |
| | CHECK(held_cents >= 0) | |
| | CHECK(pending_cents >= 0) | |

> **Concorrência**: a implementação base usa `DB::transaction()` + row lock (`lockForUpdate()` no wallet). Otimizações com advisory lock podem entrar depois, se benchmark justificar.

### wallet_transactions (histórico financeiro)

| Coluna | Tipo | Notas |
|--------|------|-------|
| id | bigint PK | |
| wallet_id | bigint FK | |
| type | string | Cast: `WalletTransactionTypeEnum` (evento do ledger) |
| available_delta_cents | int default 0 | Delta do saldo disponível |
| pending_delta_cents | int default 0 | Delta do saldo pendente |
| held_delta_cents | int default 0 | Delta do saldo retido |
| available_after_cents | int | Snapshot após o lançamento |
| pending_after_cents | int | Snapshot após o lançamento |
| held_after_cents | int | Snapshot após o lançamento |
| description | string nullable | |
| donation_id | bigint nullable FK | Referência à doação (se crédito) |
| withdrawal_id | bigint nullable FK | Referência ao saque (se débito) |
| created_at | timestamp | Sem updated_at (imutável) |
| | INDEX(wallet_id, created_at DESC) | Paginação de histórico |

> **Imutabilidade**: wallet_transactions não tem `updated_at`. Registros nunca são alterados ou deletados — são append-only.
> **Referências**: usar FKs explícitas em vez de polimorfismo string. No máximo uma das FKs (donation_id, withdrawal_id) deve ser non-null.

### withdrawals (saques)

| Coluna | Tipo | Notas |
|--------|------|-------|
| id | bigint PK | |
| user_id | bigint FK | |
| amount_cents | int | Centavos |
| fee_cents | int default 0 | Taxa do saque |
| status | string | Cast: `WithdrawalStatusEnum` |
| pix_key | text | Encrypted cast (pode conter CPF) |
| pix_key_type | string | Cast: `PixKeyTypeEnum` |
| processed_by | bigint nullable FK | User (admin) que aprovou/rejeitou |
| failure_reason | string nullable | |
| completed_at | timestamp nullable | |
| created_at / updated_at | timestamps | |
| | CHECK(amount_cents > 0) | |
| | CHECK(fee_cents >= 0) | |
| | INDEX(user_id, status) | Histórico filtrado |
| | INDEX(status) WHERE status IN ('pending', 'processing') | Partial index — fila admin |

### integrations (1:N — conexões com plataformas)

| Coluna | Tipo | Notas |
|--------|------|-------|
| id | bigint PK | |
| user_id | bigint FK | |
| platform | string | Cast: `IntegrationPlatformEnum` |
| platform_user_id | string nullable | ID na plataforma |
| account_name | string nullable | |
| profile_picture | string nullable | |
| credentials | jsonb nullable | Encrypted cast com access/refresh tokens e segredos |
| metadata | jsonb nullable | Dados extras específicos do provider |
| token_expires_at | timestamp nullable | |
| is_active | bool default true | |
| connected_at | timestamp nullable | |
| created_at / updated_at | timestamps | |
| deleted_at | timestamp nullable | SoftDeletes |
| | UNIQUE(user_id, platform) | |

---

## Auto-criação no Registro do User

Quando um user se registra via Fortify (evento `UserRegistered`), criar automaticamente via listener:

1. `donation_pages` — com primary_color = '#14b8a6'
2. `message_settings` — defaults
3. `widget_settings` — primary_color '#14b8a6', secondary_color '#fafafa'
4. `wallets` — 1 registro (BRL)
5. Atribuir role `USER` via Spatie `assignRole` (skill `laravel-permission-development`)

> **widget_configs**: criados via lazy-creation na primeira vez que o user acessa cada tipo de widget.
> O `WidgetTypeEnum::defaultConfig()` retorna o JSONB padrão. O controller `ShowWidgetConfigController`
> usa `firstOrCreate` com os defaults do enum.

---

## Estrutura de Páginas (Inertia React)

Padrão de nomeação: **lowercase com pastas por domínio**, arquivos `index.tsx`, `show.tsx`, etc.

```
resources/js/pages/
├── welcome.tsx                    [EXISTE]
├── dashboard.tsx                  [EXISTE] placeholder → mover para dashboard/index.tsx
├── auth/                          [EXISTE] Fortify starter kit
│   ├── login.tsx
│   ├── register.tsx
│   ├── forgot-password.tsx
│   ├── reset-password.tsx
│   ├── verify-email.tsx
│   ├── confirm-password.tsx
│   └── two-factor-challenge.tsx
├── settings/                      [EXISTE] Starter kit
│   ├── profile.tsx
│   ├── password.tsx
│   ├── appearance.tsx
│   └── two-factor.tsx
├── dashboard/                     [A CRIAR — Feature 2]
│   └── index.tsx                  # Central de Controle (Mensagens + Config)
├── wallet/                        [A CRIAR — Feature 7]
│   └── index.tsx                  # Saldo e Transações
├── widgets/                       [A CRIAR — Feature 5]
│   └── index.tsx                  # QRCode | Alerta | Metas | Ranking | Chat
├── integrations/                  [A CRIAR — Feature 8]
│   └── index.tsx                  # Twitch, Kick, StreamElements, etc
├── donate/                        [A CRIAR — Feature 3]
│   └── show.tsx                   # Página pública /{username} (checkout)
```

### Skills por página
- Páginas React: ativar `inertia-react-development` (Form, useForm, Link, deferred props)
- Rotas no frontend: ativar `wayfinder-development` (import de @/actions e @/routes)
- Estilização: ativar `tailwindcss-development` e `tailwind-design-system` (CVA, compound components)
- Performance: seguir `vercel-react-best-practices` (async-parallel, bundle-dynamic-imports)

### Rotas de Widget (NÃO Inertia — Standalone React via Vite entry point)

```
/embed/{token}  → WidgetEmbedController → Blade + standalone React
```

O widget OBS usa um entry point Vite separado (`resources/js/widget.tsx`), sem Inertia. React puro com `useEcho` do `@laravel/echo-react` pra WebSocket, fundo transparente.

---

## Sidebar do Dashboard

| Ícone (Lucide) | Label | Rota |
|-----------------|-------|------|
| `Mail` | Central de Controle | /dashboard |
| `Wallet` | Saldo e Transações | /wallet |
| `QrCode` | QRCode e Widgets | /widgets |
| `Plug` | Integrações | /integrations |
| `Settings` | Configurações | /settings/profile |

> Usar Wayfinder para links da sidebar: importar rotas via `@/routes/`.

---

## Filament Admin Panel

Painel administrativo em `/admin` para gestão interna (ADMIN e EMPLOYEE).

### Implementado
- `AdminPanelProvider` com login, cor Amber, middleware `role:admin|employee` (Spatie)
- Auto-discover de Resources, Pages, Widgets em `app/Filament/`

### A Implementar
- `UserResource` — CRUD de usuários, atribuir roles
- `DonationResource` — Moderação, visualizar doações
- `WithdrawalResource` — Aprovar/rejeitar saques
- Dashboard widgets — Métricas da plataforma (receita, usuários ativos, etc.)

---

## Convenções de Código

### Backend (Laravel)
- **Controllers invokable** (`__invoke`) — 1 controller por ação, organizados em subpastas por domínio
  - Os controllers de Settings existentes são multi-method (legado starter kit), novos controllers devem ser invokable
- **Form Requests** pra toda validação
- **Enums PHP 8.4** pra status/tipos — sufixo `Enum`, case TitleCase, backed string (ver seção Enums)
- **Eloquent casts** com `casts()` method (enums, jsonb como array, booleans, datetime, encrypted)
- **Services** pra lógica de negócio (PaymentService, WalletService, AlertService)
- **Actions** (`app/Actions/`) pra lógica reutilizável em mais de um lugar
- **Events + Listeners** pra side effects (DonationPaid → BroadcastAlert, UpdateWallet, UpdateGoal)
- **Jobs queued** pra operações async (ProcessPixWebhook, ProcessWithdrawal) — Redis queue
- **Spatie Permission** — roles via middleware (`role`, `permission`, `role_or_permission`). User model usa `HasRoles`
- **API Resources** quando necessário
- **Pint** pra formatação (`vendor/bin/pint --dirty --format agent`)

### Frontend (React + Inertia)
- **shadcn/ui** como base de componentes (Radix UI + CVA + tailwind-merge)
- **Tailwind v4** com `@theme` pra design tokens — tokens shadcn/ui como base, tokens brand-*/surface-* como extensão ReactPix
- **Aparência**: manter sistema do starter kit (light/dark/system via HandleAppearance)
- **Wayfinder** pra rotas type-safe: `import { store } from '@/actions/...'`
- **Inertia v2**: usar `<Form>` ou `useForm` para formulários, deferred props para dados pesados, `<Link>` para navegação
- **WebSocket**: `useEcho` / `useEchoPublic` do `@laravel/echo-react` (Feature 6)
- Componentes em `resources/js/components/`
- Pages em `resources/js/pages/` (lowercase, pastas por domínio)
- Ícones: Lucide React
- Performance: seguir `vercel-react-best-practices` (Promise.all, dynamic imports, functional setState)

### Padrão Visual
- Componentes shadcn/ui: usar tokens existentes (`bg-background`, `bg-card`, `bg-primary`, etc.)
- Features ReactPix (donation pages, widgets, overlays): usar tokens brand-*/surface-* (adicionados na Feature 2)
- Cards ReactPix: `bg-surface-raised border border-border-default rounded-xl`
- Botões teal: `bg-brand-500 hover:bg-brand-600 text-text-inverse`
- Inputs ReactPix: `bg-surface-raised border border-border-default rounded-xl`
- Toggles: `brand-500` quando ativo
- Tabs: underline `bg-brand-500` ativa, `text-text-muted` inativa
- QR Code PIX: cor `pix` no botão de pagamento

---

## Skills Disponíveis (`.claude/skills/`)

| Skill | Quando ativar |
|-------|---------------|
| `inertia-react-development` | Páginas React, forms, navegação, deferred props, polling, WhenVisible |
| `wayfinder-development` | Rotas no frontend, @/actions, @/routes |
| `tailwindcss-development` | Estilização, dark mode, layout, responsividade |
| `tailwind-design-system` | Design tokens, component library, CVA, compound components |
| `frontend-design` | Interfaces distintas, UI design criativo |
| `developing-with-fortify` | Auth, 2FA, login, register, password reset |
| `laravel-permission-development` | Roles, permissions, middleware, seeding |
| `pest-testing` | Testes, assertions, browser testing, architecture tests |
| `vercel-react-best-practices` | Performance React (async, bundle, rerender, rendering) |

---

## Features MVP (ordem de implementação)

### Feature 1: Foundation
Models, Laravel migrations, factories, seeders, enums, usernames reservados e auto-criação no registro.

### Feature 2: Design System + Layout + Dashboard — Central de Controle
Tokens brand-*/surface-* no CSS. Sidebar atualizada. Lista de doações recebidas (tabela com Doador, Valor, Mensagem, Horário, Ações).
Botão "Tocar alerta" por doação. Botão "Pausar" página de doação.
Tab "Config. Mensagens". Exportar CSV.

### Feature 3: Donation Page (Checkout Público)
Página `/{username}` com perfil do streamer, QR Code PIX, formulário de doação.
Integração com gateway PIX (abstração), `payment_attempts` e usernames reservados.

### Feature 4: Payment Processing
Gateway PIX abstrato (interface). Webhook receiver interno.
Confirmação de pagamento com idempotência por `payment_attempts`. Event DonationPaid com listeners.

### Feature 5: Widget System
Config dos widgets (tabs). Preview ao vivo na sidebar.
Rotas de embed (standalone React + useEcho/Reverb).

### Feature 6: Real-time Broadcasting
Laravel Reverb + `@laravel/echo-react`. Broadcasting de DonationPaid.
Widget overlay recebendo events via `useEcho`. Alert controls (pause/skip/replay).

### Feature 7: Wallet & Withdrawals
Saldo, transações em ledger imutável, recebíveis. Saques via PIX.

### Feature 8: Integrations
OAuth com Twitch, Kick. StreamElements/StreamLabs.

---

## Prompts para Claude Code (por feature)

### Prompt 1 — Foundation

```
Leia o arquivo docs/SPEC.md para contexto completo do projeto.

Ative as skills: `laravel-specialist`, `laravel-permission-development`, `pest-testing`.

Dentro deste projeto Laravel 12 + Inertia React (starter kit já instalado
com Fortify + Filament + Spatie Permission), crie toda a camada de foundation:

IMPORTANTE — O que já existe (NÃO recriar):
- RolesEnum (ADMIN, USER, EMPLOYEE) e PermissionsEnum (ReleasePurchase)
- Colunas 2FA na users (two_factor_secret, two_factor_recovery_codes, two_factor_confirmed_at)
- User model com HasRoles (Spatie) e TwoFactorAuthenticatable (Fortify)
- Tabelas de roles/permissions (Spatie)
- RoleSeeder e UserSeeder

1. ENUMS (app/Enums/) — seguir padrão do RolesEnum (sufixo Enum, case TitleCase, backed string):
   - DonationStatusEnum: Pending, Paid, Failed, Refunded, Expired
   - WidgetTypeEnum: QrCode, Alert, Ranking, Chat (com método defaultConfig())
   - WalletTransactionTypeEnum: PendingCredit, ReleasePending, HoldWithdrawal, CompleteWithdrawal, FailWithdrawal, Refund, Fee, Adjustment
   - WithdrawalStatusEnum: Pending, Processing, Completed, Failed
   - IntegrationPlatformEnum: Twitch, Kick, Youtube, StreamElements, StreamLabs
   - PixKeyTypeEnum: Cpf, Email, Phone, Random
   - RankingPeriodEnum: Daily, Weekly, Monthly, All

2. LARAVEL MIGRATIONS (obrigatoriamente em `database/migrations/`, criadas com `php artisan make:migration --no-interaction`, na ordem correta de dependências):
   - Alterar users: adicionar username (unique), avatar_url
   - donation_pages
   - message_settings
   - widget_settings
   - widget_configs
   - donations
   - payment_attempts
   - wallets
   - wallet_transactions
   - goals
   - goal_contributions
   - withdrawals
   - integrations

   Também crie uma configuração explícita para usernames reservados da rota pública `/{username}`.
   Use os tipos corretos do PostgreSQL. JSONB onde indicado.
   Centavos como integer (nunca decimal pra dinheiro).
   Use string columns com PHP enum cast (não database-level enums).
   Use Schema Builder / Blueprint como padrão e `DB::statement()` apenas
   quando precisar de JSONB, CHECK constraints ou índices parciais/composite.
   Consulte o Schema Completo no SPEC.md para os campos exatos.

3. MODELS com:
   - Relationships completas (belongsTo, hasOne, hasMany)
   - Casts usando casts() method (enums, jsonb como array, booleans, datetime)
   - Fillable arrays
   - Encrypted casts pra dados sensíveis (`integrations.credentials`, pix keys, etc)

4. FACTORIES pra todos os models com states úteis.

5. LISTENER (CreateDefaultUserResources):
   Ao registrar user (UserRegistered event), criar automaticamente:
   - Atribuir role USER via Spatie assignRole
   - donation_pages (primary_color = '#14b8a6')
   - message_settings (defaults)
   - widget_settings (primary '#14b8a6', secondary '#fafafa')
   - wallet (BRL)

   widget_configs são lazy-created (firstOrCreate no ShowWidgetConfigController).
   O WidgetTypeEnum deve ter método defaultConfig() que retorna
   o JSONB padrão de cada tipo conforme documentado no SPEC.md.

6. Rode migrations e verifique se tudo funciona.
7. Rode vendor/bin/pint --dirty --format agent.
8. Rode php artisan test --compact.

Convenções:
- Controllers serão invokable (__invoke), não crie controllers ainda
- Use PHP 8.4 features (enums, typed properties, constructor promotion)
- Siga PSR-12 e rode Pint ao final
- Não crie controllers ainda, apenas foundation
```

### Prompt 2 — Design System + Layout + Central de Controle

```
Leia o arquivo docs/SPEC.md para contexto completo do projeto.

Ative as skills: `tailwindcss-development`, `tailwind-design-system`,
`inertia-react-development`, `wayfinder-development`, `pest-testing`.

Configure o design system, atualize o layout, e crie a Central de Controle:

1. TAILWIND v4 — ADICIONE os tokens ReactPix ao bloco @theme existente
   em resources/css/app.css (seção "Tokens ReactPix" do SPEC.md).
   NÃO remova os tokens shadcn/ui existentes.
   Manter sistema de aparência do starter kit (light/dark/system).

2. LAYOUT — Atualize a sidebar do starter kit (NÃO recriar componente):
   - 5 itens: Central de Controle (/dashboard), Saldo e Transações (/wallet),
     QRCode e Widgets (/widgets), Integrações (/integrations),
     Configurações (/settings/profile)
   - Ícones: Lucide React (Mail, Wallet, QrCode, Plug, Settings)
   - Usar Wayfinder para links: importar rotas via @/routes/

3. CENTRAL DE CONTROLE — Mover dashboard.tsx para dashboard/index.tsx:
   - Substituir Route::inertia por controller invokable (ShowDashboardController)

   TAB 1 — Doações:
   - Controller invokable: ToggleDonationPageStatusController
   - Tabela com colunas: Doador, Valor (formatado R$), Mensagem, Horário, Ações
   - Ação "Tocar alerta" por doação
   - Banner "Suas doações estão ativas" com botão "Pausar"
     que toggle donationPage.is_active
   - Botão "Exportar" (CSV)
   - Usar deferred props para doações paginadas

   TAB 2 — Config. Mensagens:
   - Controller invokable: UpdateMessageSettingsController
   - Form com toggles e inputs da tabela message_settings
   - Form Request pra validação
   - Usar Inertia <Form> ou useForm pra submit

Rode vendor/bin/pint --dirty --format agent e php artisan test --compact ao final.
```

### Prompt 3 — Donation Page (Checkout Público)

```
Leia o arquivo docs/SPEC.md para contexto completo do projeto.

Ative as skills: `inertia-react-development`, `wayfinder-development`,
`frontend-design`, `vercel-react-best-practices`, `pest-testing`.

Crie a página pública de doação acessível em /{username}:

1. Controller invokable: ShowDonateController
   - Busca User pelo username com donationPage e messageSettings
   - Retorna Inertia page com dados da página
   - Rota pública (sem auth)
   - A rota `/{username}` deve ser registrada por último em `routes/web.php`
   - Usernames reservados devem ser rejeitados no cadastro/edição do perfil

2. Página React (donate/show.tsx):
   - Foto de perfil do streamer (profile_image_url ou user.avatar_url)
   - Nome/título
   - Background image se configurado
   - Campo "Seu nome"
   - Valores sugeridos como chips clicáveis (suggested_amounts)
   - Campo de valor customizado
   - Campo de mensagem (respeitando max_message_length da messageSettings)
   - Botão "Enviar PIX" (cor pix verde)
   - Ao submeter: cria donation com status pending e gera um payment_attempt PIX
   - Exibir QR Code pra pagamento
   - A primary_color da donation_page define o accent dessa página

3. Controller invokable: StoreDonationController
   - Form Request com validação
   - Cria donation com status pending
   - Cria payment_attempt com idempotency_key e gateway_reference
   - Chama PixGateway pra gerar cobrança
   - Retorna QR Code data

4. Interface PixGateway (app/Contracts/PixGateway.php):
   - createCharge(int $amountCents, string $description): PixCharge
   - parseWebhook(Request $request): WebhookPayload
   - verifySignature(Request $request): bool
   - Implementação fake: app/Services/Pix/FakePixGateway.php
   - Binding no AppServiceProvider

5. Rota: GET /{username} (nomeada: donate.show)
   Rota: POST /donate (nomeada: donate.store)

Responsive mobile-first (viewer vai acessar pelo celular).

Rode Pint e testes ao final.
```

### Prompt 4 — Payment Processing

```
Leia o arquivo docs/SPEC.md para contexto completo do projeto.

Ative as skills: `laravel-specialist`, `pest-testing`.

Implemente o processamento de pagamento:

1. Webhook Receiver:
   - POST /webhooks/pix → PixWebhookController (invokable)
   - Valida assinatura do gateway via PixGateway::verifySignature()
   - Dispatch job ProcessPixWebhook

2. Job ProcessPixWebhook:
   - Encontra payment_attempt por `(gateway, gateway_reference)`
   - Garante idempotência: não pode liquidar a mesma cobrança 2x
   - Atualiza payment_attempt pra paid e liquida a donation só se ela ainda estiver pending
   - Dispatch event DonationPaid

3. Event DonationPaid implements ShouldBroadcast:
   - Canal: private-streamer.{user_id}
   - Payload: donor_name, amount_formatted, message

4. Listeners do DonationPaid:
   - UpdateWalletBalance → registra entrada `PendingCredit` no ledger e atualiza `wallet.pending_cents`
   - UpdateGoalProgress → cria `goal_contributions` para todas as goals ativas e atualiza `goals.current_amount_cents`

Rode Pint e testes ao final.
```

### Prompt 5 — Widget System

```
Leia o arquivo docs/SPEC.md para contexto completo do projeto.

Ative as skills: `inertia-react-development`, `tailwind-design-system`,
`wayfinder-development`, `pest-testing`.

Crie o sistema de widgets do dashboard:

1. Página de Widgets (widgets/index.tsx):
   - 5 tabs: QRCode | Alerta | Metas | Ranking | Chat
   - Layout: configs à esquerda + preview ao vivo à direita (sidebar fixa)
   - Cada tab carrega o widget_config do tipo correspondente
   - Componente "Personalizar cores do widget" com color pickers
     (primary_color, secondary_color override por widget)
   - Botão "Incorporar Widget" abre modal com URL de embed pra copiar
   - Botão "Testar alerta" no header (só na tab Alerta)

2. Configs por tab (conforme SPEC.md, seção Config JSONB por tipo):
   QRCode: auto_hide, show_link, show_message, custom_message
   Alerta: play_sound, tts_enabled, duration, animation
   Metas: botão "+ Nova meta", modal de criação, lista, múltiplas metas ativas
   Ranking: period, max_entries, show_amount
   Chat: show_username_color, font_size

3. Controllers invokable:
   - ShowWidgetConfigController (show por tipo)
   - UpdateWidgetConfigController (update)
   - StoreGoalController, UpdateGoalController, DestroyGoalController
   - Form Requests pra cada um

4. Rotas de Embed (NÃO Inertia — standalone React):
   - GET /embed/{widget:token} → ShowWidgetEmbedController
   - Blade view mínima que carrega entry point Vite separado (widget.tsx)
   - Fundo transparente, sem layout do dashboard
   - Cada tipo tem seu componente React: AlertWidget, QrCodeWidget, etc.

5. Vite config: adicionar entry point `resources/js/widget.tsx` ao array input

Rode Pint e testes ao final.
```

### Prompt 6 — Real-time Broadcasting

```
Leia o arquivo docs/SPEC.md para contexto completo do projeto.

Ative as skills: `laravel-specialist`, `pest-testing`.

Instale e configure broadcasting:

1. Instalar Reverb: composer require laravel/reverb && php artisan install:broadcasting
2. Instalar Echo React: npm install @laravel/echo-react
3. Instalar Horizon: composer require laravel/horizon && php artisan horizon:install

4. Configurar canais:
   - Canal privado: private-streamer.{user_id} (auth via middleware)
   - Canal do widget: widget.{token} (auth via token)

5. Widget JS (standalone React em widget.tsx):
   - Usar `useEcho` do `@laravel/echo-react` para escutar canais privados
   - Usar `useEchoPublic` para canais públicos se necessário
   - Escuta DonationPaid → renderiza alerta
   - Escuta controles (skip, replay, pause)
   - Queue de alertas (FIFO)

6. Alert Controls (controllers invokable):
   - POST /alerts/skip → SkipAlertController
   - POST /alerts/replay → ReplayAlertController
   - PATCH /alerts/auto-play → ToggleAutoPlayController
   - Cada um broadcasta evento de controle no canal do streamer

Redis já está configurado como queue driver.

Rode Pint e testes ao final.
```

### Prompt 7 — Wallet & Withdrawals

```
Leia o arquivo docs/SPEC.md para contexto completo do projeto.

Ative as skills: `inertia-react-development`, `wayfinder-development`, `pest-testing`.

Implemente saldo e saques:

1. Página Saldo e Transações (wallet/index.tsx):
   - Cards: Saldo disponível, Retido, Pendente
   - Lista de transações paginada (tipo, valor, data, descrição)
   - Botão "Sacar" abre modal com:
     - Valor do saque
     - Chave PIX (input)
     - Tipo da chave (select: CPF, email, telefone, aleatória)
   - Histórico de saques com status

2. Controllers invokable:
   - ShowWalletController (show)
   - StoreWithdrawalController (store)
   - Form Request com validação

3. Service: WalletService
   - recordPendingCredit(wallet, amount, description, donation)
   - releasePendingCredit(wallet, amount, description, donation)
   - placeWithdrawalHold(wallet, amount, description, withdrawal)
   - completeWithdrawal(wallet, amount, description, withdrawal)
   - failWithdrawal(wallet, amount, description, withdrawal)
   - Cada operação cria wallet_transaction imutável com deltas e snapshots após o lançamento
   - Use DB::transaction + row lock (`lockForUpdate()`) para operações financeiras
   - CHECK constraints no banco previnem saldo negativo

4. Job: ProcessWithdrawal
   - Move available_cents → held_cents
   - Chama gateway de saque (mock por enquanto)
   - Move held_cents → 0 (completed) ou devolve pra available_cents (failed)

IMPORTANTE: testes são críticos para operações financeiras.

Rode Pint e testes ao final.
```

### Prompt 8 — Integrations

```
Leia o arquivo docs/SPEC.md para contexto completo do projeto.

Ative as skills: `inertia-react-development`, `wayfinder-development`,
`developing-with-fortify`, `pest-testing`.

Implemente a página de integrações:

1. Página (integrations/index.tsx):
   - Cards pra cada plataforma: Twitch, Kick, YouTube,
     StreamElements, StreamLabs
   - Status: conectado/desconectado
   - Botão "Conectar" → OAuth flow
   - Info da conta conectada (nome, foto)
   - Botão "Desconectar"

2. Controllers invokable:
   - ShowIntegrationsController (index)
   - ConnectIntegrationController (redirect → OAuth)
   - IntegrationCallbackController (handle callback)
   - DisconnectIntegrationController (destroy)

3. Tokens encriptados no banco (Eloquent encrypted cast)
   - Persistir segredos em `integrations.credentials`
   - Usar `metadata` JSONB para dados específicos do provider

4. Service: TwitchIntegrationService (primeiro a implementar)

Rode Pint e testes ao final.
```
