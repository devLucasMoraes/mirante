---
name: react-router-v8-declarative
description: >-
  Use esta skill sempre que o usuário estiver trabalhando com React Router v8
  no "Declarative Mode" (sem framework, sem data router) — instalando o pacote
  react-router, configurando <BrowserRouter>/<Routes>/<Route>, criando rotas
  aninhadas, rotas de layout, rotas index, segmentos dinâmicos/opcionais/splats,
  navegando com <Link>/<NavLink>/useNavigate, ou lendo params/query
  string/location com useParams, useSearchParams, useLocation. Não use para
  Framework Mode (routes.ts, loaders/actions) nem para Data Mode
  (createBrowserRouter) — essa skill cobre apenas o Declarative Mode.
---

# React Router v8.3.0 — Declarative Mode

Guia de referência rápida para o modo declarativo do React Router (a forma "clássica" de usar o React Router, sem framework e sem data router). Baseado na documentação oficial (reactrouter.com/start/declarative/*) para a versão 8.3.0.

Existem 3 modos no React Router v8: Framework, Data e Declarative. Esta skill cobre apenas Declarative. Se o projeto usa routes.ts, createBrowserRouter, loaders ou actions, esta não é a skill certa — nesse caso avise o usuário que o modo é outro.

## Quando usar Declarative Mode

Use quando o app é uma SPA simples renderizada no cliente, sem necessidade de loaders/actions do React Router, sem SSR do próprio framework, e você só quer `<Routes>/<Route>` decidindo o que renderizar.

## 1. Instalação

```bash
# ou npm, yarn, etc., dependendo do gerenciador de pacotes
pnpm add react-router
```

Envolva a aplicação com `<BrowserRouter>`:

```jsx
import React from "react";
import ReactDOM from "react-dom/client";
import { BrowserRouter } from "react-router";
import App from "./app";

const root = document.getElementById("root");

ReactDOM.createRoot(root).render(
  <BrowserRouter>
    <App />
  </BrowserRouter>,
);
```

## 2. Configurando rotas

Rotas são configuradas renderizando `<Routes>` e `<Route>`, que acoplam segmentos de URL a elementos de UI.

```jsx
import { Routes, Route } from "react-router";

<Routes>
  <Route index element={<Home />} />
  <Route path="about" element={<About />} />

  <Route element={<AuthLayout />}>
    <Route path="login" element={<Login />} />
    <Route path="register" element={<Register />} />
  </Route>

  <Route path="concerts">
    <Route index element={<ConcertsHome />} />
    <Route path=":city" element={<City />} />
    <Route path="trending" element={<Trending />} />
  </Route>
</Routes>
```

### Rotas aninhadas (nested routes)

O path do pai é incluído automaticamente no filho. Isso cria `/dashboard` e `/dashboard/settings`:

```jsx
<Routes>
  <Route path="dashboard" element={<Dashboard />}>
    <Route index element={<Home />} />
    <Route path="settings" element={<Settings />} />
  </Route>
</Routes>
```

As rotas filhas renderizam através do `<Outlet />` no componente pai:

```jsx
import { Outlet } from "react-router";

export default function Dashboard() {
  return (
    <div>
      <h1>Dashboard</h1>
      {/* será <Home/> ou <Settings/> */}
      <Outlet />
    </div>
  );
}
```

### Rotas de layout (layout routes)

`<Route>` sem `path` cria aninhamento para os filhos, mas não adiciona segmento à URL — serve só para envolver as rotas filhas num layout comum.

```jsx
<Routes>
  <Route element={<MarketingLayout />}>
    <Route index element={<MarketingHome />} />
    <Route path="contact" element={<Contact />} />
  </Route>

  <Route path="projects">
    <Route index element={<ProjectsHome />} />
    <Route element={<ProjectsLayout />}>
      <Route path=":pid" element={<Project />} />
      <Route path=":pid/edit" element={<EditProject />} />
    </Route>
  </Route>
</Routes>
```

### Rotas index

Renderizam no `<Outlet/>` do pai na URL do próprio pai (como uma rota filha padrão). Usam a prop `index`. Rotas index não podem ter filhos — se precisar disso, use uma rota de layout.

```jsx
<Routes>
  <Route path="/" element={<Root />}>
    <Route index element={<Home />} />

    <Route path="dashboard" element={<Dashboard />}>
      <Route index element={<DashboardHome />} />
      <Route path="settings" element={<Settings />} />
    </Route>
  </Route>
</Routes>
```

### Prefixo de rota (route prefix)

`<Route path>` sem `element` adiciona um prefixo de path aos filhos sem introduzir um layout pai novo.

```jsx
<Route path="projects">
  <Route index element={<ProjectsHome />} />
  <Route element={<ProjectsLayout />}>
    <Route path=":pid" element={<Project />} />
    <Route path=":pid/edit" element={<EditProject />} />
  </Route>
