import type { MySQLRowDataPacket } from "@fastify/mysql";
import type { FastifyInstance } from "fastify";

import { AppError } from "../lib/errors.ts";
import {
  PcpEquipamentoSetorModel,
  PcpSetorModel,
} from "../models/index.ts";
import type {
  EmpresaFilter,
  NotaFaturamento,
  WingraphexCliente,
  WingraphexOp,
  WingraphexOpsResponse,
} from "../schemas/wingraphex.schema.ts";

function empresaParams(empresa: EmpresaFilter): number[] {
  if (empresa === "1") return [1];
  if (empresa === "2") return [2];
  return [];
}

function itemKey(empId: number, id: number): string {
  return `${empId}:${id}`;
}

interface WingraphexOpDbRow extends MySQLRowDataPacket {
  op: string | number;
  emp_id: string | number;
  cliente: string | null;
  descricao: string | null;
  qtd_total: string | number | null;
  valor_servico: string | number | null;
  data_emissao: string | null;
  data_prevista: string | null;
  status: string | null;
  pcp_processos: string | number | null;
  pcp_finalizados: string | number | null;
}

interface DocIdDbRow extends MySQLRowDataPacket {
  emp_id: string | number;
  doc_id: string | number;
}

interface ItemNotaDbRow extends MySQLRowDataPacket {
  emp_id: string | number;
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
  emp_id: string | number;
  DOC_ID: number;
  VALOR: string | number | null;
  SALDO: string | number | null;
}

interface EquipamentoDbRow extends MySQLRowDataPacket {
  CODIGO: string | number;
  DESCRICAO: string | null;
}

interface PcpProcessoSetorDbRow extends MySQLRowDataPacket {
  op: string | number;
  emp_id: string | number;
  codigo: string | number;
  processos: string | number;
  finalizados: string | number;
}

interface PcpSetorProgresso {
  id: string;
  nome: string;
  ordem: number;
  processos: number;
  finalizados: number;
  finalizado: boolean;
}

export interface WingraphexEquipamento {
  codigo: number;
  nome: string;
}

export interface QueryOpsByDescriptionInput {
  descricao?: string;
  empresa: EmpresaFilter;
  clienteId?: number;
  dataInicio?: string;
  dataFim?: string;
  ordenarPor: "emissao" | "prevista";
  direcao: "asc" | "desc";
  pagina: number;
  limite: number;
}

interface WingraphexCountDbRow extends MySQLRowDataPacket {
  total: string | number;
}

export interface QueryClientesInput {
  term?: string;
  empresa: EmpresaFilter;
  limite: number;
}

interface WingraphexClienteDbRow extends MySQLRowDataPacket {
  id: number;
  nome: string;
  fantasia: string;
}

function escapeLike(value: string): string {
  return value.replace(/[\\%_]/g, (char) => `\\${char}`);
}

function buildOpsWhere(
  alias: string,
  opts: QueryOpsByDescriptionInput,
): { sql: string; params: (string | number)[] } {
  const col = (name: string): string => `${alias}.${name}`;
  const clauses = [`${col("ORS_CANCELADA")}<>'S'`];
  const params: (string | number)[] = [];

  const empIds = empresaParams(opts.empresa);
  const empId = empIds[0];
  if (empId !== undefined) {
    clauses.push(`${col("EMP_ID")} = ?`);
    params.push(empId);
  }

  if (opts.descricao !== undefined && opts.descricao.trim() !== "") {
    clauses.push(`${col("ORS_DESCRICAO")} LIKE ?`);
    params.push(`%${escapeLike(opts.descricao.trim())}%`);
  }

  if (opts.clienteId !== undefined) {
    clauses.push(`${col("CLI_ID")} = ?`);
    params.push(opts.clienteId);
  }

  return { sql: `WHERE ${clauses.join(" AND ")}`, params };
}

