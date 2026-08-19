import { jsPDF } from "jspdf";
import autoTable from "jspdf-autotable";

import { useCompanySettingsStore } from "@/features/company-settings/company-settings.store";

import { empresaNome, formatCurrency, formatDate, formatQuantity } from "./wingraphex.format";
import { OPS_POR_FOLHA } from "./wingraphex.queries";
import type { EmpresaFilter, WingraphexOp } from "./wingraphex.schemas";

export type ImpressaoOpsContexto = {
  descricao?: string;
  clienteNome?: string;
  empresa: EmpresaFilter;
  dataInicio?: string;
  dataFim?: string;
};

const PAGE_WIDTH = 210;
const PAGE_HEIGHT = 297;
const MARGIN_X = 10;
const CONTENT_WIDTH = PAGE_WIDTH - MARGIN_X * 2;

const TITLE_Y = 18;
const CRITERIA_START_Y = 26;
const CRITERIA_STEP = 4;
const FONT_SIZE_CRITERIA = 8.5;
const FONT_SIZE_HEAD = 8;
const FONT_SIZE_BODY = 7.5;
const CELL_PADDING = 1.2;
const MAX_TEXT_LINHAS = 4;
const MIN_ROW_HEIGHT = 14;
const DESCRICAO_WIDTH = 66;
const TABLE_STEP_AFTER_DATA = 6;

const COLUMNS = [
  { key: "emissaoOp", label: "Emissão / OP", width: 28, halign: "left" as const, bold: false },
  { key: "descricao", label: "Descrição", width: DESCRICAO_WIDTH, halign: "left" as const, bold: false },
  { key: "qtdEntregue", label: "Qtd / Entregue", width: 16, halign: "right" as const, bold: false },
  { key: "valor", label: "Valor", width: 26, halign: "right" as const, bold: false },
  { key: "faturado", label: "Qtd faturada / Valor faturado", width: 28, halign: "right" as const, bold: false },
  { key: "financeiro", label: "A pagar / Pago", width: 26, halign: "right" as const, bold: false },
] as const;

function truncarTexto(doc: jsPDF, texto: string, maxWidth: number): string {
  const lines: string[] = doc.splitTextToSize(texto, maxWidth);
  const visiveis = lines.slice(0, MAX_TEXT_LINHAS);
  if (lines.length > MAX_TEXT_LINHAS) {
    const ultima = (visiveis[MAX_TEXT_LINHAS - 1] ?? "").replace(/\s+$/, "");
    const recortada =
      (doc.splitTextToSize(ultima, maxWidth - 2)[0] ?? "").replace(/\s+$/, "");
    visiveis[MAX_TEXT_LINHAS - 1] = `${recortada}…`;
  }
  return visiveis.join("\n");
}

function rowValues(doc: jsPDF, op: WingraphexOp): string[] {
  const descricaoMaxWidth = DESCRICAO_WIDTH - CELL_PADDING * 2;
  return [
    `${formatDate(op.data_emissao)}\n${op.op}`,
    truncarTexto(doc, op.descricao || "—", descricaoMaxWidth),
    `${formatQuantity(op.qtd_total)}\n${formatQuantity(op.entregue)}`,
    formatCurrency(op.valor_servico),
    `${formatQuantity(op.faturamento.quantidade_faturada)}\n${formatCurrency(op.faturamento.valor_faturado)}`,
    `${formatCurrency(op.financeiro.saldo)}\n${formatCurrency(op.financeiro.pago)}`,
  ];
}

type TotaisOps = {
  qtdTotal: number;
  entregue: number;
  valorServico: number;
  qtdFaturada: number;
  valorFaturado: number;
  aPagar: number;
  pago: number;
};

function calcularTotais(itens: WingraphexOp[]): TotaisOps {
  return itens.reduce(
    (totais, op) => {
      totais.qtdTotal += op.qtd_total;
      totais.entregue += op.entregue;
      totais.valorServico += op.valor_servico;
      totais.qtdFaturada += op.faturamento.quantidade_faturada;
      totais.valorFaturado += op.faturamento.valor_faturado;
      totais.aPagar += op.financeiro.saldo;
      totais.pago += op.financeiro.pago;
      return totais;
    },
    {
      qtdTotal: 0,
      entregue: 0,
      valorServico: 0,
      qtdFaturada: 0,
      valorFaturado: 0,
      aPagar: 0,
      pago: 0,
    },
  );
}

function totaisValues(totais: TotaisOps): string[] {
  return [
    "TOTAL",
    "",
    `${formatQuantity(totais.qtdTotal)}\n${formatQuantity(totais.entregue)}`,
    formatCurrency(totais.valorServico),
    `${formatQuantity(totais.qtdFaturada)}\n${formatCurrency(totais.valorFaturado)}`,
    `${formatCurrency(totais.aPagar)}\n${formatCurrency(totais.pago)}`,
  ];
}

function buildContextoLinhas(doc: jsPDF, contexto: ImpressaoOpsContexto): string[] {
  const partes: string[] = [];
  if (contexto.descricao) {
    partes.push(`Termo: "${contexto.descricao}"`);
  }
  if (contexto.clienteNome) {
    partes.push(`Cliente: ${contexto.clienteNome}`);
  }
  partes.push(
    `Empresa: ${
      contexto.empresa === "ambas" ? "Ambas" : empresaNome(contexto.empresa)
    }`,
  );
  if (contexto.dataInicio !== undefined || contexto.dataFim !== undefined) {
    const inicio = contexto.dataInicio;
    const fim = contexto.dataFim;
    let periodo: string;
    if (inicio !== undefined && fim !== undefined) {
      periodo = `${formatDate(inicio)} a ${formatDate(fim)}`;
    } else if (inicio !== undefined) {
      periodo = `a partir de ${formatDate(inicio)}`;
    } else if (fim !== undefined) {
      periodo = `até ${formatDate(fim)}`;
    } else {
      periodo = "";
    }
    partes.push(`Período: ${periodo}`);
  }
  return doc.splitTextToSize(partes.join("  ·  "), CONTENT_WIDTH);
}

