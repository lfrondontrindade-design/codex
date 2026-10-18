# Google Maps Scraper

Instalado neste ambiente usando a imagem Docker oficial de https://github.com/gosom/google-maps-scraper.

## Iniciar

```bash
bash /workspace/codex/ferramentas/google-maps-scraper/iniciar.sh
```

A interface e a API escutam apenas no endereço local, porta 8080. Dados persistem em `/workspace/gmaps-data`. Para parar: `docker stop codex-google-maps-scraper`.

A imagem foi fixada pelo digest no script. Para reinstalar a imagem:

```bash
docker pull gosom/google-maps-scraper@sha256:e205c02913c5a69c16fc2094b8e5b194a2f655166d2c1126d50548d216e6b1b2
```

## Validação em 18/10/2026

- Imagem oficial baixada com verificações de integridade do Docker.
- Interface retornou HTML; API `/api/v1/jobs` respondeu com HTTP 200.
- Navegador Playwright iniciou.
- Uma única consulta por MASP São Paulo foi tentada com concorrência 1. Falhou ao abrir Google Maps: `net::ERR_TUNNEL_CONNECTION_FAILED`. Uma consulta HTTP independente confirmou `CONNECT tunnel failed, response 403` para `www.google.com`.
- O CSV ficou vazio: coleta ainda não validada. O processo terminou com código zero apesar da falha, portanto não usar apenas o código de saída como prova de sucesso.

A configuração de rede precisa permitir `www.google.com`; outros destinos necessários devem ser diagnosticados ao repetir o teste. Não há necessidade demonstrada de API key ou proxy pago. Não foi feita coleta em massa.

O código-fonte original está em `/workspace/google-maps-scraper`, sem modificações. Este diretório de instruções não contém uma cópia do software nem os dados de resultados.