function buildOpsPeriod(
  column: string,
  opts: QueryOpsByDescriptionInput,
): { sql: string; params: (string | number)[] } {
  const clauses: string[] = [];
  const params: (string | number)[] = [];

  if (opts.dataInicio !== undefined) {
    clauses.push(`${column} >= ?`);
    params.push(opts.dataInicio);
  }
  if (opts.dataFim !== undefined) {
    clauses.push(`${column} <= ?`);
    params.push(opts.dataFim);
  }

  return {
    sql: clauses.length > 0 ? ` AND ${clauses.join(" AND ")}` : "",
    params,
  };
}

function buildOpsOrderBy(input: QueryOpsByDescriptionInput): string {
  const direction = input.direcao === "asc" ? "ASC" : "DESC";

  if (input.ordenarPor === "prevista") {
    return `ORDER BY planej.data_prevista IS NULL ASC, planej.data_prevista ${direction}, os.ORS_ID ${direction}`;
  }
  return `ORDER BY os.ORS_DATA ${direction}, os.ORS_ID ${direction}`;
}

function toNumber(value: string | number | null): number {
  return value === null ? 0 : Number(value);
}

function round2(value: number): number {
  return Math.round(value * 100) / 100;
}

function tuplePlaceholders(pairs: number): string {
  return Array.from({ length: pairs }, () => "(?,?)").join(",");
}

function toWingraphexOp(row: WingraphexOpDbRow): WingraphexOp {
  return {
    op: Number(row.op),
    empId: Number(row.emp_id),
    cliente: row.cliente ?? null,
    descricao: row.descricao ?? "",
    qtd_total: toNumber(row.qtd_total),
    entregue: 0,
    valor_servico: toNumber(row.valor_servico),
    data_emissao: row.data_emissao ?? "",
    data_prevista: row.data_prevista ?? null,
    status: row.status ?? "",
    faturamento: { valor_faturado: 0, quantidade_faturada: 0, notas: [] },
    financeiro: { pago: 0, saldo: 0 },
    pcp: {
      processos: toNumber(row.pcp_processos),
      finalizados: toNumber(row.pcp_finalizados),
      setores: [],
    },
  };
}

interface DocDocKey {
  empId: number;
  docId: number;
}

async function fetchNotaDocIds(
  fastify: FastifyInstance,
  itens: { empId: number; op: number }[],
): Promise<DocDocKey[]> {
  if (itens.length === 0) return [];
  const params = itens.flatMap((item) => [item.empId, String(item.op)]);
  const sql = `
    SELECT DISTINCT di.EMP_ID AS emp_id, di.DOC_ID AS doc_id
    FROM documentoitem di
    WHERE di.CLASSIFICACAO=0
      AND (di.EMP_ID, di.CODIGOORDEMPRODUCAO) IN (${tuplePlaceholders(itens.length)})`;
  const [rows] = await fastify.wingraphex.query<DocIdDbRow[]>(sql, params);
  return rows.map((row) => ({
    empId: Number(row.emp_id),
    docId: Number(row.doc_id),
  }));
}

async function fetchItemsForDocs(
  fastify: FastifyInstance,
  docKeys: DocDocKey[],
): Promise<ItemNotaDbRow[]> {
  if (docKeys.length === 0) return [];
  const params = docKeys.flatMap((doc) => [doc.empId, doc.docId]);
  const sql = `
    SELECT di.EMP_ID AS emp_id, di.DOC_ID, di.CODIGOORDEMPRODUCAO AS op,
           di.QUANTIDADE, di.VALORUNITARIO,
           dc.SERIENF, dc.NUMERONF, dc.NUMERODOCUMENTO,
           DATE(dc.DATAEMISSAO) AS data_emissao
    FROM documentoitem di
    JOIN documentocabecalho dc
      ON dc.EMP_ID=di.EMP_ID AND dc.CLASSIFICACAO=di.CLASSIFICACAO AND dc.DOC_ID=di.DOC_ID
    WHERE di.CLASSIFICACAO=0
      AND (di.EMP_ID, di.DOC_ID) IN (${tuplePlaceholders(docKeys.length)})
      AND (dc.CANCELADA<>'S' OR dc.CANCELADA IS NULL)`;
  const [rows] = await fastify.wingraphex.query<ItemNotaDbRow[]>(sql, params);
  return rows;
}

