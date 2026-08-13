#!/usr/bin/env bash
# Incrementa initdb/02-dados.sql com 30 OPs completas de 5 clientes (somente leitura).
# Semelhante ao extrai-dados.sh, mas:
#   - seleciona dinamicamente, por cliente, as OPs completas mais recentes ainda nao no arquivo;
#   - apenas ANEXA os INSERTs novos ao 02-dados.sql existente (preserva a amostra atual);
#   - deduplica materiais/documentos ja presentes no arquivo.
#
# Uso:  MYSQL_PWD='...' ./scripts/incrementa-ops.sh   (ou le WINGRAPHEX_READ_PASSWORD de .env)
#
# Seguranca: apenas mysqldump --single-transaction --skip-lock-tables (somente leitura,
# sem LOCK TABLES). Nenhum INSERT/UPDATE/DELETE na origem.

set -euo pipefail

OUT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_FILE="${OUT_DIR}/initdb/02-dados.sql"
ENV_FILE="${OUT_DIR}/.env"

DBHOST=192.168.1.16
DBPORT=3307
DBUSER=_consulta
DBNAME=wingraphex

# 5 clientes ja presentes na amostra atual, com maior numero de OPs completas.
CLIENTS="28,10816,6030,606,7379"
OPS_PER_CLIENT=6

if [ -z "${MYSQL_PWD:-}" ] && [ -f "${ENV_FILE}" ]; then
	export MYSQL_PWD="$(awk -F= '/^WINGRAPHEX_READ_PASSWORD=/{print $2}' "${ENV_FILE}")"
fi
if [ -z "${MYSQL_PWD:-}" ]; then
	echo "ERRO: defina MYSQL_PWD ou WINGRAPHEX_READ_PASSWORD em docker/wingraphex/.env" >&2
	exit 1
fi
if [ ! -f "${OUT_FILE}" ]; then
	echo "ERRO: ${OUT_FILE} nao existe — rode scripts/extrai-dados.sh primeiro" >&2
	exit 1
fi

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

mysql_q() {
	MYSQL_PWD="${MYSQL_PWD}" mysql --default-character-set=utf8 \
		-h "${DBHOST}" -P "${DBPORT}" -u "${DBUSER}" "${DBNAME}" -N -B -e "$1"
}

dump() {
	local table="$1"; shift
	local where="${1:-}"
	if [ -n "${where}" ]; then
		"${MYSQLDUMP:-mysqldump}" "${DUMP_ARGS[@]}" "${DBNAME}" "${table}" --where="${where}" > "${tmp}/t.sql"
	else
		"${MYSQLDUMP:-mysqldump}" "${DUMP_ARGS[@]}" "${DBNAME}" "${table}" > "${tmp}/t.sql"
	fi
	grep -E "^(INSERT INTO|/\*.*INSERT)" "${tmp}/t.sql" > "${tmp}/t.clean" || true
	if [ -s "${tmp}/t.clean" ]; then
		printf -- '-- tabela: %s\n' "${table}" >> "${out_part}"
		cat "${tmp}/t.clean" >> "${out_part}"
	fi
}

