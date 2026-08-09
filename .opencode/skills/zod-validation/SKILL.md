---
name: zod-validation
description: Use ao criar, revisar ou refatorar validação de dados e tipos em TypeScript/JavaScript com Zod (schemas, parse/safeParse, inferência de tipos, formulários, validação de API, variáveis de ambiente). Aciona em pedidos como "valida esse input com Zod", "cria um schema Zod para X", "por que meu z.infer não bate com o tipo", ou qualquer menção a z.object, z.string, ZodError, etc.
license: MIT
---

# Zod — validação de schemas em TypeScript

Zod é uma biblioteca TypeScript-first de declaração e validação de schemas. Você declara um schema uma vez e Zod cuida da validação em runtime **e** da inferência estática de tipos — nunca escreva a interface TypeScript e o schema de validação separadamente; derive o tipo do schema.

Sempre importe como `import * as z from "zod"` (Zod 4).

## Fluxo de trabalho

1. **Modele o schema primeiro.** Comece pelo formato de dado esperado (payload de API, form, env var), não pelo tipo TS.
2. **Derive o tipo com `z.infer<>`** em vez de escrever uma interface paralela.
3. **Escolha `parse` vs `safeParse`** conforme o contexto (ver abaixo).
4. **Prefira os validadores nativos do Zod** (`.email()`, `.url()`, `.uuid()`, etc.) a regex customizada, a menos que haja um motivo específico.
5. **Não lance dentro de `.refine()`** — refinements retornam falso, nunca `throw`.

## Definindo schemas

```ts
import * as z from "zod";

const Player = z.object({
  username: z.string(),
  xp: z.number(),
});

type Player = z.infer<typeof Player>;
```

### Primitivos e coerção

```ts
z.string(); z.number(); z.bigint(); z.boolean(); z.symbol(); z.undefined(); z.null();

// coerção — converte o input em vez de só validar o tipo
z.coerce.string();  // String(input)
z.coerce.number();  // Number(input)
z.coerce.boolean(); // Boolean(input)
```

### Strings — validações e formatos comuns

```ts
z.string().min(5).max(20);
z.string().regex(/^[a-z]+$/);
z.string().trim().toLowerCase();

// formatos prontos — sempre prefira a estes a escrever regex do zero
z.email();
z.url();
z.uuid();          // ou z.uuid({ version: "v4" })
z.iso.date();       // "2020-01-01"
z.iso.datetime();   // ISO 8601, sem offset por padrão
z.iso.time();
z.e164();           // telefone formato E.164
```

### Números, enums, literais

```ts
z.number().int().positive();
z.enum(["Salmon", "Tuna", "Trout"]);   // passe o array literal direto, ou use `as const`
z.literal("tuna");
z.literal(["red", "green", "blue"]);   // múltiplos literais permitidos
```

### Objetos

```ts
// padrão: chaves desconhecidas são removidas silenciosamente do resultado
const Dog = z.object({ name: z.string(), age: z.number().optional() });

z.strictObject({ name: z.string() });  // erro se houver chave desconhecida
z.looseObject({ name: z.string() });   // deixa passar chaves desconhecidas

Dog.pick({ name: true });
Dog.omit({ age: true });
Dog.partial();                          // todos os campos opcionais
Dog.required();

// para estender, prefira spread ao invés de .extend() quando possível
const DogWithBreed = z.object({ ...Dog.shape, breed: z.string() });
```

Para objetos recursivos, use um getter:

```ts
const Category = z.object({
  name: z.string(),
  get subcategories() {
    return z.array(Category);
  },
});
```

### Arrays, tuplas, uniões

```ts
z.array(z.string()).min(1).max(10);
z.tuple([z.string(), z.number(), z.boolean()]);
z.union([z.string(), z.number()]);

// union discriminada — sempre prefira quando as opções compartilham uma chave
z.discriminatedUnion("status", [
  z.object({ status: z.literal("success"), data: z.string() }),
  z.object({ status: z.literal("failed"), error: z.string() }),
]);
```

### Opcional, anulável, nullish

```ts
z.string().optional(); // permite undefined
z.string().nullable();  // permite null
z.string().nullish();   // permite ambos
```

## Parsing — parse vs safeParse

- `.parse(data)` — retorna os dados tipados ou **lança** `ZodError`. Use quando um input inválido é um erro de programação/sistema (ex.: validar env vars na inicialização).
- `.safeParse(data)` — retorna `{ success, data }` ou `{ success: false, error }`, sem lançar. Use para input de usuário (formulários, corpo de requisição HTTP) onde você precisa tratar o erro graciosamente.
- Se o schema usa `async` refine/transform, use `.parseAsync()` / `.safeParseAsync()` — caso contrário Zod lança.

```ts
const result = Player.safeParse(payload);
if (!result.success) {
  // result.error é um ZodError; result.error.issues é o array de problemas
  return { error: result.error.issues };
}
return result.data; // tipado como Player
```

## Tratamento de erros

```ts
try {
  Player.parse({ username: 42, xp: "100" });
} catch (err) {
  if (err instanceof z.ZodError) {
    err.issues; // [{ code, path, message, ... }]
  }
}
```

## Transforms, refinements, defaults

```ts
// refine: validação custom — NUNCA lance, retorne falso
z.string().refine((v) => v.length <= 255, { error: "Muito longo" });

// refine com múltiplos issues
z.array(z.string()).superRefine((val, ctx) => {
  if (val.length > 3) {
    ctx.addIssue({ code: "too_big", maximum: 3, origin: "array", inclusive: true, input: val, message: "Máximo 3 itens" });
  }
});

// transform: muda o tipo/valor de saída
const stringToLength = z.string().transform((v) => v.length);

// default: usado quando input é undefined
z.string().default("tuna");

// coerção de env vars tipo "true"/"1"/"yes" → boolean
z.stringbool();
```

Para tipos de entrada e saída divergentes (por causa de `.transform()`):

```ts
type In = z.input<typeof schema>;
type Out = z.output<typeof schema>; // == z.infer<typeof schema>
```

## Erros comuns a evitar

- Declarar uma `interface`/`type` TypeScript **e** um schema Zod separadamente para a mesma entidade — derive sempre com `z.infer<typeof Schema>`.
- Passar uma variável (não um array literal) para `z.enum()` — perde a inferência exata dos valores; passe o array diretamente ou use `as const`.
- Usar `.extend()` em schemas que já têm `.refine()` — vai lançar erro; use `.safeExtend()`.
- Lançar exceções dentro de `.refine()`/`.transform()` — sempre retorne um valor falso ou empurre para `ctx.issues`.
- Usar `.parse()` para validar input de usuário não confiável em vez de `.safeParse()`, deixando a exceção vazar sem tratamento.
- Escrever regex manual para email, URL, UUID, datas ISO quando já existe `z.email()`, `z.url()`, `z.uuid()`, `z.iso.date()`, etc.

## Referência completa

Para APIs menos comuns não cobertas aqui (records, maps, sets, codecs, branded types, z.function, template literals, intersections), busque na documentação oficial: https://zod.dev/api