async function fetchFinanceiroForDocs(
  fastify: FastifyInstance,
  docKeys: DocDocKey[],
): Promise<FinanceiroNotaDbRow[]> {
  if (docKeys.length === 0) return [];
  const params = docKeys.flatMap((doc) => [doc.empId, doc.docId]);
  const sql = `
    SELECT f.EMP_ID AS emp_id, f.DOC_ID, f.VALOR, f.SALDO
    FROM financeiro f
    WHERE f.CLASSIFICACAO=0
      AND (f.EMP_ID, f.DOC_ID) IN (${tuplePlaceholders(docKeys.length)})
      AND f.ORIGEM='TOL_CONTASARECEBER'
      AND (f.FLAGLANCCANCELADO<>'S' OR f.FLAGLANCCANCELADO IS NULL)
      AND (f.ESTORNO<>'S' OR f.ESTORNO IS NULL)`;
  const [rows] = await fastify.wingraphex.query<FinanceiroNotaDbRow[]>(sql, params);
  return rows;
}

function buildDocValorTotal(items: ItemNotaDbRow[]): Map<string, number> {
  const byDoc = new Map<string, number>();
  for (const item of items) {
    const valor = toNumber(item.QUANTIDADE) * toNumber(item.VALORUNITARIO);
    const key = itemKey(Number(item.emp_id), Number(item.DOC_ID));
    byDoc.set(key, (byDoc.get(key) ?? 0) + valor);
  }
  return byDoc;
}

function buildDocFinanceiro(
  rows: FinanceiroNotaDbRow[],
): Map<string, { pago: number; saldo: number }> {
  const byDoc = new Map<string, { pago: number; saldo: number }>();
  for (const row of rows) {
    const key = itemKey(Number(row.emp_id), Number(row.DOC_ID));
    const current = byDoc.get(key) ?? { pago: 0, saldo: 0 };
    current.pago += toNumber(row.VALOR) - toNumber(row.SALDO);
    current.saldo += toNumber(row.SALDO);
    byDoc.set(key, current);
  }
  return byDoc;
}

async function fetchPcpProcessosPorEquipamento(
  fastify: FastifyInstance,
  itens: { empId: number; op: number }[],
): Promise<PcpProcessoSetorDbRow[]> {
  if (itens.length === 0) return [];
  const params = itens.flatMap((item) => [item.empId, String(item.op)]);
  const sql = `
    SELECT pc.EMP_ID AS emp_id, pc.CODIGOOP AS op, pc.CODIGOEQUIPAMENTO AS codigo,
           COUNT(*) AS processos, SUM(pc.STATUS='F') AS finalizados
    FROM pcpprocessos pc
    WHERE pc.CODIGOCOMPONENTE<>-1
      AND (pc.EMP_ID, pc.CODIGOOP) IN (${tuplePlaceholders(itens.length)})
    GROUP BY pc.CODIGOOP, pc.EMP_ID, pc.CODIGOEQUIPAMENTO`;
  const [rows] = await fastify.wingraphex.query<PcpProcessoSetorDbRow[]>(
    sql,
    params,
  );
  return rows;
}

