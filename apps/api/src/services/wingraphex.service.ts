import type { MySQLRowDataPacket } from "@fastify/mysql";
import type { FastifyInstance } from "fastify";

import { AppError } from "../lib/errors.ts";
import type { WingraphexOp } from "../schemas/wingraphex.schema.ts";

interface WingraphexOpDbRow extends MySQLRowDataPacket {
  op: string | number;
  cliente: string | null;
  qtd_total: string | number | null;
  saldo_qtd: string | number | null;
  valor_total: string | number | null;
  saldo_producao: string | number | null;
  valor_pago: string | number | null;
  saldo_receber: string | number | null;
  data_emissao: string | null;
  status: string | null;
  pcp_processos: string | number | null;
  pcp_finalizados: string | number | null;
}

export interface QueryOpsByDescriptionInput {
  descricao: string;
  clienteId?: number;
  dataInicio?: string;
  dataFim?: string;
  limite: number;
}

function escapeLike(value: string): string {
  return value.replace(/[\\%_]/g, (char) => `\\${char}`);
}

function buildOpsWhere(
  alias: string,
  opts: QueryOpsByDescriptionInput,
): { sql: string; params: (string | number)[] } {
  const col = (name: string): string => `${alias}.${name}`;
  const clauses = [`${col("EMP_ID")}=1`, `${col("ORS_CANCELADA")}<>'S'`];
  const params: (string | number)[] = [];

  clauses.push(`${col("ORS_DESCRICAO")} LIKE ?`);
  params.push(`%${escapeLike(opts.descricao)}%`);

  if (opts.clienteId !== undefined) {
    clauses.push(`${col("CLI_ID")} = ?`);
    params.push(opts.clienteId);
  }
  if (opts.dataInicio !== undefined) {
    clauses.push(`${col("ORS_DATA")} >= ?`);
    params.push(opts.dataInicio);
  }
  if (opts.dataFim !== undefined) {
    clauses.push(`${col("ORS_DATA")} <= ?`);
    params.push(opts.dataFim);
  }

  return { sql: `WHERE ${clauses.join(" AND ")}`, params };
}

function toNumber(value: string | number | null): number {
  return value === null ? 0 : Number(value);
}

function toWingraphexOp(row: WingraphexOpDbRow): WingraphexOp {
  return {
    op: Number(row.op),
    cliente: row.cliente ?? null,
    qtd_total: toNumber(row.qtd_total),
    saldo_qtd: toNumber(row.saldo_qtd),
    valor_total: toNumber(row.valor_total),
    saldo_producao: toNumber(row.saldo_producao),
    valor_pago: toNumber(row.valor_pago),
    saldo_receber: toNumber(row.saldo_receber),
    data_emissao: row.data_emissao ?? "",
    status: row.status ?? "",
    pcp_processos: toNumber(row.pcp_processos),
    pcp_finalizados: toNumber(row.pcp_finalizados),
  };
}

export async function queryOpsByDescription(
  fastify: FastifyInstance,
  input: QueryOpsByDescriptionInput,
): Promise<WingraphexOp[]> {
  const finWhere = buildOpsWhere("os2", input);
  const pcpWhere = buildOpsWhere("os3", input);
  const mainWhere = buildOpsWhere("os", input);

  const sql = `
    SELECT os.ORS_ID AS op,
           (SELECT p.PES_NOME_RAZAO FROM pessoa p WHERE p.EMP_ID=os.EMP_ID AND p.PES_ID=os.CLI_ID LIMIT 1) AS cliente,
           os.ORS_QUANTIDADE AS qtd_total,
           o.ORS_SALDO AS saldo_qtd,
           ROUND(os.ORS_VLRFINALPRAZO,2) AS valor_total,
           ROUND(os.ORS_VLRFINALPRAZO*(o.ORS_SALDO/os.ORS_QUANTIDADE),2) AS saldo_producao,
           COALESCE(fin.valor_pago,0) AS valor_pago,
           COALESCE(fin.saldo_receber,0) AS saldo_receber,
           DATE(os.ORS_DATA) AS data_emissao,
           os.ORS_STATUSFATURAMENTO AS status,
           COALESCE(pcp.processos,0) AS pcp_processos,
           COALESCE(pcp.finalizados,0) AS pcp_finalizados
    FROM ordemservico os
    JOIN op o ON o.EMP_ID=os.EMP_ID AND o.ORS_ID=os.ORS_ID
    LEFT JOIN (
      SELECT di.CODIGOORDEMPRODUCAO AS op,
             ROUND(SUM(f.VALOR-f.SALDO),2) AS valor_pago,
             ROUND(SUM(f.SALDO),2) AS saldo_receber
      FROM documentoitem di
      JOIN documentocabecalho dc ON dc.EMP_ID=di.EMP_ID AND dc.CLASSIFICACAO=di.CLASSIFICACAO AND dc.DOC_ID=di.DOC_ID AND (dc.CANCELADA<>'S' OR dc.CANCELADA IS NULL)
      JOIN financeiro f ON f.EMP_ID=dc.EMP_ID AND f.CLASSIFICACAO=dc.CLASSIFICACAO AND f.DOC_ID=dc.DOC_ID
        AND f.ORIGEM='TOL_CONTASARECEBER'
        AND (f.FLAGLANCCANCELADO<>'S' OR f.FLAGLANCCANCELADO IS NULL)
        AND (f.ESTORNO<>'S' OR f.ESTORNO IS NULL)
      WHERE di.EMP_ID=1 AND di.CODIGOORDEMPRODUCAO IN (
        SELECT os2.ORS_ID FROM ordemservico os2 ${finWhere.sql}
      )
      GROUP BY di.CODIGOORDEMPRODUCAO
    ) fin ON fin.op=os.ORS_ID
    LEFT JOIN (
      SELECT pc.CODIGOOP AS op, COUNT(*) AS processos, SUM(pc.STATUS='F') AS finalizados
      FROM pcpprocessos pc WHERE pc.EMP_ID=1 AND pc.CODIGOOP IN (
        SELECT os3.ORS_ID FROM ordemservico os3 ${pcpWhere.sql}
      )
      GROUP BY pc.CODIGOOP
    ) pcp ON pcp.op=os.ORS_ID
    ${mainWhere.sql}
    ORDER BY os.ORS_DATA DESC
    LIMIT ?`;

  const params = [
    ...finWhere.params,
    ...pcpWhere.params,
    ...mainWhere.params,
    input.limite,
  ];

  try {
    const [rows] = await fastify.wingraphex.query<WingraphexOpDbRow[]>(sql, params);
    return rows.map(toWingraphexOp);
  } catch (err) {
    fastify.log.error({ err }, "Wingraphex query failed");
    throw new AppError(503, "Banco Wingraphex indisponível.");
  }
}