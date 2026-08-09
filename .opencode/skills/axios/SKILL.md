---
name: axios
description: Guia de uso da biblioteca axios (cliente HTTP para JS/TS baseado em Promises) — instalação, requisições básicas, tipagem TypeScript, instâncias, interceptors e autenticação (Bearer/JWT, Basic Auth, API keys, refresh de token, cookies). Use esta skill sempre que o usuário pedir para criar, revisar ou depurar código que faça chamadas HTTP com axios, configurar um cliente de API, implementar autenticação em requisições, ou migrar de fetch/outra lib para axios — mesmo que o usuário não mencione "axios" explicitamente e apenas peça para "consumir uma API" ou "fazer uma requisição HTTP" em um projeto JS/TS.
---

# Axios

Guia de referência rápida para trabalhar com **axios**, o cliente HTTP baseado em Promises para browser e Node.js. Cobre os fundamentos necessários para instalar, configurar, tipar e autenticar requisições.

## Quando usar esta skill

- Criar um cliente HTTP (`axios.create`) para um projeto novo
- Escrever ou revisar chamadas `GET`/`POST`/`PUT`/`DELETE` etc.
- Tipar requisições e respostas em TypeScript
- Implementar autenticação (Bearer/JWT, Basic Auth, API key, refresh token, cookies)
- Depurar erros de requisição, timeout ou CORS/credentials
- Comparar axios com `fetch` nativo

Para tópicos mais avançados não cobertos aqui (interceptors avançados, cancelamento, retry, adapters, multipart/form-data, rate limiting), consulte `references/advanced-topics.md` — ele lista os links exatos da documentação oficial para cada assunto.

Se o usuário estiver **migrando de v0.x para v1.x**, ou revisando código antigo que pode ter breaking changes (interceptors, headers, serialização de params, `FormData`, URLs malformadas), consulte `references/upgrade-guide.md` antes de responder.

## Instalação

```bash
npm install axios
# ou: pnpm install axios / yarn add axios / bun add axios / deno install npm:axios
```

Importação:

```js
import axios from "axios";
// ou, se necessário nomear a importação:
import axios, { isCancel, AxiosError } from "axios";
```

Com `require` (CommonJS), **apenas o default export está disponível**:

```js
const axios = require("axios");
```

## Requisição básica

```js
import axios from "axios";

const response = await axios.get("https://jsonplaceholder.typicode.com/posts/1");
console.log(response.data);
```

**Sempre configure um `timeout`** em produção — sem ele, uma requisição travada pode ficar pendurada indefinidamente:

```js
const response = await axios.get("https://example.com/data", {
  timeout: 5000, // 5 segundos
});
```

Métodos disponíveis como atalho: `axios.get`, `axios.post`, `axios.put`, `axios.delete`, `axios.patch`, etc. Ou use `axios.request({ method, url, ... })` para qualquer verbo.

## Criando uma instância configurada

Para projetos reais, **sempre crie uma instância** com `baseURL` e headers padrão em vez de chamar `axios` diretamente em todo lugar:

```js
const api = axios.create({
  baseURL: "https://api.example.com",
  timeout: 5000,
});
```

## Tipagem em TypeScript

axios já vem com tipos prontos — não é preciso instalar `@types/axios`.

```ts
import axios from "axios";
import type { AxiosRequestConfig, AxiosResponse, AxiosError, AxiosInstance } from "axios";

type Post = { userId: number; id: number; title: string; body: string };

// Tipar a resposta com generic
const response = await axios.get<Post>("https://jsonplaceholder.typicode.com/posts/1");
console.log(response.data.title); // TS sabe que é string

// Função tipada
const getPost = async (id: number): Promise<Post> => {
  const response = await axios.get<Post>(`https://jsonplaceholder.typicode.com/posts/${id}`);
  return response.data;
};

// Instância tipada
const api: AxiosInstance = axios.create({ baseURL: "https://api.example.com" });
```

**Interceptors em TS**: use `InternalAxiosRequestConfig` (não `AxiosRequestConfig`) no interceptor de request:

```ts
import type { InternalAxiosRequestConfig, AxiosResponse } from "axios";