function drawSheetHeader(
  doc: jsPDF,
  linhasContexto: string[],
  dataY: number,
) {
  doc.setFont("helvetica", "bold");
  doc.setFontSize(14);
  doc.setTextColor(20, 20, 20);
  doc.text("Ordens de produção", MARGIN_X, TITLE_Y);

  doc.setFont("helvetica", "normal");
  doc.setFontSize(FONT_SIZE_CRITERIA);
  doc.setTextColor(80, 80, 80);
  linhasContexto.forEach((linha, index) => {
    doc.text(linha, MARGIN_X, CRITERIA_START_Y + index * CRITERIA_STEP);
  });

  doc.setFontSize(8);
  doc.setTextColor(120, 120, 120);
  const geradoEm = new Intl.DateTimeFormat("pt-BR", {
    dateStyle: "short",
    timeStyle: "short",
  }).format(new Date());
  doc.text(`Gerado em ${geradoEm}`, MARGIN_X, dataY);
}

function drawFooter(doc: jsPDF, pagina: number, totalPaginas: number) {
  doc.setFont("helvetica", "normal");
  doc.setFontSize(8);
  doc.setTextColor(120, 120, 120);

  const companyName =
    useCompanySettingsStore.getState().branding.companyName;
  doc.text(`${companyName} — ordens de produção`, MARGIN_X, PAGE_HEIGHT - 8);
  doc.text(`Página ${pagina} de ${totalPaginas}`, PAGE_WIDTH / 2, PAGE_HEIGHT - 8, {
    align: "center",
  });
}

function drawTabela(
  doc: jsPDF,
  itens: WingraphexOp[],
  tableTop: number,
  totais?: string[],
) {
  const columnStyles: Record<string, {
    cellWidth: number;
    halign: "left" | "right";
    fontStyle: "bold" | "normal";
  }> = {};
  COLUMNS.forEach((col, index) => {
    columnStyles[String(index)] = {
      cellWidth: col.width,
      halign: col.halign,
      fontStyle: col.bold ? "bold" : "normal",
    };
  });

  autoTable(doc, {
    startY: tableTop,
    margin: {
      top: tableTop - 5,
      left: MARGIN_X,
      right: MARGIN_X,
      bottom: 12,
    },
    theme: "striped",
    head: [COLUMNS.map((col) => col.label)],
    body: itens.map((op) => rowValues(doc, op)),
    styles: {
      font: "helvetica",
      fontStyle: "normal",
      fontSize: FONT_SIZE_BODY,
      cellPadding: CELL_PADDING,
      minCellHeight: MIN_ROW_HEIGHT,
      valign: "middle",
      overflow: "linebreak",
      lineColor: [229, 231, 235],
      lineWidth: 0.2,
      textColor: [20, 20, 20],
      fillColor: [255, 255, 255],
    },
    headStyles: {
      fillColor: [38, 38, 38],
      textColor: [255, 255, 255],
      fontStyle: "bold",
      fontSize: FONT_SIZE_HEAD,
      cellPadding: CELL_PADDING,
    },
    alternateRowStyles: {
      fillColor: [245, 245, 245],
    },
    columnStyles,
    showHead: "firstPage",
    ...(totais !== undefined
      ? {
          foot: [totais],
          footStyles: {
            fillColor: [229, 229, 229],
            textColor: [20, 20, 20],
            fontStyle: "bold",
            fontSize: FONT_SIZE_BODY,
            cellPadding: CELL_PADDING,
          },
        }
      : {}),
  });
}

export function criarPdfOps(
  itens: WingraphexOp[],
  contexto: ImpressaoOpsContexto,
): jsPDF {
  const doc = new jsPDF({ unit: "mm", format: "a4" });
  doc.setProperties({ title: "Ordens de produção" });

  doc.setFont("helvetica", "normal");
  doc.setFontSize(FONT_SIZE_CRITERIA);
  const linhasContexto = buildContextoLinhas(doc, contexto);
  const dataY = CRITERIA_START_Y + linhasContexto.length * CRITERIA_STEP;
  const tableTop = dataY + TABLE_STEP_AFTER_DATA;

  const totalPaginas = Math.max(1, Math.ceil(itens.length / OPS_POR_FOLHA));
  const totais = calcularTotais(itens);

  for (let p = 0; p < totalPaginas; p++) {
    if (p > 0) {
      doc.addPage();
    }
    const paginaItens = itens.slice(
      p * OPS_POR_FOLHA,
      (p + 1) * OPS_POR_FOLHA,
    );
    drawSheetHeader(doc, linhasContexto, dataY);
    drawTabela(
      doc,
      paginaItens,
      tableTop,
      p === totalPaginas - 1 && itens.length > 0
        ? totaisValues(totais)
        : undefined,
    );
    drawFooter(doc, p + 1, totalPaginas);
  }

  return doc;
}

export function gerarPdfOps(
  itens: WingraphexOp[],
  contexto: ImpressaoOpsContexto,
): void {
  criarPdfOps(itens, contexto).save("ordens-de-producao.pdf");
}

export function imprimirPdfOps(
  itens: WingraphexOp[],
  contexto: ImpressaoOpsContexto,
): void {
  const doc = criarPdfOps(itens, contexto);
  doc.autoPrint();
  doc.output("dataurlnewwindow");
}