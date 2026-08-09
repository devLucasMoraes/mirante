# Produção: recomendações oficiais do time Fastify

## Sempre use um reverse proxy na frente

O time Fastify considera **antipadrão** e má prática expor a app Node.js
diretamente à internet lidando com múltiplos domínios, TLS termination, etc.
Motivos: (1) adiciona complexidade desnecessária diluindo o foco da app; (2)
impede escalabilidade horizontal.

Use HAProxy ou Nginx (ou o load balancer do seu provedor cloud) para:
- terminação TLS
- redirecionar HTTP → HTTPS
- servir múltiplos domínios
- servir arquivos estáticos
- balancear carga entre múltiplas instâncias

Configs de referência completas (HAProxy e Nginx) estão na doc oficial:
https://fastify.dev/docs/latest/Guides/Recommendations/#use-a-reverse-proxy —
resumo do essencial do lado Nginx (proxy_pass básico):

```nginx
upstream fastify_app {
  server 10.10.11.1:80;
  server 10.10.11.2:80;
}
server {
  listen 443 ssl default_server;
  http2 on;
  ssl_certificate /path/to/fullchain.pem;
  ssl_certificate_key /path/to/private.pem;
  location / {
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_pass http://fastify_app;
  }
}
```
> Se o reverse proxy define `X-Forwarded-*`, configure `trustProxy` no
> Fastify para o IP do proxy, ou os headers serão ignorados.

## Causas comuns de degradação de performance

- **Rotas com RegExp ou muitos parâmetros** são caras no router — prefira
  rotas estáticas ou paramétricas simples nos caminhos "quentes".
- **Constraints de rota** (especialmente de versão) degradam o router;
  constraints assíncronas custom devem ser último recurso.
- **Middleware genérico em vez de plugins/hooks nativos** — os adapters de
  middleware do Fastify (`@fastify/middie`) funcionam, mas integrações
  nativas são mais rápidas em paths sensíveis a performance.
- **Sem `schema.response` definido** — sem isso, a serialização JSON não é
  otimizada (ver `plugins-and-lifecycle.md` / SKILL.md, seção de validação).
- **`ajv.customOptions.allErrors: true` em produção** — deixe desligado por
  padrão; só ligue quando precisar de feedback detalhado de validação (ex.:
  API com formulários pesados), nunca em endpoints sensíveis a latência —
  aumenta o trabalho de validação por requisição e facilita ataques de DoS
  em inputs não confiáveis.

## Kubernetes

Fastify escuta em `127.0.0.1` por padrão. O `readinessProbe` do k8s (por
padrão) usa o IP do pod como hostname — se o Fastify não estiver escutando em
`0.0.0.0` (ou um hostname customizado no `readinessProbe.httpGet`), o probe
falha em alcançar a aplicação:

```yaml
readinessProbe:
  httpGet:
    path: /health
    port: 4000
  initialDelaySeconds: 30
  periodSeconds: 30
  timeoutSeconds: 3
  successThreshold: 1
  failureThreshold: 5
```

```js
fastify.listen({ port: 3000, host: '0.0.0.0' }, ...)
```

## Capacity planning

Meça com ferramentas como `k6` ou `autocannon` no seu próprio ambiente antes
de fixar valores — mas como regra prática:
- **Menor latência**: 2 vCPU por instância (o segundo vCPU é majoritariamente
  usado pelo garbage collector e pela threadpool do libuv — isso reduz
  latência e uso de memória, já que o GC roda com mais frequência sem travar
  a thread principal).
- **Maior throughput por vCPU**: usar menos vCPU por instância — rodar com 1
  vCPU é perfeitamente viável.
- Em cenários extremos (ex.: API gateways), há relatos de bom funcionamento
  até com 100m-200m vCPU em Kubernetes.

## Rodando múltiplas instâncias no mesmo processo

É seguro (mesmo sob carga alta) rodar várias instâncias Fastify dentro do
mesmo processo Node.js — por exemplo, expor métricas em uma porta separada
sem acesso público, quando reverse proxy/ingress firewall não é opção. Cada
instância só gera carga proporcional ao tráfego que recebe, mais a memória
que ocupa.
