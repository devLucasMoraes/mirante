import { ChevronLeft, ChevronRight } from "lucide-react";

import {
  Pagination,
  PaginationContent,
  PaginationEllipsis,
  PaginationItem,
  PaginationLink,
} from "@repo/ui/components/pagination";
import { cn } from "@repo/ui/lib/utils";

export type PageItem = number | "ellipsis";

export function getPageItems(
  pagina: number,
  totalPaginas: number,
): PageItem[] {
  const candidates = new Set<number>([
    1,
    totalPaginas,
    pagina - 1,
    pagina,
    pagina + 1,
  ]);
  const pages = [...candidates]
    .filter((page) => page >= 1 && page <= totalPaginas)
    .sort((a, b) => a - b);

  const items: PageItem[] = [];
  let previous = 0;
  for (const page of pages) {
    if (page - previous === 1) {
      items.push(page);
    } else if (page - previous === 2) {
      items.push(previous + 1);
      items.push(page);
    } else {
      items.push("ellipsis");
      items.push(page);
    }
    previous = page;
  }
  return items;
}

export function OpsPagination({
  pagina,
  totalPaginas,
  onPageChange,
}: {
  pagina: number;
  totalPaginas: number;
  onPageChange: (page: number) => void;
}) {
  const canPrevious = pagina > 1;
  const canNext = pagina < totalPaginas;

  const goTo =
    (page: number) => (event: React.MouseEvent<HTMLAnchorElement>) => {
      event.preventDefault();
      onPageChange(page);
    };

  return (
    <Pagination aria-label="Paginação dos resultados">
      <PaginationContent>
        <PaginationItem>
          <PaginationLink
            href="#"
            size="default"
            aria-label="Página anterior"
            className={cn(
              "gap-1 px-2.5 sm:pl-2.5",
              !canPrevious && "pointer-events-none opacity-50",
            )}
            onClick={goTo(pagina - 1)}
          >
            <ChevronLeft className="size-4" />
            <span className="hidden sm:block">Anterior</span>
          </PaginationLink>
        </PaginationItem>

        {getPageItems(pagina, totalPaginas).map((item, index) =>
          item === "ellipsis" ? (
            <PaginationItem key={`ellipsis-${index}`}>
              <PaginationEllipsis aria-label="Mais páginas" />
            </PaginationItem>
          ) : (
            <PaginationItem key={item}>
              <PaginationLink
                href="#"
                isActive={item === pagina}
                aria-label={`Página ${item}`}
                onClick={goTo(item)}
              >
                {item}
              </PaginationLink>
            </PaginationItem>
          ),
        )}

        <PaginationItem>
          <PaginationLink
            href="#"
            size="default"
            aria-label="Próxima página"
            className={cn(
              "gap-1 px-2.5 sm:pr-2.5",
              !canNext && "pointer-events-none opacity-50",
            )}
            onClick={goTo(pagina + 1)}
          >
            <span className="hidden sm:block">Próxima</span>
            <ChevronRight className="size-4" />
          </PaginationLink>
        </PaginationItem>
      </PaginationContent>
    </Pagination>
  );
}