</Route>
```

### Segmentos dinâmicos

Um segmento que começa com `:` vira dinâmico. O valor casado fica disponível via params/useParams.

```jsx
<Route path="teams/:teamId" element={<Team />} />
```

```jsx
import { useParams } from "react-router";

export default function Team() {
  let params = useParams();
  // params.teamId
}
```

Pode ter múltiplos segmentos dinâmicos:

```jsx
<Route path="/c/:categoryId/p/:productId" element={<Product />} />
```

⚠️ Garanta que os nomes de segmentos dinâmicos numa mesma path sejam únicos — o valor mais à direita sobrescreve os anteriores no objeto params.

### Segmentos opcionais

Adicione `?` no final do segmento.

```jsx
<Route path=":lang?/categories" element={<Categories />} />
<Route path="users/:userId/edit?" element={<User />} />
```

### Splats (catchall / star)

Se a path termina em `/*`, casa com qualquer coisa depois da `/`, incluindo outras `/`.

```jsx
<Route path="files/*" element={<File />} />
```

```jsx
let params = useParams();
let filePath = params["*"];
// ou, renomeando via destructuring:
let { "*": splat } = useParams();
```

## 3. Navegação

### Link

Use quando o link não precisa de estado ativo:

```jsx
import { Link } from "react-router";

<p>
  Você foi desconectado. <Link to="/login">Entrar novamente</Link>
</p>
```

### NavLink

Use para links de navegação que precisam mostrar estado ativo. Quando ativo, ganha automaticamente a classe `.active`.

```jsx
import { NavLink } from "react-router";

<nav>
  <NavLink to="/" end>Home</NavLink>
  <NavLink to="/trending" end>Trending Concerts</NavLink>
  <NavLink to="/concerts">All Concerts</NavLink>
  <NavLink to="/account">Account</NavLink>
</nav>
```

CSS:

```css
a.active {
  color: red;
}
```

Também tem callbacks em `className`, `style` e `children` com o estado ativo:

```jsx
// className
<NavLink to="/messages" className={({ isActive }) => isActive ? "text-red-500" : "text-black"}>
  Messages
</NavLink>

// style
<NavLink to="/messages" style={({ isActive }) => ({ color: isActive ? "red" : "black" })}>
  Messages
</NavLink>

// children
<NavLink to="/message">
  {({ isActive }) => (
    <span className={isActive ? "active" : ""}>
      {isActive ? "👉" : ""} Tasks
    </span>
  )}
</NavLink>
```

### useNavigate

Para navegar sem interação direta do usuário (ex: após submit de form, logout por inatividade, timers de quiz). Para navegação normal, prefira Link/NavLink (dão suporte melhor a teclado, acessibilidade, abrir em nova aba, menu de contexto do botão direito, etc).

```jsx
import { useNavigate } from "react-router";

export function LoginPage() {
  let navigate = useNavigate();

  return (
    <>
      <MyHeader />
      <MyLoginForm onSuccess={() => navigate("/dashboard")} />
      <MyFooter />
    </>
  );
}
```

## 4. Valores da URL

### Route params

Valores parseados de um segmento dinâmico, via `useParams`:

```jsx
<Route path="/concerts/:city" element={<City />} />
```

```jsx
import { useParams } from "react-router";

function City() {
  let { city } = useParams();
  let data = useFakeDataLibrary(`/api/v2/cities/${city}`);
}
```

### Search params (query string)

Valores depois do `?` na URL, via `useSearchParams` — retorna uma instância de `URLSearchParams`:

```jsx
function SearchResults() {
  let [searchParams] = useSearchParams();
  return (
    <p>Você buscou por <i>{searchParams.get("q")}</i></p>
  );
}
```

### Location object

`useLocation` retorna um objeto `location` customizado:

```jsx
function useAnalytics() {
  let location = useLocation();
  useEffect(() => {
    sendFakeAnalytics(location.pathname);
  }, [location]);
}

function useScrollRestoration() {
  let location = useLocation();
  useEffect(() => {
    fakeRestoreScroll(location.key);
  }, [location]);
}
```

## Checklist rápido ao gerar/revisar código

- Importar sempre do pacote `react-router` (não `react-router-dom` — no v8 declarative, react-router já inclui tudo)
- App envolvido em `<BrowserRouter>` uma única vez, no topo
- Rotas com filhos que têm `element` E `path` → nested route normal
- Rotas com filhos que não têm `path` → layout route (agrupa sem mudar URL)
- Rotas com filhos que não têm `element` → apenas prefixo de path
- Uso de `index` só em rotas sem filhos
- Nomes de parâmetros dinâmicos (`:algo`) únicos dentro da mesma árvore de path
- `useNavigate` só para navegação programática (não como substituto de `<Link>` em cliques normais)