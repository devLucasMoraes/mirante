import { useLayoutEffect, useRef, useState } from "react";

function isOverflowing(element: HTMLElement): boolean {
  return (
    element.scrollHeight > element.clientHeight ||
    element.scrollWidth > element.clientWidth
  );
}

export function useIsTruncated<T extends HTMLElement>() {
  const ref = useRef<T>(null);
  const [isTruncated, setIsTruncated] = useState(false);

  useLayoutEffect(() => {
    const element = ref.current;
    if (!element) {
      return;
    }

    let cancelled = false;

    const measure = () => {
      if (!cancelled) {
        setIsTruncated(isOverflowing(element));
      }
    };

    measure();

    const resizeObserver =
      typeof ResizeObserver !== "undefined"
        ? new ResizeObserver(measure)
        : undefined;
    resizeObserver?.observe(element);

    void document.fonts?.ready?.then(measure);

    window.addEventListener("resize", measure);

    return () => {
      cancelled = true;
      resizeObserver?.disconnect();
      window.removeEventListener("resize", measure);
    };
  }, []);

  return { ref, isTruncated };
}
