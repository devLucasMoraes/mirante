import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { beforeAll, beforeEach, describe, expect, test, vi } from "vitest";

import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@repo/ui/components/tooltip";

import { useIsTruncated } from "@/lib/use-is-truncated";

class MockResizeObserver {
  static instances: MockResizeObserver[] = [];

  observed: Element | null = null;
  private readonly callback: ResizeObserverCallback;

  constructor(callback: ResizeObserverCallback) {
    this.callback = callback;
    MockResizeObserver.instances.push(this);
  }

  observe(target: Element) {
    this.observed = target;
  }

  unobserve() {}

  disconnect() {}

  trigger() {
    this.callback([], this as unknown as ResizeObserver);
  }
}

beforeAll(() => {
  vi.stubGlobal("ResizeObserver", MockResizeObserver);
});

beforeEach(() => {
  MockResizeObserver.instances = [];
});

function mockOverflow(scrollHeight: number, clientHeight: number) {
  vi.spyOn(Element.prototype, "scrollHeight", "get").mockReturnValue(scrollHeight);
  vi.spyOn(Element.prototype, "clientHeight", "get").mockReturnValue(clientHeight);
}

function Harness({ texto }: { texto: string }) {
  const { ref, isTruncated } = useIsTruncated<HTMLParagraphElement>();
  return (
    <div>
      <p ref={ref} data-testid="texto">
        {texto}
      </p>
      <output data-testid="resultado">{String(isTruncated)}</output>
    </div>
  );
}

function TooltipHarness({ texto }: { texto: string }) {
  const { ref, isTruncated } = useIsTruncated<HTMLParagraphElement>();
  return (
    <TooltipProvider delayDuration={0}>
      <Tooltip open={isTruncated ? undefined : false}>
        <TooltipTrigger asChild>
          <p ref={ref}>{texto}</p>
        </TooltipTrigger>
        <TooltipContent side="bottom">
          <p data-testid="tooltip-texto">{texto}</p>
        </TooltipContent>
      </Tooltip>
    </TooltipProvider>
  );
}

describe("useIsTruncated", () => {
  test("retorna false quando o texto não transborda", () => {
    mockOverflow(20, 20);

    render(<Harness texto="descrição curta" />);

    expect(screen.getByTestId("resultado")).toHaveTextContent("false");
  });

  test("retorna true quando o texto transborda", () => {
    mockOverflow(60, 20);

    render(<Harness texto={"x".repeat(500)} />);

    expect(screen.getByTestId("resultado")).toHaveTextContent("true");
  });

  test("re-mede após mudança tardia de layout disparada pelo ResizeObserver", async () => {
    const scrollHeight = vi.spyOn(Element.prototype, "scrollHeight", "get");
    const clientHeight = vi.spyOn(Element.prototype, "clientHeight", "get");
    scrollHeight.mockReturnValue(20);
    clientHeight.mockReturnValue(20);

    render(<Harness texto={"x".repeat(500)} />);
    expect(screen.getByTestId("resultado")).toHaveTextContent("false");

    scrollHeight.mockReturnValue(60);
    const observer = MockResizeObserver.instances.at(-1);
    expect(observer?.observed).not.toBeNull();
    observer?.trigger();

    await waitFor(() =>
      expect(screen.getByTestId("resultado")).toHaveTextContent("true"),
    );
  });

  test("re-mede quando a janela muda de tamanho", async () => {
    const scrollHeight = vi.spyOn(Element.prototype, "scrollHeight", "get");
    const clientHeight = vi.spyOn(Element.prototype, "clientHeight", "get");
    scrollHeight.mockReturnValue(20);
    clientHeight.mockReturnValue(20);

    render(<Harness texto={"x".repeat(500)} />);
    expect(screen.getByTestId("resultado")).toHaveTextContent("false");

    scrollHeight.mockReturnValue(60);
    window.dispatchEvent(new Event("resize"));

    await waitFor(() =>
      expect(screen.getByTestId("resultado")).toHaveTextContent("true"),
    );
  });
});

describe("gating do tooltip", () => {
  test("abre o tooltip somente quando o texto está truncado", async () => {
    const user = userEvent.setup();
    mockOverflow(60, 20);

    render(<TooltipHarness texto={"descrição longa ".repeat(20)} />);

    await user.hover(screen.getByText(/descrição longa/));

    expect(await screen.findByTestId("tooltip-texto")).toHaveTextContent(
      "descrição longa",
    );
  });

  test("não abre o tooltip quando o texto não está truncado", async () => {
    const user = userEvent.setup();
    mockOverflow(20, 20);

    render(<TooltipHarness texto="descrição curta" />);

    await user.hover(screen.getByText("descrição curta"));

    await waitFor(() =>
      expect(screen.queryByTestId("tooltip-texto")).not.toBeInTheDocument(),
    );
  });
});
