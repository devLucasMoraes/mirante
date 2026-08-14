import type { MySQLRowDataPacket } from "@fastify/mysql";
import type { FastifyInstance } from "fastify";

import { AppError } from "../lib/errors.ts";
import type {
  NotaFaturamento,
  WingraphexCliente,
  WingraphexOp,
  WingraphexOpsResponse,
} from "../schemas/wingraphex.schema.ts";

interface WingraphexOpDbRow extends MySQLRowDataPacket {
  op: string | number;
  cliente: string | null;
  descricao: string | null;
  qtd_total: string | number | null;
  valor_servico: string | number | null;
  data_emissao: string | null;
  status: string | null;
  pcp_processos: string | number | null;
  pcp_finalizados: string | number | null;
}

interface DocIdDbRow extends MySQLRowDataPacket {
  doc_id: string | number;
}

interface ItemNotaDbRow extends MySQLRowDataPacket {
  DOC_ID: number;
  op: string | null;
  QUANTIDADE: string | number | null;
  VALORUNITARIO: string | number | null;
  SERIENF: string | null;
  NUMERONF: number | null;
  NUMERODOCUMENTO: string | null;
  data_emissao: string | null;
}

interface FinanceiroNotaDbRow extends MySQLRowDataPacket {
  DOC_ID: number;
  VALOR: string | number | null;
  SALDO: string | number | null;
}

export interface QueryOpsByDescriptionInput {
  descricao?: string;
  clienteId?: number;
  dataInicio?: string;
  dataFim?: string;
  pagina: number;
  limite: number;
}

interface WingraphexCountDbRow extends MySQLRowDataPacket {
  total: string | number;
}

export interface QueryClientesInput {
  term?: string;
  limite: number;
}

interface WingraphexClienteDbRow extends MySQLRowDataPacket {
  id: number;
  nome: string;
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

