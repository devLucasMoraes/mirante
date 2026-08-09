import jsonServer from "json-server";
import jwt from "jsonwebtoken";
import { randomUUID } from "node:crypto";

const server = jsonServer.create();
const router = jsonServer.router("db.json");
const middlewares = jsonServer.defaults();

const ACCESS_SECRET = "access_secret_dev";
const REFRESH_SECRET = "refresh_secret_dev";

const ACCESS_EXPIRES_IN = "15m";
const REFRESH_EXPIRES_IN = "7d";

const AUTH_PREFIX = "/api/auth";

let refreshTokens = [];

server.use(middlewares);
server.use(jsonServer.bodyParser);

function signTokens(user) {
  const payload = { id: user.id, email: user.email, name: user.name };
  const accessToken = jwt.sign(payload, ACCESS_SECRET, {
    expiresIn: ACCESS_EXPIRES_IN,
  });
  const refreshToken = jwt.sign(payload, REFRESH_SECRET, {
    expiresIn: REFRESH_EXPIRES_IN,
  });
  refreshTokens.push(refreshToken);
  return { accessToken, refreshToken, user: payload };
}

server.post(`${AUTH_PREFIX}/login`, (req, res) => {
  const { email, password } = req.body ?? {};
  const user = router.db.get("users").find({ email, password }).value();

  if (!user) {
    return res.status(401).json({ message: "Credenciais invalidas" });
  }

  res.json(signTokens(user));
});

server.post(`${AUTH_PREFIX}/signup`, (req, res) => {
  const { email, password } = req.body ?? {};

  if (!email || !password) {
    return res.status(400).json({ message: "Informe e-mail e senha" });
  }

  if (router.db.get("users").find({ email }).value()) {
    return res.status(409).json({ message: "E-mail ja cadastrado" });
  }

  const user = {
    id: `usr_${randomUUID()}`,
    name: email
      .split("@")[0]
      .replace(/[._-]+/g, " ")
      .trim(),
    email,
    password,
  };

  router.db.get("users").push(user).write();
  res.status(201).json(signTokens(user));
});

server.post(`${AUTH_PREFIX}/refresh`, (req, res) => {
  const { refreshToken } = req.body ?? {};

  if (!refreshToken) {
    return res.status(401).json({ message: "Refresh token ausente" });
  }
  if (!refreshTokens.includes(refreshToken)) {
    return res.status(403).json({ message: "Refresh token invalido" });
  }

  jwt.verify(refreshToken, REFRESH_SECRET, (err, payload) => {
    if (err) {
      return res.status(403).json({ message: "Refresh token expirado ou invalido" });
    }

    const accessToken = jwt.sign(
      { id: payload.id, email: payload.email, name: payload.name },
      ACCESS_SECRET,
      { expiresIn: ACCESS_EXPIRES_IN },
    );

    res.json({ accessToken });
  });
});

server.post(`${AUTH_PREFIX}/logout`, (req, res) => {
  const { refreshToken } = req.body ?? {};
  refreshTokens = refreshTokens.filter((token) => token !== refreshToken);
  res.status(204).end();
});

server.use((req, res, next) => {
  if (req.path.startsWith(AUTH_PREFIX)) {
    return next();
  }

  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ message: "Token nao fornecido" });
  }

  const token = authHeader.split(" ")[1];
  jwt.verify(token, ACCESS_SECRET, (err, payload) => {
    if (err) {
      return res.status(401).json({ message: "Token invalido ou expirado" });
    }
    req.user = payload;
    next();
  });
});

server.use("/api", router);

server.listen(3333, () => {
  console.log("Mock server com JWT rodando em http://localhost:3333/api");
});