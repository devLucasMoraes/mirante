# Infraestrutura e acesso — Wingraphex ERP

## Rede
### 2026-08-10 — Ping para 192.168.1.16 funciona
- **O que foi testado:** ping ICMP para o host 192.168.1.16
- **Resultado:** funciona
- **Como reproduzir:** `ping -c 4 -W 2 192.168.1.16`
- **Observações:** 4/4 pacotes recebidos, 0% de perda, RTT ~0.6-0.8ms. TTL 127 indica host Windows
  na mesma rede local.

### 2026-08-10 — Varredura de portas em 192.168.1.16
- **O que foi testado:** conectividade TCP nas portas 22, 80, 443, 1433, 3306, 3307, 3310, 5432
- **Resultado:** parcial
- **Como reproduzir:** `nc -zv -w 2 192.168.1.16 <porta>`
- **Observações:** portas 22, 80, 443, 1433, 3306, 3310, 5432 → **recusadas/fechadas**. Porta
  **3307 → aberta** (MySQL 5.7.26).

## Banco de dados
### 2026-08-10 — Acesso ao MySQL 5.7.26 em 192.168.1.16 (porta 3307)
- **O que foi testado:** conexão MySQL com usuário `_consulta` no servidor 192.168.1.16
- **Resultado:** funciona
- **Como reproduzir:** `MYSQL_PWD='<senha>' mysql -h 192.168.1.16 -P 3307 -u _consulta -e "SELECT VERSION();"`
- **Observações:**
  - Porta **3306 fechada**; MySQL roda na **3307**.
  - Versão do servidor: **5.7.26** (banner confirma). `SELECT VERSION()` retornou `5.7.26`; autenticação OK.
  - `SHOW DATABASES` retornou: `information_schema`, `mysql`, `performance_schema`, `sys`, **`wingraphex`**.
  - Banco `wingraphex` = ERP grande (~700 tabelas visíveis no servidor, 558 dumpadas): módulos de
    flexografia/gráfica, orçamento, pedidos, NF-e/MDFe/CTe, estoque, financeiro, PCP, CRM, LGPD,
    integrações (BOSCH, Salesforce), segurança (`_segusuario`, `_segpermissoes`).
  - Portas 22, 80, 443, 1433, 5432, 3306, 3310 fechadas.
  - **Credencial:** senha do usuário `_consulta` — **nunca salvar em texto puro**; ler de
    `senha.txt` (fora do controle de versão) via `awk` no comando, nunca colar no chat/arquivo de conhecimento.
  - Cliente local: `mysql` 8.0.46 (Ubuntu 24.04).

> Para testar SQL sem tocar a produção, existe uma réplica local em Docker (porta 3308, mesma
> versão 5.7.26) — ver `ambiente-docker-local.md`.

## Protocolo de registro de novas descobertas (regras permanentes)
1. Ao testar/descobrir/confirmar algo relevante — pingar um IP, acessar um banco, usar uma API,
   alcançar um host etc. — registrar no arquivo `.md` correspondente ao assunto.
2. Um arquivo por assunto. Assunto novo → novo arquivo em `references/`; assunto existente →
   atualizar o arquivo com uma nova entrada datada.
3. Formato padrão de cada entrada:
   ```md
   ## YYYY-MM-DD - <síntese do que foi verificado>
   - **O que foi testado:** <descrição>
   - **Resultado:** <funciona / não funciona / parcial>
   - **Como reproduzir:** <comandos/passos>
   - **Observações:** <detalhes úteis>
   ```
4. Atualização incremental: novas informações incrementam os arquivos existentes; informação
   desatualizada é marcada como obsoleta, não apagada.
5. Credenciais: **nunca** salvar senhas, chaves ou segredos em texto puro. Registrar apenas
   referência de onde estão (ex.: variável de ambiente, gerenciador de segredos, caminho de arquivo
   protegido). IPs, hosts, nomes de banco, usuário e porta podem ser registrados normalmente.
6. Banco de dados (wingraphex): acesso **estritamente somente leitura**. Nunca executar INSERT,
   UPDATE, DELETE, TRUNCATE, DDL (CREATE, ALTER, DROP) ou qualquer comando que modifique
   dados/estrutura. Somente SELECT, SHOW, `information_schema` e comandos de leitura.

## Relatórios (base de conhecimento validada)
A pasta `relatorios/` guarda scripts SQL de relatórios **validados em treino** (o usuário pede um
relatório já sabendo o resultado; a IA monta o SQL, executa somente leitura e apresenta o
resultado). Fluxo completo → `relatorios-indice.md`.

- **Antes de montar relatório:** procurar em `relatorios-indice.md`. Se já existir, usar o SQL validado.
- **Não existe:** montar o SQL com base no conhecimento (`regras-de-negocio.md`,
  `esqueleto-schema.md`, `modulo-*.md`, `schema-wingraphex.sql`), executar somente leitura e
  apresentar o resultado real.
- **Sempre usar** `--default-character-set=utf8` no comando mysql (banco é latin1; sem isso a
  acentuação quebra).
- **Acertou:** cristalizar em novo arquivo `relatorios/<nome>.md` no formato definido em
  `relatorios-indice.md`.
- **Errou:** perguntar ao usuário o que ficou ambíguo, corrigir e só então salvar.
