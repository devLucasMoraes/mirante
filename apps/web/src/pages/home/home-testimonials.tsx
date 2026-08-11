import {
  Card,
  CardContent,
} from "@repo/ui/components/card";

const TESTIMONIALS = [
  {
    quote:
      "A acme transformou a forma como coordenamos nossos projetos. Economizamos horas toda semana.",
    author: "Marina Souza",
    role: "Head of Product, Nimbus",
  },
  {
    quote:
      "A adoção pelo time foi instantânea. É a única ferramenta que as pessoas realmente usam.",
    author: "Rafael Costa",
    role: "CTO, Ledger",
  },
  {
    quote:
      "O tempo de relatório caiu 70%. Recomendo para qualquer equipe que valorize resultado.",
    author: "Bianca Lima",
    role: "Gerente de Ops, Fastlane",
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
          Quem usa, recomenda
        </h2>
        <p className="mt-4 text-muted-foreground">
          Mais de 10.000 equipes já escolheram a acme.
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