  if (opts.descricao !== undefined && opts.descricao.trim() !== "") {
    clauses.push(`${col("ORS_DESCRICAO")} LIKE ?`);
    params.push(`%${escapeLike(opts.descricao.trim())}%`);
  }

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

function round2(value: number): number {
  return Math.round(value * 100) / 100;
}

function placeholders(count: number): string {
  return Array.from({ length: count }, () => "?").join(",");
}

function toWingraphexOp(row: WingraphexOpDbRow): WingraphexOp {
  return {
    op: Number(row.op),
    cliente: row.cliente ?? null,
    descricao: row.descricao ?? "",
    qtd_total: toNumber(row.qtd_total),
    valor_servico: toNumber(row.valor_servico),
    data_emissao: row.data_emissao ?? "",
    status: row.status ?? "",
    faturamento: { valor_faturado: 0, quantidade_faturada: 0, notas: [] },
    financeiro: { pago: 0, saldo: 0 },
    pcp: {
      processos: toNumber(row.pcp_processos),
      finalizados: toNumber(row.pcp_finalizados),
    },
  };
}

async function fetchNotaDocIds(
  fastify: FastifyInstance,
  opIds: number[],
): Promise<number[]> {
  if (opIds.length === 0) return [];
  const sql = `
    SELECT DISTINCT di.DOC_ID AS doc_id
    FROM documentoitem di
    WHERE di.EMP_ID=1 AND di.CLASSIFICACAO=0
      AND di.CODIGOORDEMPRODUCAO IN (${placeholders(opIds.length)})`;
  const [rows] = await fastify.wingraphex.query<DocIdDbRow[]>(
    sql,
    opIds.map(String),
  );
  return rows.map((row) => Number(row.doc_id));
}

async function fetchItemsForDocs(
  fastify: FastifyInstance,
  docIds: number[],
): Promise<ItemNotaDbRow[]> {
  if (docIds.length === 0) return [];
  const sql = `
    SELECT di.DOC_ID, di.CODIGOORDEMPRODUCAO AS op,
           di.QUANTIDADE, di.VALORUNITARIO,
           dc.SERIENF, dc.NUMERONF, dc.NUMERODOCUMENTO,
           DATE(dc.DATAEMISSAO) AS data_emissao
    FROM documentoitem di
    JOIN documentocabecalho dc
      ON dc.EMP_ID=di.EMP_ID AND dc.CLASSIFICACAO=di.CLASSIFICACAO AND dc.DOC_ID=di.DOC_ID
    WHERE di.EMP_ID=1 AND di.CLASSIFICACAO=0
      AND di.DOC_ID IN (${placeholders(docIds.length)})
      AND (dc.CANCELADA<>'S' OR dc.CANCELADA IS NULL)`;
  const [rows] = await fastify.wingraphex.query<ItemNotaDbRow[]>(
    sql,
    docIds,
  );
  return rows;
}

async function fetchFinanceiroForDocs(
  fastify: FastifyInstance,
  docIds: number[],
): Promise<FinanceiroNotaDbRow[]> {
  if (docIds.length === 0) return [];
  const sql = `
    SELECT f.DOC_ID, f.VALOR, f.SALDO
    FROM financeiro f
    WHERE f.EMP_ID=1 AND f.CLASSIFICACAO=0
      AND f.DOC_ID IN (${placeholders(docIds.length)})
      AND f.ORIGEM='TOL_CONTASARECEBER'
      AND (f.FLAGLANCCANCELADO<>'S' OR f.FLAGLANCCANCELADO IS NULL)
      AND (f.ESTORNO<>'S' OR f.ESTORNO IS NULL)`;
  const [rows] = await fastify.wingraphex.query<FinanceiroNotaDbRow[]>(
    sql,
    docIds,
  );
  return rows;
}

function buildDocValorTotal(items: ItemNotaDbRow[]): Map<number, number> {
  const byDoc = new Map<number, number>();
  for (const item of items) {
    const valor = toNumber(item.QUANTIDADE) * toNumber(item.VALORUNITARIO);
    const docId = Number(item.DOC_ID);
    byDoc.set(docId, (byDoc.get(docId) ?? 0) + valor);
  }
  return byDoc;
}

function buildDocFinanceiro(
  rows: FinanceiroNotaDbRow[],
): Map<number, { pago: number; saldo: number }> {
  const byDoc = new Map<number, { pago: number; saldo: number }>();
  for (const row of rows) {
    const docId = Number(row.DOC_ID);
    const current = byDoc.get(docId) ?? { pago: 0, saldo: 0 };
    current.pago += toNumber(row.VALOR) - toNumber(row.SALDO);
    current.saldo += toNumber(row.SALDO);
    byDoc.set(docId, current);
  }
  return byDoc;
}

export async function queryOpsByDescription(
  fastify: FastifyInstance,
  input: QueryOpsByDescriptionInput,
): Promise<WingraphexOpsResponse> {
  const pcpWhere = buildOpsWhere("os3", input);
  const mainWhere = buildOpsWhere("os", input);

  const offset = (input.pagina - 1) * input.limite;

  const countSql = `
    SELECT COUNT(*) AS total
    FROM ordemservico os
    JOIN op o ON o.EMP_ID=os.EMP_ID AND o.ORS_ID=os.ORS_ID
    ${mainWhere.sql}`;

  const sql = `
    SELECT os.ORS_ID AS op,
           (SELECT p.PES_NOME_RAZAO FROM pessoa p WHERE p.EMP_ID=os.EMP_ID AND p.PES_ID=os.CLI_ID LIMIT 1) AS cliente,
           os.ORS_DESCRICAO AS descricao,
           os.ORS_QUANTIDADE AS qtd_total,
           ROUND(os.ORS_VLRFINALPRAZO,2) AS valor_servico,
           DATE(os.ORS_DATA) AS data_emissao,
           os.ORS_STATUSFATURAMENTO AS status,
           COALESCE(pcp.processos,0) AS pcp_processos,
           COALESCE(pcp.finalizados,0) AS pcp_finalizados
    FROM ordemservico os
    JOIN op o ON o.EMP_ID=os.EMP_ID AND o.ORS_ID=os.ORS_ID
    LEFT JOIN (
      SELECT pc.CODIGOOP AS op, COUNT(*) AS processos, SUM(pc.STATUS='F') AS finalizados
      FROM pcpprocessos pc WHERE pc.EMP_ID=1 AND pc.CODIGOOP IN (
        SELECT os3.ORS_ID FROM ordemservico os3 ${pcpWhere.sql}
      )
      GROUP BY pc.CODIGOOP
    ) pcp ON pcp.op=os.ORS_ID
    ${mainWhere.sql}
    ORDER BY os.ORS_DATA DESC
    LIMIT ? OFFSET ?`;

  const params = [
    ...pcpWhere.params,
    ...mainWhere.params,
    input.limite,
    offset,
  ];

  try {
    const [countRows] = await fastify.wingraphex.query<WingraphexCountDbRow[]>(
      countSql,
      mainWhere.params,
    );
    const total = Number(countRows[0]?.total ?? 0);

    const [rows] = await fastify.wingraphex.query<WingraphexOpDbRow[]>(
      sql,
      params,
    );
    const itens = rows.map(toWingraphexOp);

    if (itens.length > 0) {
      const opIds = itens.map((item) => item.op);
      const byOp = new Map<number, WingraphexOp>(
        itens.map((item) => [item.op, item]),
      );
      const docIds = await fetchNotaDocIds(fastify, opIds);
      const [items, financeiroRows] = await Promise.all([
        fetchItemsForDocs(fastify, docIds),
        fetchFinanceiroForDocs(fastify, docIds),
      ]);

      const docValorTotal = buildDocValorTotal(items);
      const docFinanceiro = buildDocFinanceiro(financeiroRows);
      const pageOps = new Set(opIds);

      const comItens = new Map<number, Map<number, NotaFaturamento>>();
      for (const item of items) {
        const opId = Number(item.op);
        if (item.op === null || item.op === "" || !pageOps.has(opId)) {
          continue;
        }
        const valor = toNumber(item.QUANTIDADE) * toNumber(item.VALORUNITARIO);
        const quantidade = toNumber(item.QUANTIDADE);
        const porDoc = comItens.get(opId) ?? new Map<number, NotaFaturamento>();
        const nota = porDoc.get(item.DOC_ID) ?? {
          serie: item.SERIENF ?? null,
          numero: String(item.NUMERONF ?? item.NUMERODOCUMENTO ?? item.DOC_ID),
          data: item.data_emissao ?? null,
          valor: 0,
          quantidade: 0,
        };
        nota.valor += valor;
        nota.quantidade += quantidade;
        porDoc.set(item.DOC_ID, nota);
        comItens.set(opId, porDoc);
      }

      for (const opId of opIds) {
        const porDoc = comItens.get(opId);
        if (!porDoc) continue;

        let valorFaturado = 0;
        let quantidadeFaturada = 0;
        let pago = 0;
        let saldo = 0;
        const notas: NotaFaturamento[] = [];

        for (const [docId, nota] of porDoc) {
          const totalDoc = docValorTotal.get(docId) ?? 0;
          const share = totalDoc > 0 ? nota.valor / totalDoc : 0;
          const financeiroDoc = docFinanceiro.get(docId);
          if (financeiroDoc) {
            pago += financeiroDoc.pago * share;
            saldo += financeiroDoc.saldo * share;
          }
          valorFaturado += nota.valor;
          quantidadeFaturada += nota.quantidade;
          notas.push(nota);
        }

        notas.sort((a, b) =>
          (a.data ?? "").localeCompare(b.data ?? ""),
        );

        const item = byOp.get(opId);
        if (item) {
          item.faturamento = {
            valor_faturado: round2(valorFaturado),
            quantidade_faturada: round2(quantidadeFaturada),
            notas,
          };
          item.financeiro = {
            pago: round2(pago),
            saldo: round2(saldo),
          };
        }
      }
    }

    return {
      itens,
      total,
      pagina: input.pagina,
      totalPaginas: total === 0 ? 0 : Math.ceil(total / input.limite),
    };
  } catch (err) {
    fastify.log.error({ err }, "Wingraphex query failed");
    throw new AppError(503, "Banco Wingraphex indisponível.");
  }
}

export async function queryClientes(
  fastify: FastifyInstance,
  input: QueryClientesInput,
): Promise<WingraphexCliente[]> {
  const clauses = [
    "p.EMP_ID=1",
    "os.ORS_CANCELADA<>'S'",
    "os.CLI_ID=p.PES_ID",
  ];
  const params: (string | number)[] = [];

  if (input.term !== undefined && input.term !== "") {
    clauses.push("p.PES_NOME_RAZAO LIKE ?");
    params.push(`%${escapeLike(input.term)}%`);
  }

  const sql = `
    SELECT DISTINCT p.PES_ID AS id, p.PES_NOME_RAZAO AS nome
    FROM pessoa p
    JOIN ordemservico os ON os.EMP_ID=p.EMP_ID AND os.CLI_ID=p.PES_ID
    WHERE ${clauses.join(" AND ")}
    ORDER BY p.PES_NOME_RAZAO
    LIMIT ?`;

  params.push(input.limite);

  try {
    const [rows] = await fastify.wingraphex.query<WingraphexClienteDbRow[]>(
      sql,
      params,
    );
    return rows.map((row) => ({ id: Number(row.id), nome: row.nome }));
  } catch (err) {
    fastify.log.error({ err }, "Wingraphex clientes query failed");
    throw new AppError(503, "Banco Wingraphex indisponível.");
  }
}