# Laravel Pint

Consulte `PROJECT.md` primeiro. Este guideline existe apenas para reforcar o padrao local do projeto para formatacao PHP.

## Fonte de Verdade

- `pint.json` segue o preset publicado pelo `nunomaduro/essentials`.
- Nao copie configuracoes antigas para este arquivo; ajuste `pint.json` quando a regra de formatacao precisar mudar.
- Espere as regras atuais do Essentials: `declare(strict_types=1)`, classes finais por padrao, comparacoes estritas, imports ordenados, `mb_*` e outras regras opinativas.

## Comando Local

Rode Pint dentro do container Docker Compose:

```bash
docker compose exec app vendor/bin/pint --dirty --format agent
```

Use esse comando antes de finalizar qualquer mudanca em PHP. Nao use `vendor/bin/pint` direto no host WSL como instrucao padrao deste projeto.

## Quando Rodar

- Depois de criar ou alterar arquivos PHP.
- Depois de rodar Rector ou qualquer gerador que altere PHP.
- Antes dos testes finais quando o diff inclui PHP.

## O Que Nao Fazer

- Nao instalar Laravel Pint de novo; ele ja esta em `composer.json`.
- Nao substituir o preset do Essentials por snippets manuais copiados de guidelines antigas.
- Nao rodar `pint --test` para corrigir formatacao; use o comando com `--dirty --format agent`.
