# Project Context

Este projeto e um starter SaaS Laravel usado com agentes multiambiente. Laravel Boost e a fonte principal de guidelines; este arquivo registra apenas decisoes locais que complementam o Boost.

## Stack

- PHP 8.4 via Docker Compose, servico `app`.
- Laravel 13, Fortify, Wayfinder, Spatie Laravel Permission e Laravel Boost.
- Inertia Laravel 3, `@inertiajs/react` 3, React 19 e Tailwind CSS 4.
- Filament 5 e Livewire 4.
- Pest 4 para testes e Laravel Pint para formatacao PHP.
- `lorisleiva/laravel-actions` para Actions reutilizaveis e multi-contexto.
- `nunomaduro/essentials` para defaults mais estritos: strict models, datas imutaveis, safe console, prevent stray requests em testes e Pint opinativo.

## Ambiente Local

- Rode comandos PHP/Composer/Artisan dentro do container:
  - `docker compose exec app php artisan ...`
  - `docker compose exec -T app composer ...`
  - `docker compose exec app vendor/bin/pint --dirty --format agent`
- O MCP do Laravel Boost deve chamar `php artisan boost:mcp` a partir do diretório do projeto/container, via Docker Compose.
- O host WSL pode ler arquivos, mas o runtime do projeto e Docker Compose.

## Arquitetura Local

- Controllers novos devem ser invokable, com uma unica action em `__invoke`.
- Organize controllers por dominio: `App\Http\Controllers\{Domain}\{Action}Controller`.
- Registre rotas apontando para a classe: `Route::get('/courses/{course}', ShowCourseController::class)->name('courses.show');`.
- Controllers de `Settings` existentes sao legado multi-method e serao migrados gradualmente.
- Use `app/Integrations/{Provider}` para clients/adapters de APIs externas.
- Nao coloque chamadas HTTP diretas a APIs externas em Services, Controllers, Jobs ou Filament actions.
- Services e Actions orquestram casos de uso; Integrations encapsulam transporte HTTP, autenticacao, payloads, retries e erros do provider.
- Use `app/Actions/{Domain}` para logica reutilizavel por controller, job, listener, command, Filament action ou outro fluxo.
- Actions novas devem usar `Lorisleiva\Actions\Concerns\AsAction` quando fizer sentido expor `handle`, `asController`, `asJob`, `asListener` ou `asCommand`.
- Nao transforme toda rota em Action automaticamente. Para fluxo HTTP/Inertia simples, prefira controller invokable fino chamando Actions/Services quando houver logica reutilizavel.

## Frontend e Rotas

- Pages Inertia vivem em `resources/js/pages`.
- Use Wayfinder para chamadas frontend -> backend; evite URLs hardcoded em React.
- Mantenha textos de UI e labels reutilizaveis em arquivos de traducao quando o texto for compartilhado ou aparecer em Filament.

## Filament

- Use comandos Artisan do Filament para criar resources, pages e relation managers.
- Em Filament v5, use namespaces corretos do Boost: actions em `Filament\Actions`, schemas em `Filament\Schemas`, icons via `Filament\Support\Icons\Heroicon`.
- Prefira resources limpos que delegam forms, infolists e tables para classes dedicadas quando o resource ficar grande.

## Testes e Qualidade

- Toda mudanca de comportamento deve ter teste Pest.
- Rode o menor conjunto de testes suficiente durante desenvolvimento.
- Para PHP alterado, rode Pint no container antes de finalizar.
- `config/essentials.php` faz parte do template e deve ser tratado como fonte de defaults do framework.
- Mantenha os defaults do Essentials habilitados salvo motivo explicito: strict models, auto eager loading, immutable dates, safe console, fake sleep, prevent stray requests e force HTTPS somente em production.
- O `pint.json` e o `rector.php` seguem os presets do Essentials; espere `declare(strict_types=1)`, classes finais por padrao, comparacoes estritas, imports ordenados, funcoes `mb_*` e refactors conservadores orientados a tipos/qualidade.
- Respostas para o usuario devem ser em pt-BR, concisas por padrao.
- Comentarios de codigo devem ser minimos e em ingles quando forem realmente necessarios.
