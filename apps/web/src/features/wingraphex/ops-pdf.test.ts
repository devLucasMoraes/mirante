import { describe, expect, test } from "vitest";

import { criarPdfOps } from "./ops-pdf";
import { OPS_POR_FOLHA } from "./wingraphex.queries";
import { opFactory } from "./wingraphex.test-utils";

describe("criarPdfOps", () => {
  const contexto = { empresa: "ambas" as const };

  test("agrupa exatamente 15 OPs por folha A4", () => {
    const itens = Array.from({ length: 15 }, (_, index) =>
      opFactory({ op: index + 1 }),
    );
    expect(criarPdfOps(itens, contexto).getNumberOfPages()).toBe(1);
  });

  test("gera uma folha a cada 15 OPs", () => {
    const casos: Array<[number, number]> = [
      [16, 2],
      [30, 2],
      [31, 3],
      [45, 3],
      [46, 4],
    ];
    for (const [total, folhas] of casos) {
      const itens = Array.from({ length: total }, (_, index) =>
        opFactory({ op: index + 1 }),
      );
      expect(criarPdfOps(itens, contexto).getNumberOfPages()).toBe(folhas);
    }
  });

  test("expoe a constante de OPs por folha alinhada à paginação", () => {
    expect(OPS_POR_FOLHA).toBe(15);
  });
});