import { describe, expect, test } from "vitest";

import { empresaNome } from "./wingraphex.format";
import type { EmpresaFilter } from "./wingraphex.schemas";

describe("empresaNome", () => {
  test.each<EmpresaFilter | number>(["1", 1])(
    "empresa %s retorna o nome da Gráfica Plantão",
    (empresa) => {
      expect(empresaNome(empresa)).toBe("Gráfica Plantão");
    },
  );

  test.each<EmpresaFilter | number>(["2", 2])(
    "empresa %s retorna o nome da Editora Esquivel",
    (empresa) => {
      expect(empresaNome(empresa)).toBe("Editora Esquivel");
    },
  );

  test("empresa ambas retorna Ambas", () => {
    expect(empresaNome("ambas")).toBe("Ambas");
  });

  test("nunca retorna Emp 1 ou Emp 2", () => {
    const resultados = (["1", "2", 1, 2] as const).map((empresa) =>
      empresaNome(empresa),
    );
    expect(resultados).toEqual([
      "Gráfica Plantão",
      "Editora Esquivel",
      "Gráfica Plantão",
      "Editora Esquivel",
    ]);
    for (const resultado of resultados) {
      expect(resultado).not.toMatch(/Emp 1|Emp 2/);
    }
  });
});
