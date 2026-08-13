import {
  Card,
  CardContent,
} from "@repo/ui/components/card";

const TESTIMONIALS = [
  {
    quote:
      "O Mirante acabou com os relatórios manuais. Consigo ver a situação das OPs em segundos.",
    author: "Marina Souza",
    role: "Gerente de Produção",
  },
  {
    quote:
      "A adoção pelo time foi instantânea. É a única ferramenta que as pessoas realmente usam.",
    author: "Rafael Costa",
    role: "Coordenador de PCP",
  },
  {
    quote:
      "O tempo das consultas caiu 70%. Recomendo para qualquer gráfica que valorize resultado.",
    author: "Bianca Lima",
    role: "Analista Financeira",
  },
];

export function HomeTestimonials() {
  return (
    <section
      id="depoimentos"
      className="mx-auto max-w-7xl scroll-mt-20 px-6 py-24"
    >
      <div className="mb-14 max-w-2xl text-center">
        <h2 className="text-3xl font-bold tracking-tight md:text-4xl">
          Quem consulta, recomenda
        </h2>
        <p className="mt-4 text-muted-foreground">
          Equipes de gráficas já enxergam a produção com o Mirante.
        </p>
      </div>
      <div className="grid grid-cols-1 gap-6 md:grid-cols-3">
        {TESTIMONIALS.map((testimonial) => (
          <Card key={`${testimonial.author}-${testimonial.role}`}>
            <CardContent className="flex h-full flex-col justify-between p-6">
              <p className="text-muted-foreground">
                &ldquo;{testimonial.quote}&rdquo;
              </p>
              <div className="mt-6 flex items-center gap-3">
                <div className="flex size-10 items-center justify-center rounded-full bg-primary/10 text-sm font-semibold text-primary">
                  {testimonial.author.slice(0, 2)}
                </div>
                <div>
                  <p className="text-sm font-medium">{testimonial.author}</p>
                  <p className="text-xs text-muted-foreground">
                    {testimonial.role}
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>
    </section>
  );
}