async function enriquecerPcpComSetores(
  fastify: FastifyInstance,
  itens: WingraphexOp[],
): Promise<void> {
  const ops = itens.map((item) => ({ empId: item.empId, op: item.op }));
  let rows: PcpProcessoSetorDbRow[];
  try {
    rows = await fetchPcpProcessosPorEquipamento(fastify, ops);
  } catch (err) {
    fastify.log.error({ err }, "Pcp processos por equipamento query failed");
    throw new AppError(503, "Banco Wingraphex indisponível.");
  }
  if (rows.length === 0) return;

  const empIds = [...new Set(itens.map((item) => item.empId))];
  const [setores, vinculos] = await Promise.all([
    PcpSetorModel.find().sort({ ordem: 1 }).exec(),
    PcpEquipamentoSetorModel.find({ empId: { $in: empIds } })
      .select("empId codigoEquipamento setorId")
      .exec(),
  ]);

  const setorPorEquipamento = new Map<string, string>(
    vinculos.map((vinculo) => [
      itemKey(vinculo.empId, vinculo.codigoEquipamento),
      String(vinculo.setorId),
    ]),
  );

  const porOp = new Map<string, Map<number, { processos: number; finalizados: number }>>();
  for (const row of rows) {
    const key = itemKey(Number(row.emp_id), Number(row.op));
    const codigo = Number(row.codigo);
    const porCodigo = porOp.get(key) ?? new Map();
    porCodigo.set(codigo, {
      processos: toNumber(row.processos),
      finalizados: toNumber(row.finalizados),
    });
    porOp.set(key, porCodigo);
  }

  for (const item of itens) {
    const porCodigo = porOp.get(itemKey(item.empId, item.op));
    if (!porCodigo) continue;

    const setoresComProcessos: PcpSetorProgresso[] = [];
    for (const setor of setores) {
      let processos = 0;
      let finalizados = 0;
      for (const [codigo, agregado] of porCodigo) {
        if (setorPorEquipamento.get(itemKey(item.empId, codigo)) === setor.id) {
          processos += agregado.processos;
          finalizados += agregado.finalizados;
        }
      }
      if (processos === 0) continue;
      setoresComProcessos.push({
        id: setor.id,
        nome: setor.nome,
        ordem: setor.ordem,
        processos,
        finalizados,
        finalizado: finalizados === processos,
      });
    }

    item.pcp = {
      processos: item.pcp.processos,
      finalizados: item.pcp.finalizados,
      setores: setoresComProcessos,
    };
  }
}

