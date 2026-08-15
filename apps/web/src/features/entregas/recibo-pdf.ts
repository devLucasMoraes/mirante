import { jsPDF } from "jspdf";
import autoTable from "jspdf-autotable";

import type { ReciboEntrega } from "./entrega.schemas";

function formatDate(value: string): string {
  const [year, month, day] = value.split("-").map(Number);
  if (
    year === undefined ||
    month === undefined ||
    day === undefined ||
    Number.isNaN(year) ||
    Number.isNaN(month) ||
    Number.isNaN(day)
  ) {
    return value || "—";
  }
  return new Intl.DateTimeFormat("pt-BR").format(new Date(year, month - 1, day));
}

function formatQuantity(value: number): string {
  return new Intl.NumberFormat("pt-BR", {
    maximumFractionDigits: 0,
  }).format(value);
}

export function criarPdfRecibo(recibo: ReciboEntrega): jsPDF {
  const doc = new jsPDF({ unit: "mm", format: "a4" });

  doc.setFont("helvetica", "bold");
  doc.setFontSize(16);
  doc.text("Recibo de Entrega", 14, 20);

  doc.setFont("helvetica", "normal");
  doc.setFontSize(10);

  doc.text(`Recibo nº ${recibo.numero}`, 14, 30);
  doc.text(`Data de entrega: ${formatDate(recibo.dataEntrega)}`, 14, 36);
  doc.text(`Entregador: ${recibo.usuario.nome}`, 14, 42);

  autoTable(doc, {
    startY: 48,
    head: [["OP", "Cliente", "Descrição", "Quantidade"]],
    body: recibo.itens.map((item) => [
      String(item.op),
      item.cliente ?? "—",
      item.descricao,
      formatQuantity(item.quantidade),
    ]),
    styles: { fontSize: 9 },
    headStyles: {
      fillColor: [38, 38, 38],
      textColor: [255, 255, 255],
      fontStyle: "bold",
    },
    alternateRowStyles: { fillColor: [245, 245, 245] },
    margin: { left: 14, right: 14 },
  });

  const tableFinalY =
    (doc as unknown as { lastAutoTable?: { finalY?: number } }).lastAutoTable
      ?.finalY ?? 48;

  const pageWidth = doc.internal.pageSize.getWidth();
  doc.setFont("helvetica", "normal");
  doc.setFontSize(10);
  doc.setTextColor(0, 0, 0);

  const declaracaoLinhas = doc.splitTextToSize(
    "Declaro ter recebido os itens acima descritos, em perfeitas condições, dando quitação do recebimento.",
    pageWidth - 28,
  );
  doc.text(declaracaoLinhas, 14, tableFinalY + 14);

  const assinaturaY = tableFinalY + 14 + declaracaoLinhas.length * 5 + 24;
  doc.setLineWidth(0.3);
  doc.line(14, assinaturaY, pageWidth - 14, assinaturaY);
  doc.text("Assinatura do cliente", pageWidth / 2, assinaturaY + 6, {
    align: "center",
  });

  const pageHeight = doc.internal.pageSize.getHeight();
  doc.setFont("helvetica", "normal");
  doc.setFontSize(8);
  doc.setTextColor(120, 120, 120);
  doc.text(
    "Mirante — controle de entregas",
    14,
    pageHeight - 10,
  );

  return doc;
}

export function gerarPdfRecibo(recibo: ReciboEntrega): void {
  criarPdfRecibo(recibo).save(`recibo-entrega-${recibo.numero}.pdf`);
}

export function imprimirPdfRecibo(recibo: ReciboEntrega): void {
  const doc = criarPdfRecibo(recibo);
  doc.autoPrint();
  doc.output("dataurlnewwindow");
}