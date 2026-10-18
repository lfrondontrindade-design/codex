# Google Maps Scraper Kit — instalação nesta nuvem

Origem: https://github.com/vzbaggio/google-maps-scraper-kit
Commit: `7dcf76c5a008afce6acfb54d72d45a762ee5f551`.
Pasta: `/workspace/google-maps-scraper-kit`.

Esta instalação foi executada no ambiente Linux de nuvem do Codex, não no computador pessoal do usuário. README, SETUP, CLAUDE.md, Compose e script Python foram consultados.

## Componentes

Docker 28.4.0, Compose 2.40.3, Git e Python 3 já disponíveis. Nenhum pacote de sistema, pip ou npm adicional foi necessário. Frontend estático: não exige compilação. Instaladas as imagens oficiais do scraper e Nginx, com persistência em volumes Docker.

Uma configuração externa preserva o Compose original, usa o motor oficial já instalado por digest e troca `-web` pela inicialização web atual `-data-folder /gmapsdata`. O Nginx também foi fixado por digest. Porta do kit: 8081, apenas loopback, para coexistir com o scraper anterior em 8080. Permissões de leitura dos arquivos estáticos foram ajustadas para o usuário do Nginx. Arquivos rastreados do projeto original permanecem sem alterações.

## Iniciar e parar neste ambiente

```bash
bash /workspace/codex/ferramentas/google-maps-scraper-kit/iniciar.sh
```

```bash
docker compose -f /workspace/google-maps-scraper-kit/docker-compose.yml -f /workspace/codex/ferramentas/google-maps-scraper-kit/compose.override.yaml stop
```

## Uso pelo terminal

Após liberar os destinos de rede:

```bash
cd /workspace/google-maps-scraper-kit
SCRAPER_BASE_URL=http://127.0.0.1:8081 python3 scripts/scrape.py "cafeterias em São Paulo" -23.5505 -46.6333 --depth 1 --lang pt --no-email --max-time 60 --out /workspace/gmaps-validation/cafeterias.csv
```

Para outra cidade, informe suas coordenadas ou use `--city "Cidade, Estado"` no lugar das coordenadas; isso requer acesso ao Nominatim. `--no-email` limita o teste a listagens, sem visitas a sites para extrair emails.

## Interface web

O serviço escuta internamente na porta 8081: `/` mostra a interface com mapa, `/painel` mostra o painel, `/classic` é a interface original. O navegador do computador pessoal não acessa automaticamente esse endereço da nuvem. A interface de onboarding não oferece um preview clicável suportado. Não foi publicada uma URL externa.

Na interface, preencha o tipo de empresa e a cidade, comece com profundidade baixa, execute a busca e exporte os resultados. Mapa e geocodificação precisam dos serviços externos indicados abaixo.

## Validação de 18/10/2026

HTTP 200 e conteúdo esperado em `/`, `/painel`, `/classic`, `/app/app.js` e `/api/v1/jobs`. O script Python foi exercitado com uma consulta a MASP São Paulo, depth 1, sem email, max_time 30. O fluxo criou o job, consultou seu status e baixou um CSV sem registros. Log do navegador: `net::ERR_TUNNEL_CONNECTION_FAILED`. Requisições independentes confirmaram HTTP 403 do proxy para Google, Nominatim, tiles OpenStreetMap e CDN Leaflet.

Portanto, instalação e comunicação local verificadas; **coleta de empresas e renderização completa do mapa não validadas**. O backend marca o job como `ok` mesmo quando a navegação falha: verificar logs e linhas reais no CSV.

Configuração de rede pendente: `www.google.com`, `nominatim.openstreetmap.org`, `tile.openstreetmap.org`, `cdnjs.cloudflare.com`, `fonts.googleapis.com`, `fonts.gstatic.com`. Outros domínios podem ser identificados durante nova validação. O usuário deve revisar/salvar as mudanças nas configurações e publicar o ambiente; salvar um rascunho não aplica a mudança.

Nenhuma chave de API ou serviço pago foi necessário para instalar. Nenhuma lista comercial foi coletada com sucesso.
