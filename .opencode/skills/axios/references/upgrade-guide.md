# Upgrade guide — breaking changes relevantes

Resumo das mudanças que mais geram bugs silenciosos ao migrar ou revisar código axios.

## v1.19.0

### URLs malformadas agora são rejeitadas

`url` ou `baseURL` do tipo `http:`/`https:` sem `//` após o protocolo passam a ser
rejeitados (ex.: `https:example.com` ou `https:/example.com`). Use sempre uma URL
bem formada: `https://example.com`. O erro resultante é um `AxiosError` com código
`ERR_INVALID_URL`. Mudança de segurança intencional — evita que normalização de URL
malformada contorne `baseURL` ou allowlists de URL.

### Erros síncronos em request interceptor

Se um request interceptor **síncrono** lança um erro, axios chama o handler de
rejeição pareado e para os demais interceptors de request. Se esse handler de
rejeição retornar normalmente (sem lançar/rejeitar), o erro é tratado como resolvido
e a requisição segue com o último config válido — **o valor retornado pelo handler
não vira o config da requisição**. Se a validação deve bloquear o disparo da
requisição, omita o rejection handler ou lance/retorne uma Promise rejeitada dele.
Erros terminais continuam passando pelos interceptors de rejeição de response.

## v0.x → v1.x

### Import statement

```diff
- import { axios } from "axios";
+ import axios from "axios";
```

### Sistema de interceptors

Em v1.x, o parâmetro `config` do interceptor de request é tipado como
`InternalAxiosRequestConfig`, não mais `AxiosRequestConfig`:

```diff
- axios.interceptors.request.use((config: AxiosRequestConfig) => {
+ axios.interceptors.request.use((config: InternalAxiosRequestConfig) => {
    return config;
  });
```

### Formato dos request headers

A propriedade `common` foi removida da estrutura de headers:

```diff
- if (request.headers?.common?.Authorization) {
-       request.headers.common.Authorization = ...
+ if (request.headers?.Authorization) {
+       request.headers.Authorization = ...
```

Headers padrão que antes ficavam em `common`, `get`, `post` etc. agora vão
diretamente em `axios.defaults.headers`:

```diff
- axios.defaults.headers.common["Accept"] = "application/json";
+ axios.defaults.headers["Accept"] = "application/json";
```

### Multipart form data

Se a requisição inclui um payload `FormData`, o header `Content-Type:
multipart/form-data` agora é setado automaticamente. Remova qualquer header manual
para evitar duplicação:

```diff
- axios.post("/upload", formData, {
-   headers: { "Content-Type": "multipart/form-data" },
- });
+ axios.post("/upload", formData);
```

Se você setar explicitamente `Content-Type: application/json`, axios agora
serializa o `data` para JSON automaticamente.

### Serialização de parâmetros (mudança importante)

- **`params` agora são percent-encoded por padrão.** Se o backend espera colchetes
  "crus" (estilo `qs`), configure um serializer customizado:

  ```js
  import qs from 'qs';

  axios.create({
    paramsSerializer: {
      serialize: (params) => qs.stringify(params, { arrayFormat: 'brackets' }),
    },
  });
  ```

- **Objetos aninhados em `params`** agora são serializados com notação de colchetes
  (`foo[bar]=1`) em vez de notação de ponto. Se o backend espera notação de ponto,
  use um serializer customizado.

- **`null` vs `undefined` em params**: `null` agora é serializado como string vazia;
  `undefined` é omitido por completo da query string.

Para as opções completas de serialização, ver `references/advanced-topics.md`
(link para `request-config`).

### Internals não são mais exportados

Apenas a API pública do axios deve ser usada — internals deixaram de ser
exportados. Consultar a referência pública da API (ver `references/advanced-topics.md`).

### Request config

O objeto de request config mudou entre v0.x e v1.x — para o shape atual completo,
ver a página de `request-config` listada em `references/advanced-topics.md`.
