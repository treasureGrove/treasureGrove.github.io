(function () {
  function initSophieCursor() {
    if (window.__sophieCursorInited) return;
    window.__sophieCursorInited = true;

    const supportsFinePointer = window.matchMedia("(hover: hover) and (pointer: fine)").matches;
    if (!supportsFinePointer) return;

    const root = document.documentElement;
    const body = document.body;
    if (!body) return;

    // inject style
    const style = document.createElement("style");
    style.setAttribute("data-sophie-cursor", "true");
    style.textContent = `
      html.custom-cursor-enabled,
      html.custom-cursor-enabled body,
      html.custom-cursor-enabled a,
      html.custom-cursor-enabled button,
      html.custom-cursor-enabled input,
      html.custom-cursor-enabled textarea,
      html.custom-cursor-enabled select,
      html.custom-cursor-enabled label,
      html.custom-cursor-enabled summary,
      html.custom-cursor-enabled [role="button"],
      html.custom-cursor-enabled [onclick],
      html.custom-cursor-enabled [data-cursor-label] {
        cursor: none !important;
      }

      .custom-cursor-ring,
      .custom-cursor-dot,
      .custom-cursor-label {
        position: fixed;
        left: 0;
        top: 0;
        pointer-events: none;
        opacity: 0;
        z-index: 2147483647;
        will-change: transform, left, top, width, height, opacity;
      }

      /* 默认只显示 ring */
      html.cursor-visible .custom-cursor-ring {
        opacity: 1;
      }

      /* dot 默认隐藏 */
      .custom-cursor-dot {
        width: 9px;
        height: 9px;
        border-radius: 999px;
        background: #ffffff;
        opacity: 0;
        box-shadow:
          0 0 0 2px rgba(255,255,255,0.16),
          0 0 12px rgba(255,255,255,0.95),
          0 0 24px rgba(255,255,255,0.45);
        transform: translate3d(-50%, -50%, 0) scale(var(--cursor-dot-scale, 1));
        transition:
          opacity 0.18s ease,
          transform 0.16s ease,
          background-color 0.18s ease,
          box-shadow 0.18s ease;
      }

      .custom-cursor-ring {
        width: 42px;
        height: 42px;
        border-radius: 999px;
        border: 1px solid rgba(255, 255, 255, 0.9);
        background: rgba(255, 255, 255, 0.03);
        box-shadow:
          0 0 0 1px rgba(255, 255, 255, 0.03) inset,
          0 0 20px rgba(255, 255, 255, 0.08);
        backdrop-filter: blur(3px);
        -webkit-backdrop-filter: blur(3px);
        mix-blend-mode: difference;
        transform:
          translate3d(-50%, -50%, 0)
          rotate(var(--cursor-angle, 0deg))
          scale(var(--cursor-scale-x, 1), var(--cursor-scale-y, 1));
        transition:
          opacity 0.18s ease,
          width 0.22s cubic-bezier(.22, 1, .36, 1),
          height 0.22s cubic-bezier(.22, 1, .36, 1),
          border-color 0.18s ease,
          background-color 0.18s ease,
          box-shadow 0.22s ease;
      }

      /* label 默认隐藏 */
      .custom-cursor-label {
        opacity: 0;
        transform: translate3d(-50%, -50%, 0) scale(var(--cursor-label-scale, 0.9));
        transform-origin: center;
        color: #ffffff;
        font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        font-size: 11px;
        font-weight: 700;
        line-height: 1;
        letter-spacing: 0.16em;
        text-transform: uppercase;
        white-space: nowrap;
        padding: 6px 9px;
        border-radius: 999px;
        background: rgba(10, 10, 14, 0.62);
        border: 1px solid rgba(255,255,255,0.14);
        box-shadow:
          0 4px 20px rgba(0,0,0,0.22),
          0 0 0 1px rgba(255,255,255,0.03) inset;
        text-shadow:
          0 1px 1px rgba(0,0,0,0.5),
          0 0 8px rgba(255,255,255,0.18);
        backdrop-filter: blur(8px);
        -webkit-backdrop-filter: blur(8px);
        transition:
          opacity 0.16s ease,
          transform 0.18s cubic-bezier(.22, 1, .36, 1);
      }

      html.cursor-hover .custom-cursor-ring {
        width: 74px;
        height: 74px;
        background: rgba(255, 255, 255, 0.08);
        box-shadow:
          0 0 0 1px rgba(255, 255, 255, 0.05) inset,
          0 0 28px rgba(255, 255, 255, 0.12);
      }

      /* 只有 hover / click 时 dot 才出现 */
      html.cursor-hover .custom-cursor-dot,
      html.cursor-click .custom-cursor-dot {
        opacity: 1;
      }

      html.cursor-hover .custom-cursor-dot {
        --cursor-dot-scale: 0.5;
        box-shadow:
          0 0 0 2px rgba(255,255,255,0.18),
          0 0 14px rgba(255,255,255,1),
          0 0 28px rgba(255,255,255,0.52);
      }

      /* label 只有 hover 且有文字时出现 */
      html.cursor-hover .custom-cursor-label.has-text {
        opacity: 1;
        --cursor-label-scale: 1;
      }

      html.cursor-click .custom-cursor-ring {
        width: 58px;
        height: 58px;
      }

      html.cursor-click .custom-cursor-dot {
        --cursor-dot-scale: 1.8;
      }

      html.cursor-text .custom-cursor-ring {
        width: 28px;
        height: 28px;
        background: transparent;
        box-shadow: none;
        opacity: 0.45;
      }

      html.cursor-text .custom-cursor-dot {
        opacity: 0 !important;
        --cursor-dot-scale: 0.8;
      }

      html.cursor-text .custom-cursor-label {
        opacity: 0 !important;
      }

      html.cursor-hidden .custom-cursor-ring,
      html.cursor-hidden .custom-cursor-dot,
      html.cursor-hidden .custom-cursor-label {
        opacity: 0 !important;
      }

      @media (hover: none), (pointer: coarse) {
        .custom-cursor-ring,
        .custom-cursor-dot,
        .custom-cursor-label {
          display: none !important;
        }
      }

      @supports not (mix-blend-mode: difference) {
        .custom-cursor-ring {
          mix-blend-mode: normal;
          border-color: rgba(255,255,255,0.75);
          background: rgba(255,255,255,0.05);
        }
      }
    `;
    document.head.appendChild(style);

    // create cursor nodes
    const ring = document.createElement("div");
    const dot = document.createElement("div");
    const label = document.createElement("div");

    ring.className = "custom-cursor-ring";
    dot.className = "custom-cursor-dot";
    label.className = "custom-cursor-label";

    body.appendChild(ring);
    body.appendChild(dot);
    body.appendChild(label);

    root.classList.add("custom-cursor-enabled");

    let mouseX = window.innerWidth / 2;
    let mouseY = window.innerHeight / 2;
    let ringX = mouseX;
    let ringY = mouseY;

    const ringSmoothing = 0.16;

    const interactiveSelector = [
      "a[href]",
      "button",
      "summary",
      "[role='button']",
      "[onclick]",
      "[data-cursor-label]",
      ".cursor-hover-target",
      "input:not([type='hidden'])",
      "select",
      "textarea",
      "label[for]"
    ].join(",");

    const textSelector = [
      "input:not([type='submit']):not([type='button']):not([type='reset']):not([type='checkbox']):not([type='radio'])",
      "textarea",
      "[contenteditable='true']"
    ].join(",");

    function showCursor() {
      root.classList.add("cursor-visible");
      root.classList.remove("cursor-hidden");
    }

    function hideCursor() {
      root.classList.remove("cursor-visible", "cursor-hover", "cursor-click", "cursor-text");
      root.classList.add("cursor-hidden");
      label.textContent = "";
      label.classList.remove("has-text");
    }

    function getCursorLabel(target) {
      if (!target) return "";

      const labeled = target.closest("[data-cursor-label]");
      if (labeled) {
        return (labeled.getAttribute("data-cursor-label") || "").trim();
      }

      const el = target.closest(interactiveSelector);
      if (!el) return "";

      const tag = el.tagName ? el.tagName.toLowerCase() : "";
      const type = (el.getAttribute && el.getAttribute("type") || "").toLowerCase();
      const role = el.getAttribute && el.getAttribute("role");

      if (tag === "a") return "VIEW";
      if (tag === "button") return "OPEN";
      if (tag === "summary") return "OPEN";
      if (role === "button") return "OPEN";
      if (type === "submit") return "SEND";

      return "";
    }

    function setCursorState(target) {
      if (!target) {
        root.classList.remove("cursor-hover", "cursor-text");
        label.textContent = "";
        label.classList.remove("has-text");
        return;
      }

      const isText = !!target.closest(textSelector);
      const interactiveEl = !isText ? target.closest(interactiveSelector) : null;

      root.classList.toggle("cursor-text", isText);
      root.classList.toggle("cursor-hover", !!interactiveEl);

      const text = interactiveEl ? getCursorLabel(interactiveEl) : "";
      label.textContent = text;

      if (text) {
        label.classList.add("has-text");
      } else {
        label.classList.remove("has-text");
      }
    }

    function updateDot() {
      dot.style.left = mouseX + "px";
      dot.style.top = mouseY + "px";
    }

    function animateRing() {
      ringX += (mouseX - ringX) * ringSmoothing;
      ringY += (mouseY - ringY) * ringSmoothing;

      const dx = mouseX - ringX;
      const dy = mouseY - ringY;
      const distance = Math.min(Math.hypot(dx, dy), 28);
      const stretch = distance / 28;
      const angle = Math.atan2(dy, dx) * 180 / Math.PI;

      ring.style.left = ringX + "px";
      ring.style.top = ringY + "px";
      label.style.left = ringX + "px";
      label.style.top = ringY + "px";

      ring.style.setProperty("--cursor-angle", angle + "deg");
      ring.style.setProperty("--cursor-scale-x", (1 + stretch * 0.34).toFixed(3));
      ring.style.setProperty("--cursor-scale-y", (1 - stretch * 0.18).toFixed(3));

      requestAnimationFrame(animateRing);
    }

    document.addEventListener("pointermove", function (event) {
      if (event.pointerType !== "mouse") return;

      mouseX = event.clientX;
      mouseY = event.clientY;

      updateDot();
      showCursor();
      setCursorState(event.target);
    }, { passive: true });

    document.addEventListener("pointerdown", function (event) {
      if (event.pointerType !== "mouse") return;
      root.classList.add("cursor-click");
      showCursor();
    }, { passive: true });

    document.addEventListener("pointerup", function (event) {
      if (event.pointerType !== "mouse") return;
      root.classList.remove("cursor-click");
      const current = document.elementFromPoint(mouseX, mouseY);
      setCursorState(current);
    }, { passive: true });

    document.addEventListener("mouseover", function (event) {
      setCursorState(event.target);
    }, { passive: true });

    document.addEventListener("mouseout", function (event) {
      if (!event.relatedTarget) hideCursor();
    }, { passive: true });

    document.addEventListener("mouseleave", hideCursor, { passive: true });
    window.addEventListener("blur", hideCursor);
    document.addEventListener("visibilitychange", function () {
      if (document.hidden) hideCursor();
    });

    updateDot();
    ring.style.left = ringX + "px";
    ring.style.top = ringY + "px";
    label.style.left = ringX + "px";
    label.style.top = ringY + "px";

    animateRing();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initSophieCursor, { once: true });
  } else {
    initSophieCursor();
  }
})();