export async function queryOpsByDescription(
  fastify: FastifyInstance,
  input: QueryOpsByDescriptionInput,
): Promise<WingraphexOpsResponse> {
  const byPrevista = input.ordenarPor === "prevista";

  const baseWhere = (alias: string) => buildOpsWhere(alias, input);
  const emissionPeriod = (alias: string) =>
    buildOpsPeriod(`${alias}.ORS_DATA`, input);
  const previstaPeriod = () =>
    buildOpsPeriod("planej.data_prevista", input);

  const mainWhere = baseWhere("os");
  const mainPeriod = byPrevista ? previstaPeriod() : emissionPeriod("os");
  const mainSql = `${mainWhere.sql}${mainPeriod.sql}`;
  const mainParams = [...mainWhere.params, ...mainPeriod.params];

  const planejWhere = baseWhere("os4");
  const planejPeriod = byPrevista
    ? { sql: "", params: [] }
    : emissionPeriod("os4");
  const planejSql = `${planejWhere.sql}${planejPeriod.sql}`;
  const planejParams = [...planejWhere.params, ...planejPeriod.params];

  const pcpWhere = baseWhere("os3");
  const pcpPeriod = byPrevista ? { sql: "", params: [] } : emissionPeriod("os3");
  const pcpSql = `${pcpWhere.sql}${pcpPeriod.sql}`;
  const pcpParams = [...pcpWhere.params, ...pcpPeriod.params];

  const offset = (input.pagina - 1) * input.limite;

  const planejJoin = `
    LEFT JOIN (
      SELECT ple.ORS_ID AS op, ple.EMP_ID AS emp_id,
             MIN(CASE WHEN ple.PLE_DATAENTREGA >= '2000-01-01'
                      THEN DATE(ple.PLE_DATAENTREGA) END) AS data_prevista
      FROM ordemservplanejentrega ple
      WHERE (ple.EMP_ID, ple.ORS_ID) IN (
        SELECT os4.EMP_ID, os4.ORS_ID FROM ordemservico os4 ${planejSql}
      )
      GROUP BY ple.ORS_ID, ple.EMP_ID
    ) planej ON planej.op=os.ORS_ID AND planej.emp_id=os.EMP_ID`;

  const countSql = `
    SELECT COUNT(*) AS total
    FROM ordemservico os
    JOIN op o ON o.EMP_ID=os.EMP_ID AND o.ORS_ID=os.ORS_ID
    ${byPrevista ? planejJoin : ""}
    ${mainSql}`;
  const countParams = byPrevista
    ? [...planejParams, ...mainParams]
    : mainParams;

  const sql = `
    SELECT os.ORS_ID AS op,
           os.EMP_ID AS emp_id,
           (SELECT CONCAT_WS(' / ',
                   NULLIF(TRIM(p.PES_NOME_RAZAO), ''),
                   NULLIF(NULLIF(TRIM(p.PES_NOMEFANTASIA), ''), TRIM(p.PES_NOME_RAZAO)))
            FROM pessoa p WHERE p.EMP_ID=os.EMP_ID AND p.PES_ID=os.CLI_ID LIMIT 1) AS cliente,
           os.ORS_DESCRICAO AS descricao,
           os.ORS_QUANTIDADE AS qtd_total,
           ROUND(os.ORS_VLRFINALPRAZO,2) AS valor_servico,
           DATE(os.ORS_DATA) AS data_emissao,
           planej.data_prevista AS data_prevista,
           os.ORS_STATUSFATURAMENTO AS status,
           COALESCE(pcp.processos,0) AS pcp_processos,
           COALESCE(pcp.finalizados,0) AS pcp_finalizados
    FROM ordemservico os
    JOIN op o ON o.EMP_ID=os.EMP_ID AND o.ORS_ID=os.ORS_ID
    ${planejJoin}
    LEFT JOIN (
      SELECT pc.CODIGOOP AS op, pc.EMP_ID AS emp_id,
             COUNT(*) AS processos, SUM(pc.STATUS='F') AS finalizados
      FROM pcpprocessos pc
      WHERE pc.CODIGOCOMPONENTE<>-1
        AND (pc.EMP_ID, pc.CODIGOOP) IN (
          SELECT os3.EMP_ID, os3.ORS_ID FROM ordemservico os3 ${pcpSql}
        )
      GROUP BY pc.CODIGOOP, pc.EMP_ID
    ) pcp ON pcp.op=os.ORS_ID AND pcp.emp_id=os.EMP_ID
    ${mainSql}
    ${buildOpsOrderBy(input)}
    LIMIT ? OFFSET ?`;

  const params = [
    ...planejParams,
    ...pcpParams,
    ...mainParams,
    input.limite,
    offset,
  ];

  let itens: WingraphexOp[] = [];
  let total = 0;

  try {
    const [countRows] = await fastify.wingraphex.query<WingraphexCountDbRow[]>(
      countSql,
      countParams,
    );
    total = Number(countRows[0]?.total ?? 0);

    const [rows] = await fastify.wingraphex.query<WingraphexOpDbRow[]>(
      sql,
      params,
    );
    itens = rows.map(toWingraphexOp);

    if (itens.length > 0) {
      const ops = itens.map((item) => ({ empId: item.empId, op: item.op }));
      const byKey = new Map<string, WingraphexOp>(
        itens.map((item) => [itemKey(item.empId, item.op), item]),
      );
      const docKeys = await fetchNotaDocIds(fastify, ops);
      const [items, financeiroRows] = await Promise.all([
        fetchItemsForDocs(fastify, docKeys),
        fetchFinanceiroForDocs(fastify, docKeys),
      ]);

      const docValorTotal = buildDocValorTotal(items);
      const docFinanceiro = buildDocFinanceiro(financeiroRows);
      const pageOps = new Set(ops.map((op) => itemKey(op.empId, op.op)));

      const comItens = new Map<string, Map<string, NotaFaturamento>>();
      for (const item of items) {
        const itemEmpId = Number(item.emp_id);
        const opId = Number(item.op);
        const opKey = itemKey(itemEmpId, opId);
        if (item.op === null || item.op === "" || !pageOps.has(opKey)) {
          continue;
        }
        const valor = toNumber(item.QUANTIDADE) * toNumber(item.VALORUNITARIO);
        const quantidade = toNumber(item.QUANTIDADE);
        const docKey = itemKey(itemEmpId, Number(item.DOC_ID));
        const porDoc = comItens.get(opKey) ?? new Map<string, NotaFaturamento>();
        const nota = porDoc.get(docKey) ?? {
          serie: item.SERIENF ?? null,
          numero: String(item.NUMERONF ?? item.NUMERODOCUMENTO ?? item.DOC_ID),
          data: item.data_emissao ?? null,
          valor: 0,
          quantidade: 0,
        };
        nota.valor += valor;
        nota.quantidade += quantidade;
        porDoc.set(docKey, nota);
        comItens.set(opKey, porDoc);
      }

      for (const item of itens) {
        const porDoc = comItens.get(itemKey(item.empId, item.op));
        if (!porDoc) continue;

        let valorFaturado = 0;
        let quantidadeFaturada = 0;
        let pago = 0;
        let saldo = 0;
        const notas: NotaFaturamento[] = [];

        for (const [docKey, nota] of porDoc) {
          const totalDoc = docValorTotal.get(docKey) ?? 0;
          const share = totalDoc > 0 ? nota.valor / totalDoc : 0;
          const financeiroDoc = docFinanceiro.get(docKey);
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

        const dbItem = byKey.get(itemKey(item.empId, item.op));
        if (dbItem) {
          dbItem.faturamento = {
            valor_faturado: round2(valorFaturado),
            quantidade_faturada: round2(quantidadeFaturada),
            notas,
          };
          dbItem.financeiro = {
            pago: round2(pago),
            saldo: round2(saldo),
          };
        }
      }
    }
  } catch (err) {
    fastify.log.error({ err }, "Wingraphex query failed");
    throw new AppError(503, "Banco Wingraphex indisponível.");
  }

  if (itens.length > 0) {
    await enriquecerPcpComSetores(fastify, itens);
  }

  return {
    itens,
    total,
    pagina: input.pagina,
    totalPaginas: total === 0 ? 0 : Math.ceil(total / input.limite),
  };
}

export async function queryEquipamentos(
  fastify: FastifyInstance,
): Promise<WingraphexEquipamento[]> {
  const sql = `
    SELECT CODIGO, DESCRICAO
    FROM equipamento
    WHERE EMP_ID=1 AND (DESATIVADO IS NULL OR DESATIVADO <> 'S') AND CODIGO > 0
    ORDER BY CODIGO`;

  try {
    const [rows] = await fastify.wingraphex.query<EquipamentoDbRow[]>(sql);
    return rows
      .filter((row) => Number(row.CODIGO) > 0)
      .map((row) => ({
        codigo: Number(row.CODIGO),
        nome: row.DESCRICAO ?? "",
      }));
  } catch (err) {
    fastify.log.error({ err }, "Wingraphex equipamentos query failed");
    throw new AppError(503, "Banco Wingraphex indisponível.");
  }
}

export async function queryClientes(
  fastify: FastifyInstance,
  input: QueryClientesInput,
): Promise<WingraphexCliente[]> {
  const clauses = [
    "os.ORS_CANCELADA<>'S'",
    "os.CLI_ID=p.PES_ID",
  ];
  const params: (string | number)[] = [];

  const empIds = empresaParams(input.empresa);
  const empId = empIds[0];
  if (empId !== undefined) {
    clauses.push("p.EMP_ID = ?");
    params.push(empId);
  }

  if (input.term !== undefined && input.term !== "") {
    clauses.push("(p.PES_NOME_RAZAO LIKE ? OR p.PES_NOMEFANTASIA LIKE ?)");
    params.push(`%${escapeLike(input.term)}%`, `%${escapeLike(input.term)}%`);
  }

  const sql = `
    SELECT DISTINCT
      p.PES_ID AS id,
      p.PES_NOME_RAZAO AS nome,
      p.PES_NOMEFANTASIA AS fantasia
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
    return rows.map((row) => ({
      id: Number(row.id),
      nome: row.nome,
      fantasia: row.fantasia,
    }));
  } catch (err) {
    fastify.log.error({ err }, "Wingraphex clientes query failed");
    throw new AppError(503, "Banco Wingraphex indisponível.");
  }
}