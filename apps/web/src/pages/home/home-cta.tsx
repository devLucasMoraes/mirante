import { Link } from "react-router";

import { ArrowRight, Rocket } from "lucide-react";

import { Button } from "@repo/ui/components/button";

export function HomeCta() {
  return (
    <section className="px-6 pb-24">
      <div className="mx-auto max-w-7xl overflow-hidden rounded-3xl bg-primary px-6 py-16 text-center text-primary-foreground md:py-20">
        <Rocket
          className="mx-auto mb-6 size-10 text-primary-foreground/80"
          aria-hidden="true"
        />
        <h2 className="mx-auto max-w-2xl text-3xl font-bold tracking-tight md:text-4xl">
          Pronto para trabalhar com mais leveza?
        </h2>
        <p className="mx-auto mt-4 max-w-xl text-primary-foreground/80">
          Fale com o administrador do sistema para solicitar seu acesso.
        </p>
        <div className="mt-8 flex flex-col items-center justify-center gap-3 sm:flex-row">
          <Button
            size="lg"
            variant="outline"
            className="bg-primary-foreground text-primary hover:bg-primary-foreground/90"
            asChild
          >
            <Link to="/login">
              Entrar
              <ArrowRight />
            </Link>
          </Button>
        </div>
      </div>
    </section>
  );
}