# --- IDs ja presentes no arquivo (para deduplicar / nao duplicar PK) ---
existing_docs="$(grep -oP "INSERT INTO \`documentocabecalho\` .*?VALUES \(1,[0-9]+,\K[0-9]+" "${OUT_FILE}" | sort -u | paste -sd, -)"
existing_mtr="$(grep -oP "INSERT INTO \`material\` .*?VALUES \(1,'\K[0-9]+" "${OUT_FILE}" | sort -u | paste -sd, -)"
existing_ors="$(grep -oP "INSERT INTO \`ordemservico\` .*?VALUES \(1,'\K[0-9]+" "${OUT_FILE}" | sort -u | paste -sd, -)"

# --- Seleciona 30 OPs completas (6 por cliente, mais recentes, fora da amostra) ---
# OP completa = faturada, nao cancelada, com PCP (trabalhos+processos), documentoitem e
# financeiro ligado via DOC_ID; e com DOC_ID ainda fora do arquivo.
select_where="
o.EMP_ID=1
  AND o.ORS_CANCELADA='N'
  AND o.ORS_STATUSFATURAMENTO='TSF_FATURADA'
  AND o.ORS_ID NOT IN (${existing_ors})
  AND EXISTS (SELECT 1 FROM pcptrabalhos x WHERE x.EMP_ID=1 AND x.CODIGOOP=o.ORS_ID)
  AND EXISTS (SELECT 1 FROM pcpprocessos x WHERE x.EMP_ID=1 AND x.CODIGOOP=o.ORS_ID)
  AND EXISTS (SELECT 1 FROM documentoitem x WHERE x.EMP_ID=1 AND x.CODIGOORDEMPRODUCAO=o.ORS_ID)
  AND NOT EXISTS (SELECT 1 FROM documentoitem di
                  WHERE di.EMP_ID=1 AND di.CODIGOORDEMPRODUCAO=o.ORS_ID
                    AND di.DOC_ID IN (${existing_docs}))
  AND EXISTS (SELECT 1 FROM financeiro f
              WHERE f.EMP_ID=1 AND f.DOC_ID IN
                    (SELECT DOC_ID FROM documentoitem d WHERE d.EMP_ID=1 AND d.CODIGOORDEMPRODUCAO=o.ORS_ID))
"

# per-client top-N: MySQL 5.7 nao tem window functions; seleciona os OPS_PER_CLIENT
# mais recentes de cada cliente (6 por cliente = 30 no total).
ops_selected=""
for cli in ${CLIENTS//,/ }; do
	per_cli="$(mysql_q "
SELECT o.ORS_ID
FROM ordemservico o
WHERE ${select_where}
  AND o.CLI_ID=${cli}
ORDER BY o.ORS_DATA DESC, o.ORS_ID DESC
LIMIT ${OPS_PER_CLIENT}
")"
	ops_selected="${ops_selected}${per_cli} "
done
ops_selected="$(echo ${ops_selected} | tr ' ' '\n' | grep -v '^$' | sort -u)"
OPS="$(echo ${ops_selected} | tr ' ' ',')"
if [ -z "${OPS}" ]; then
	echo "ERRO: nenhuma OP selecionada" >&2
	exit 1
fi

# --- Deriva os conjuntos dependentes ---
ORCS="$(mysql_q "SELECT DISTINCT ORC_ID FROM ordemservico WHERE EMP_ID=1 AND ORS_ID IN (${OPS})" | paste -sd, -)"
DOCS="$(mysql_q "SELECT DISTINCT DOC_ID FROM documentoitem WHERE EMP_ID=1 AND CODIGOORDEMPRODUCAO IN (${OPS})" | paste -sd, -)"
TRABALHOS="$(mysql_q "SELECT DISTINCT CODIGO FROM pcptrabalhos WHERE EMP_ID=1 AND CODIGOOP IN (${OPS})" | paste -sd, -)"
CHAVES="$(mysql_q "SELECT DISTINCT CHAVE FROM financeiro WHERE EMP_ID=1 AND DOC_ID IN (${DOCS})" | paste -sd, -)"
# materiais novos = referenciados pelos novos docs menos os ja no arquivo
MTRS="$(mysql_q "SELECT DISTINCT CODIGOMATERIAL FROM documentoitem WHERE EMP_ID=1 AND DOC_ID IN (${DOCS})" | paste -sd, -)"
if [ -n "${existing_mtr}" ]; then
	MTRS_NOVOS="$(echo "${MTRS}" | tr ',' '\n' | grep -vE "^(|$(echo "${existing_mtr}" | tr ',' '|'))$" | paste -sd, -)"
else
	MTRS_NOVOS="${MTRS}"
fi

echo "OPS=${OPS}"
echo "ORCS=${ORCS}"
echo "DOCS=${DOCS}"
echo "TRABALHOS=${TRABALHOS}"
echo "CHAVES=${CHAVES}"
echo "MATERIAIS novos=${MTRS_NOVOS}"

tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT
out_part="${tmp}/out_part.sql"
: > "${out_part}"

# ============ ORCAMENTO ============
dump orcamento     "EMP_ID=1 AND ORC_ID IN (${ORCS})"
dump qtorcamento   "EMP_ID=1 AND ORC_ID IN (${ORCS})"

# ============ OP / PCP ============
dump ordemservico       "EMP_ID=1 AND ORS_ID IN (${OPS})"
dump op                 "EMP_ID=1 AND ORS_ID IN (${OPS})"
dump ordemservicostatus "EMP_ID=1 AND ORS_ID IN (${OPS})"
dump pcptrabalhos       "EMP_ID=1 AND CODIGOOP IN (${OPS})"
dump pcpprocessos       "EMP_ID=1 AND CODIGOTRABALHO IN (${TRABALHOS})"
dump pcpapontamento     "EMP_ID=1 AND CODIGOTRABALHO IN (${TRABALHOS})"

# ============ FATURAMENTO ============
dump documentocabecalho   "EMP_ID=1 AND CLASSIFICACAO=0 AND DOC_ID IN (${DOCS})"
dump documentoitem        "EMP_ID=1 AND CLASSIFICACAO=0 AND DOC_ID IN (${DOCS})"
dump documentocalculo     "EMP_ID=1 AND CLASSIFICACAO=0 AND DOC_ID IN (${DOCS})"
dump documentoitemcalculo "EMP_ID=1 AND CLASSIFICACAO=0 AND DOC_ID IN (${DOCS})"
dump documentorodape      "EMP_ID=1 AND CLASSIFICACAO=0 AND DOC_ID IN (${DOCS})"

# ============ FINANCEIRO ============
dump financeiro   "EMP_ID=1 AND DOC_ID IN (${DOCS})"
dump receber      "EMP_ID=1 AND CHAVE IN (${CHAVES})"

# ============ ESTOQUE ============
dump material  "EMP_ID=1 AND MTR_ID IN (${MTRS_NOVOS})"
dump estoque   "EMP_ID=1 AND DOC_ID IN (${DOCS})"

if [ ! -s "${out_part}" ]; then
	echo "ERRO: nenhum INSERT novo gerado" >&2
	exit 1
fi

# ============ APPEND ao 02-dados.sql, antes do rodape final ============
# Remove as ultimas linhas (SET FOREIGN_KEY_CHECKS=1 / SET UNIQUE_CHECKS=1) do arquivo,
# anexa os INSERTs novos e reescreve o rodape.
head -n -2 "${OUT_FILE}" > "${tmp}/sem_rodape.sql"
{
	cat "${tmp}/sem_rodape.sql"
	printf '\n'
	printf -- '-- Gerado automaticamente por scripts/incrementa-ops.sh (somente leitura)\n'
	printf -- '-- Origem: %s:%s/%s via %s\n' "${DBHOST}" "${DBPORT}" "${DBNAME}" "${DBUSER}"
	printf -- '-- Data: %s\n--\n' "$(date '+%Y-%m-%d %H:%M')"
	cat "${out_part}"
	printf '\nSET FOREIGN_KEY_CHECKS=1;\n'
	printf 'SET UNIQUE_CHECKS=1;\n'
} > "${OUT_FILE}"

echo "OK: ${OUT_FILE} incrementado ($(grep -c '^INSERT INTO' "${OUT_FILE}") INSERTs totais)"