api.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  config.headers.set("Authorization", `Bearer ${getToken()}`);
  return config;
});
```

**Tipando erros** com `axios.isAxiosError()`:

```ts
import axios, { AxiosError } from "axios";

type ApiError = { message: string; code: number };

try {
  await axios.get("/api/protected-resource");
} catch (error) {
  if (axios.isAxiosError<ApiError>(error)) {
    console.error(error.response?.data.message);
    console.error(error.response?.status);
  } else {
    throw error;
  }
}
```

Notas de `tsconfig.json`: prefira `"moduleResolution": "node16"` (requer TS ≥ 4.7). Se compilar para CJS e não puder usar `node16`, ative `"esModuleInterop": true`.

## Autenticação

### Bearer token (JWT) — abordagem recomendada

Use um **request interceptor** na instância, para o token ser lido a cada chamada (nunca "hardcoded" uma vez só):

```js
const api = axios.create({ baseURL: "https://api.example.com" });

api.interceptors.request.use((config) => {
  const token = localStorage.getItem("access_token");
  if (token) {
    config.headers.set("Authorization", `Bearer ${token}`);
  }
  return config;
});
```

### HTTP Basic Auth

Use a opção `auth` — axios codifica as credenciais e monta o header automaticamente. **Não use `auth` para Bearer/API key**, apenas para Basic:

```js
const response = await axios.get("https://api.example.com/data", {
  auth: { username: "myUser", password: "myPassword" },
});
```

### API keys

Como header ou query param, conforme a API exigir:

```js
// Header
const api = axios.create({
  baseURL: "https://api.example.com",
  headers: { "X-API-Key": "your-api-key-here" },
});

// Query param
const response = await axios.get("https://api.example.com/data", {
  params: { apiKey: "your-api-key-here" },
});
```

### Refresh de token (401 → renovar → repetir a requisição)

Implementado em um **response interceptor**, com uma fila para evitar múltiplas chamadas de refresh em paralelo. Ver `references/token-refresh.md` para o exemplo completo comentado — é o padrão mais complexo desta skill e vale a pena copiar o snippet integralmente ao invés de reescrever do zero.

### Autenticação por cookie (sessão)

```js
const api = axios.create({
  baseURL: "https://api.example.com",
  withCredentials: true, // envia cookies em requisições cross-origin
});
```

⚠️ Requer que o servidor responda com `Access-Control-Allow-Credentials: true` e um `Access-Control-Allow-Origin` **não-wildcard** (específico).

## Principais features do axios (para saber quando recomendá-lo)

- Isomórfico: mesma API no browser e no Node.js
- Suporte de primeira classe ao adapter Fetch (opcional, mesma API do XHR)
- Promise API nativa, `async`/`await` funciona direto
- Intercepta e transforma request/response
- `AbortController` para cancelamento
- `timeout` configurável
- Serialização de query params (inclusive nested)
- Serialização automática do body: JSON, `multipart/form-data`, `x-www-form-urlencoded`
- Parsing automático de JSON na resposta
- Progress capturing (browser e Node) com velocidade/tempo restante
- Proteção contra XSRF no client-side

## Boas práticas ao gerar código com axios

1. **Sempre criar uma instância** (`axios.create`) com `baseURL` em vez de repetir a URL completa em cada chamada.
2. **Sempre definir `timeout`** explicitamente.
3. **Autenticação via interceptor**, nunca hardcoded em cada requisição individual.
4. Para Bearer/API key, usar header customizado — **não** a opção `auth` (reservada para Basic Auth).
5. Em TypeScript, tipar a resposta com generics (`axios.get<Post>(...)`) e usar `axios.isAxiosError()` para tratar erros com segurança de tipo.
6. Tratar erros verificando `error.response?.status` — não assumir que toda falha é erro de rede.
7. Ao ver código com `axios.defaults.headers.common[...]`, `import { axios } from "axios"` ou `AxiosRequestConfig` em interceptor de request — sinal de código v0.x desatualizado. Ver `references/upgrade-guide.md` para o padrão correto em v1.x.
8. Sempre usar URLs bem formadas (`https://...` com `//`) — desde v1.19.0, URLs sem `//` após o protocolo são rejeitadas com `ERR_INVALID_URL`.
