/* global JSZip */
(function (global) {
    'use strict';

    const DEFAULTS = {
        pollInterval: 15000
    };

    const LAYOUT = {
        nodeWidth: 180,
        nodeHeight: 40,
        gapY: 18,
        gapX: 90,
        padding: 30
    };

    const STATE = {
        container: null,
        panzoom: null,
        canvas: null,
        svg: null,
        nodesLayer: null,
        options: { ...DEFAULTS },
        lastSource: null,
        pollTimer: null,
        scale: 1,
        translateX: 20,
        translateY: 20,
        dragging: false,
        dragStart: { x: 0, y: 0 },
        dragOrigin: { x: 0, y: 0 }
    };

    function ensureStyles() {
        if (document.getElementById('xmind-preview-style')) return;
        const style = document.createElement('style');
        style.id = 'xmind-preview-style';
        style.textContent = `
            .xmind-panzoom {
                position: relative;
                width: 100%;
                height: 520px;
                overflow: hidden;
                cursor: grab;
                touch-action: none;
            }
            .xmind-panzoom.dragging {
                cursor: grabbing;
            }
            .xmind-canvas {
                position: absolute;
                left: 0;
                top: 0;
                transform-origin: 0 0;
            }
            .xmind-nodes {
                position: absolute;
                left: 0;
                top: 0;
            }
            .xmind-node {
                position: absolute;
                width: ${LAYOUT.nodeWidth}px;
                min-height: ${LAYOUT.nodeHeight}px;
                padding: 8px 10px;
                box-sizing: border-box;
                background: rgba(255, 255, 255, 0.92);
                color: #1a1a1a;
                border-radius: 8px;
                border: 1px solid #d8d8d8;
                font-size: 14px;
                line-height: 1.2;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.25);
                text-align: left;
                word-break: break-word;
            }
            .xmind-node.root {
                background: #ffe7b6;
                border-color: #e0b14a;
                font-weight: 600;
            }
            .xmind-edge {
                stroke: rgba(255, 255, 255, 0.7);
                stroke-width: 2;
                fill: none;
            }
        `;
        document.head.appendChild(style);
    }

    function init(containerId, options) {
        ensureStyles();
        const container = document.getElementById(containerId);
        if (!container) throw new Error('XMind container not found.');

        STATE.container = container;
        STATE.options = { ...DEFAULTS, ...(options || {}) };

        container.innerHTML = '';
        container.style.position = 'relative';
        container.style.overflow = 'hidden';

        const panzoom = document.createElement('div');
        panzoom.className = 'xmind-panzoom';

        const canvas = document.createElement('div');
        canvas.className = 'xmind-canvas';

        const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
        svg.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
        svg.style.position = 'absolute';
        svg.style.left = '0';
        svg.style.top = '0';

        const nodesLayer = document.createElement('div');
        nodesLayer.className = 'xmind-nodes';

        canvas.appendChild(svg);
        canvas.appendChild(nodesLayer);
        panzoom.appendChild(canvas);
        container.appendChild(panzoom);

        STATE.panzoom = panzoom;
        STATE.canvas = canvas;
        STATE.svg = svg;
        STATE.nodesLayer = nodesLayer;
        resetView();
        bindPanZoom();
    }

    function resetView() {
        STATE.scale = 1;
        STATE.translateX = 20;
        STATE.translateY = 20;
        applyTransform();
    }

    function bindPanZoom() {
        const el = STATE.panzoom;
        if (!el) return;

        el.addEventListener('pointerdown', (ev) => {
            if (ev.button !== 0) return;
            STATE.dragging = true;
            STATE.dragStart = { x: ev.clientX, y: ev.clientY };
            STATE.dragOrigin = { x: STATE.translateX, y: STATE.translateY };
            el.classList.add('dragging');
            el.setPointerCapture(ev.pointerId);
        });

        el.addEventListener('pointermove', (ev) => {
            if (!STATE.dragging) return;
            const dx = ev.clientX - STATE.dragStart.x;
            const dy = ev.clientY - STATE.dragStart.y;
            STATE.translateX = STATE.dragOrigin.x + dx;
            STATE.translateY = STATE.dragOrigin.y + dy;
            applyTransform();
        });

        const stopDrag = (ev) => {
            if (!STATE.dragging) return;
            STATE.dragging = false;
            el.classList.remove('dragging');
            try { el.releasePointerCapture(ev.pointerId); } catch (_) {}
        };
        el.addEventListener('pointerup', stopDrag);
        el.addEventListener('pointercancel', stopDrag);

        el.addEventListener('wheel', (ev) => {
            ev.preventDefault();
            const rect = el.getBoundingClientRect();
            const mouseX = ev.clientX - rect.left;
            const mouseY = ev.clientY - rect.top;
            const scaleFactor = ev.deltaY > 0 ? 0.9 : 1.1;
            const newScale = Math.min(3, Math.max(0.2, STATE.scale * scaleFactor));
            const scaleRatio = newScale / STATE.scale;

            STATE.translateX = mouseX - (mouseX - STATE.translateX) * scaleRatio;
            STATE.translateY = mouseY - (mouseY - STATE.translateY) * scaleRatio;
            STATE.scale = newScale;
            applyTransform();
        }, { passive: false });
    }

    function applyTransform() {
        if (!STATE.canvas) return;
        STATE.canvas.style.transform = `translate(${STATE.translateX}px, ${STATE.translateY}px) scale(${STATE.scale})`;
    }

    async function ensureJSZip() {
        if (global.JSZip) return;
        await new Promise((resolve, reject) => {
            const script = document.createElement('script');
            script.src = 'https://cdn.jsdelivr.net/npm/jszip@3.10.1/dist/jszip.min.js';
            script.async = true;
            script.onload = resolve;
            script.onerror = () => reject(new Error('Failed to load JSZip'));
            document.head.appendChild(script);
        });
    }

    async function readSource(source) {
        if (typeof source === 'string') {
            const resp = await fetch(source, { cache: 'no-store' });
            if (!resp.ok) throw new Error(`Fetch failed: ${resp.status}`);
            return await resp.arrayBuffer();
        }
        if (source && typeof source.arrayBuffer === 'function') {
            return await source.arrayBuffer();
        }
        throw new Error('Unsupported source type.');
    }

    function buildTreeFromJson(content) {
        if (!Array.isArray(content) || !content[0] || !content[0].rootTopic) {
            throw new Error('Invalid XMind JSON content.');
        }
        const root = content[0].rootTopic;
        return mapTopic(root);
    }

    function mapTopic(topic) {
        const children = [];
        if (topic.children && topic.children.attached) {
            topic.children.attached.forEach((child) => children.push(mapTopic(child)));
        }
        return {
            title: topic.title || '(Untitled)',
            children
        };
    }

    function buildTreeFromXml(xmlText) {
        const parser = new DOMParser();
        const doc = parser.parseFromString(xmlText, 'text/xml');
        const sheet = doc.getElementsByTagName('sheet')[0];
        if (!sheet) throw new Error('Invalid XMind XML content.');
        const rootTopic = sheet.getElementsByTagName('topic')[0];
        if (!rootTopic) throw new Error('No topic found.');
        return mapXmlTopic(rootTopic);
    }

    function mapXmlTopic(topicEl) {
        let title = '(Untitled)';
        const titleEl = topicEl.getElementsByTagName('title')[0];
        if (titleEl && titleEl.textContent) title = titleEl.textContent.trim();

        const children = [];
        const childrenEls = topicEl.getElementsByTagName('children');
        for (let i = 0; i < childrenEls.length; i += 1) {
            const topicsEls = childrenEls[i].getElementsByTagName('topics');
            for (let j = 0; j < topicsEls.length; j += 1) {
                if (topicsEls[j].getAttribute('type') !== 'attached') continue;
                const topicNodes = topicsEls[j].getElementsByTagName('topic');
                for (let k = 0; k < topicNodes.length; k += 1) {
                    if (topicNodes[k].parentNode !== topicsEls[j]) continue;
                    children.push(mapXmlTopic(topicNodes[k]));
                }
            }
        }

        return { title, children };
    }

    function computeHeight(node) {
        if (!node.children || node.children.length === 0) {
            return LAYOUT.nodeHeight;
        }
        const childHeights = node.children.map(computeHeight);
        const totalChildren = childHeights.reduce((a, b) => a + b, 0) +
            LAYOUT.gapY * (childHeights.length - 1);
        return Math.max(LAYOUT.nodeHeight, totalChildren);
    }

    function layoutNodes(node, x, yTop, positions) {
        const height = computeHeight(node);
        const y = yTop + (height - LAYOUT.nodeHeight) / 2;
        positions.push({ node, x, y });

        if (!node.children || node.children.length === 0) return;
        let childY = yTop;
        node.children.forEach((child) => {
            const childHeight = computeHeight(child);
            layoutNodes(child, x + LAYOUT.nodeWidth + LAYOUT.gapX, childY, positions);
            childY += childHeight + LAYOUT.gapY;
        });
    }

    function renderTree(tree) {
        if (!STATE.canvas || !STATE.svg || !STATE.nodesLayer) return;
        STATE.nodesLayer.innerHTML = '';
        while (STATE.svg.firstChild) STATE.svg.removeChild(STATE.svg.firstChild);

        const positions = [];
        layoutNodes(tree, 0, 0, positions);

        let minX = Infinity;
        let minY = Infinity;
        let maxX = -Infinity;
        let maxY = -Infinity;
        positions.forEach((pos) => {
            minX = Math.min(minX, pos.x);
            minY = Math.min(minY, pos.y);
            maxX = Math.max(maxX, pos.x + LAYOUT.nodeWidth);
            maxY = Math.max(maxY, pos.y + LAYOUT.nodeHeight);
        });

        const offsetX = LAYOUT.padding - minX;
        const offsetY = LAYOUT.padding - minY;
        const canvasWidth = (maxX - minX) + LAYOUT.padding * 2;
        const canvasHeight = (maxY - minY) + LAYOUT.padding * 2;

        STATE.canvas.style.width = `${canvasWidth}px`;
        STATE.canvas.style.height = `${canvasHeight}px`;
        STATE.svg.setAttribute('width', canvasWidth);
        STATE.svg.setAttribute('height', canvasHeight);
        STATE.svg.setAttribute('viewBox', `0 0 ${canvasWidth} ${canvasHeight}`);

        const positionMap = new Map();
        positions.forEach((pos) => {
            const x = pos.x + offsetX;
            const y = pos.y + offsetY;
            positionMap.set(pos.node, { x, y });
        });

        positions.forEach((pos, idx) => {
            const { x, y } = positionMap.get(pos.node);
            const el = document.createElement('div');
            el.className = 'xmind-node' + (idx === 0 ? ' root' : '');
            el.textContent = pos.node.title;
            el.style.left = `${x}px`;
            el.style.top = `${y}px`;
            STATE.nodesLayer.appendChild(el);
        });

        positions.forEach((pos) => {
            if (!pos.node.children || pos.node.children.length === 0) return;
            const parent = positionMap.get(pos.node);
            const startX = parent.x + LAYOUT.nodeWidth;
            const startY = parent.y + LAYOUT.nodeHeight / 2;
            pos.node.children.forEach((child) => {
                const childPos = positionMap.get(child);
                const endX = childPos.x;
                const endY = childPos.y + LAYOUT.nodeHeight / 2;
                const midX = (startX + endX) / 2;
                const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
                path.setAttribute('class', 'xmind-edge');
                path.setAttribute('d', `M ${startX} ${startY} C ${midX} ${startY}, ${midX} ${endY}, ${endX} ${endY}`);
                STATE.svg.appendChild(path);
            });
        });
    }

    async function load(source) {
        if (!STATE.container) throw new Error('XMind previewer not initialized.');
        if (!source) throw new Error('Missing XMind source.');

        await ensureJSZip();
        const arrayBuffer = await readSource(source);
        const zip = await global.JSZip.loadAsync(arrayBuffer);

        let tree = null;
        if (zip.file('content.json')) {
            const jsonText = await zip.file('content.json').async('string');
            tree = buildTreeFromJson(JSON.parse(jsonText));
        } else if (zip.file('content.xml')) {
            const xmlText = await zip.file('content.xml').async('string');
            tree = buildTreeFromXml(xmlText);
        } else {
            throw new Error('No content.json or content.xml found.');
        }

        renderTree(tree);
        resetView();
        if (typeof source === 'string') {
            STATE.lastSource = source;
        }
        return tree;
    }

    function startAutoPoll() {
        if (!STATE.lastSource || typeof STATE.lastSource !== 'string') return;
        stopAutoPoll();
        STATE.pollTimer = setInterval(() => {
            load(STATE.lastSource).catch((err) => console.warn('Auto poll failed', err));
        }, STATE.options.pollInterval);
    }

    function stopAutoPoll() {
        if (STATE.pollTimer) {
            clearInterval(STATE.pollTimer);
            STATE.pollTimer = null;
        }
    }

    global.XmindPreviewer = {
        init,
        load,
        startAutoPoll,
        stopAutoPoll
    };
})(window);
