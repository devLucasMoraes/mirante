// Mirante - config do pm2 para a API (Windows)
// Uso:
//   pm2 start deploy/windows/ecosystem.config.cjs
//   pm2 save
//   pm2-startup install     (auto-start no boot; requer: npm i -g pm2-windows-startup)
//
// Ajuste "cwd" para o caminho real do clone do repo (ex.: C:\mirante).

module.exports = {
  apps: [
    {
      name: "mirante-api",
      cwd: "C:\\mirante",
      script: "apps/api/src/server.ts",
      interpreter: "node",
      env: {
        NODE_ENV: "production",
        LOG_LEVEL: "info",
      },
      max_memory_restart: "512M",
      time: true,
    },
  ],
};