# Refresh de token — exemplo completo

Padrão para renovar silenciosamente um access token expirado (401) e repetir a
requisição original, evitando disparar múltiplas chamadas de refresh em paralelo
quando várias requisições falham ao mesmo tempo.

```js
import axios from "axios";

const api = axios.create({ baseURL: "https://api.example.com" });

// Controla se um refresh já está em andamento, para não disparar vários em paralelo
let isRefreshing = false;
let failedQueue = [];

const processQueue = (error, token = null) => {
  failedQueue.forEach((prom) => {
    if (error) {
      prom.reject(error);
    } else {
      prom.resolve(token);
    }
  });
  failedQueue = [];
};

api.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;

    if (error.response?.status === 401 && !originalRequest._retry) {
      if (isRefreshing) {
        // Enfileira a requisição até o refresh terminar
        return new Promise((resolve, reject) => {
          failedQueue.push({ resolve, reject });
        })
          .then((token) => {
            originalRequest.headers["Authorization"] = `Bearer ${token}`;
            return api(originalRequest);
          })
          .catch((err) => Promise.reject(err));
      }

      originalRequest._retry = true;
      isRefreshing = true;

      try {
        const { data } = await axios.post("/auth/refresh", {
          refreshToken: localStorage.getItem("refresh_token"),
        });

        const newToken = data.access_token;
        localStorage.setItem("access_token", newToken);
        api.defaults.headers.common["Authorization"] = `Bearer ${newToken}`;

        processQueue(null, newToken);
        return api(originalRequest);
      } catch (refreshError) {
        processQueue(refreshError, null);
        // Redireciona para login ou emite um evento
        localStorage.removeItem("access_token");
        window.location.href = "/login";
        return Promise.reject(refreshError);
      } finally {
        isRefreshing = false;
      }
    }

    return Promise.reject(error);
  }
);
```

## Pontos-chave do padrão

- `originalRequest._retry` evita loop infinito de refresh (marca que já tentou uma vez).
- `isRefreshing` + `failedQueue` evitam que N requisições que falharam ao mesmo tempo
  disparem N chamadas de refresh — só a primeira dispara; as demais esperam na fila.
- Em caso de falha no refresh, limpar o token e redirecionar para login (ou emitir
  um evento de logout, dependendo da arquitetura da aplicação).
