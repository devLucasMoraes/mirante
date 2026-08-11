import { ChevronDown } from "lucide-react";

const FAQ = [
  {
    question: "Posso testar antes de pagar?",
    answer:
      "Sim. Nossa os planos Pro incluem 14 dias de teste grátis, sem cartão de crédito.",
  },
  {
    question: "Funciona com as ferramentas que a gente já usa?",
    answer:
      "Sim. Temos integrações nativas com as ferramentas mais populares e uma API completa.",
  },
  {
    question: "Como funciona o plano Enterprise?",
    answer:
      "Suporte a SSO, auditoria e preços personalizados. Chame nosso time comercial.",
  },
];

export function HomeFaq() {
  return (
    <section id="faq" className="mx-auto max-w-3xl scroll-mt-20 px-6 py-24">
      <div className="mb-14 text-center">
        <h2 className="text-3xl font-bold tracking-tight md:text-4xl">
          Perguntas frequentes
        </h2>
      </div>
      <div className="space-y-3">
        {FAQ.map((item) => (
          <details
            key={item.question}
            className="group rounded-lg border border-border bg-card p-5 open:bg-accent/40"
          >
            <summary className="flex cursor-pointer list-none items-center justify-between gap-4 font-medium [&::-webkit-details-marker]:hidden">
              {item.question}
              <ChevronDown className="size-4 shrink-0 rotate-0 transition-transform group-open:rotate-180" />
            </summary>
            <p className="mt-3 text-sm text-muted-foreground">
              {item.answer}
            </p>
          </details>
        ))}
      </div>
    </section>
  );
}
