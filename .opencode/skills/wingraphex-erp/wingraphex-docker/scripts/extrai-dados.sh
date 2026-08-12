#!/usr/bin/env bash
# Extrai amostra REAL (somente leitura) do banco de producao wingraphex
# e gera initdb/02-dados.sql para o ambiente docker local.
#
# Uso:  MYSQL_PWD='...' ./scripts/extrai-dados.sh   (ou le a senha de ../../senha.txt)
#
# Seguranca: apenas mysqldump com --single-transaction --skip-lock-tables
# (somente leitura, sem LOCK TABLES). Nenhum INSERT/UPDATE/DELETE na origem.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_FILE="${OUT_DIR}/initdb/02-dados.sql"

DBHOST=192.168.1.16
DBPORT=3307
DBUSER=_consulta
DBNAME=wingraphex

if [ -z "${MYSQL_PWD:-}" ] && [ -f "${ROOT_DIR}/senha.txt" ]; then
	export MYSQL_PWD="$(awk -F'= ' '/^senha/{print $2}' "${ROOT_DIR}/senha.txt")"
fi
if [ -z "${MYSQL_PWD:-}" ]; then
	echo "ERRO: defina MYSQL_PWD ou senha.txt com a senha do _consulta" >&2
	exit 1
fi

DOCS="93317,93318,93319,93320,93315,93312,93250"
OPS="162056,162060,162061,161816,162015"
ORCS="171415,171421,171419,171418,171417,171416"
PESSOAS="5011,6030,5432,7379,9709,10970,10816,28,9769,267,606"

DUMP_ARGS=(
	-h "${DBHOST}" -P "${DBPORT}" -u "${DBUSER}"
	--no-create-info
	--single-transaction
	--skip-lock-tables
	--skip-add-locks
	--quick
	--default-character-set=utf8
	--complete-insert
	--skip-extended-insert
	--set-gtid-purged=OFF
	--skip-column-statistics
	--skip-triggers
)

dump() {
	local table="$1"; shift
	local where="${1:-}"
	if [ -n "${where}" ]; then
		"${MYSQLDUMP:-mysqldump}" "${DUMP_ARGS[@]}" "${DBNAME}" "${table}" --where="${where}" > "${tmp}/t.sql"
	else
		"${MYSQLDUMP:-mysqldump}" "${DUMP_ARGS[@]}" "${DBNAME}" "${table}" > "${tmp}/t.sql"
	fi
	# remove o cabecalho SUCCESS/comentarios de fim; o corpo vira INSERTs
	grep -E "^(INSERT INTO|/\*.*INSERT)" "${tmp}/t.sql" > "${tmp}/t.clean" || true
	if [ -s "${tmp}/t.clean" ]; then
		printf -- '-- tabela: %s\n' "${table}" >> "${out_part}"
		cat "${tmp}/t.clean" >> "${out_part}"
	fi
}

tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

{
	printf -- '-- Gerado automaticamente por scripts/extrai-dados.sh (somente leitura)\n'
	printf -- '-- Origem: %s:%s/%s via %s\n' "${DBHOST}" "${DBPORT}" "${DBNAME}" "${DBUSER}"
	printf -- '-- Data: %s\n--\n' "$(date '+%Y-%m-%d %H:%M')"
	printf -- 'USE wingraphex;\n'
	printf -- 'SET NAMES utf8;\n'
	printf -- 'SET FOREIGN_KEY_CHECKS=0;\n'
	printf -- 'SET UNIQUE_CHECKS=0;\n'
	printf -- 'SET SESSION sql_mode="NO_AUTO_VALUE_ON_ZERO";\n\n'
} > "${out_part:=${tmp}/out.sql}"

# ============ CADASTROS ============
dump pessoa        "PES_ID IN (${PESSOAS})"
dump cliente       "EMP_ID=1 AND PES_ID IN (${PESSOAS})"
dump vendedor      "EMP_ID=1"

# ============ ORCAMENTO ============
dump orcamento     "EMP_ID=1 AND ORC_ID IN (${ORCS})"
dump qtorcamento   "EMP_ID=1 AND ORC_ID IN (${ORCS})"

# ============ OP / PCP ============
dump ordemservico          "EMP_ID=1 AND ORS_ID IN (${OPS})"
dump op                    "EMP_ID=1 AND ORS_ID IN (${OPS})"
dump ordemservicostatus    "EMP_ID=1 AND ORS_ID IN (${OPS})"
dump tipostatusordemservico
dump pcptrabalhos          "EMP_ID=1 AND CODIGOOP IN (${OPS})"
dump pcpprocessos          "EMP_ID=1 AND CODIGOOP IN (${OPS})"
dump pcpapontamento        "EMP_ID=1 ORDER BY CODIGO,CODIGOPROCESSO,CODIGOTRABALHO LIMIT 200"

# ============ FATURAMENTO ============
dump documentocabecalho     "EMP_ID=1 AND CLASSIFICACAO=0 AND DOC_ID IN (${DOCS})"
dump documentoitem          "EMP_ID=1 AND CLASSIFICACAO=0 AND DOC_ID IN (${DOCS})"
dump documentocalculo       "EMP_ID=1 AND CLASSIFICACAO=0 AND DOC_ID IN (${DOCS})"
dump documentoitemcalculo   "EMP_ID=1 AND CLASSIFICACAO=0 AND DOC_ID IN (${DOCS})"
dump documentorodape        "EMP_ID=1 AND CLASSIFICACAO=0 AND DOC_ID IN (${DOCS})"
dump tipodocumento
dump naturezaoperacao
dump serienf
dump estado
dump cidade
dump cfopoficial

# ============ FINANCEIRO ============
dump financeiro   "EMP_ID=1 AND DOC_ID IN (${DOCS})"
dump receber      "EMP_ID=1 AND CHAVE IN (SELECT CHAVE FROM financeiro WHERE EMP_ID=1 AND DOC_ID IN (${DOCS}))"
dump pagar        "EMP_ID=1 AND CHAVE IN (SELECT CHAVE FROM financeiro WHERE EMP_ID=1 AND DOC_ID IN (${DOCS}))"
dump formapagto   "EMP_ID=1"
dump meiospagamento
dump banco
dump contabancaria
dump carteira

# ============ ESTOQUE ============
dump material      "EMP_ID=1 AND MTR_ID IN (SELECT DISTINCT CODIGOMATERIAL FROM documentoitem WHERE EMP_ID=1 AND CLASSIFICACAO=0 AND DOC_ID IN (${DOCS})) OR (EMP_ID=1 AND MTR_ID='69125')"
dump estoque       "EMP_ID=1 AND DOC_ID IN (${DOCS}) ORDER BY CODIGO LIMIT 100"
dump localestoque

# ============ INFRA ============
dump _dicionario
dump _parametrofaturamento
dump _parametrofinanceiro
dump _parametroestoque
dump _parametrosorc
dump _parametrospcp
dump _parametroempresa
dump _seggrupousuario

{
	printf -- '\nSET FOREIGN_KEY_CHECKS=1;\n'
	printf -- 'SET UNIQUE_CHECKS=1;\n'
} >> "${out_part}"

mkdir -p "$(dirname "${OUT_FILE}")"
mv "${out_part}" "${OUT_FILE}"
echo "OK: ${OUT_FILE} ($(wc -l < "${OUT_FILE}") linhas)"