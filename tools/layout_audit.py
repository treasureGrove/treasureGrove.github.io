from playwright.sync_api import sync_playwright
from pathlib import Path
import json

root = Path(r"e:/ProjectGithub/treasureGrove.github.io")
pages = [
    'index.html',
    'introduction.html',
    'gameFeatures.html',
    'photoRecord.html',
    'myselfIntroduction.html',
    'titleShow.html'
]
viewports = [
    ('desktop', {'width':1366,'height':768}),
    ('mobile', {'width':360,'height':800})
]
out = root / 'tmp' / 'layout_report.json'
report = {}

with sync_playwright() as p:
    browser = p.chromium.launch()
    for name in pages:
        url = (root / name).as_uri()
        report[name] = {}
        for label, vp in viewports:
            ctx = browser.new_context(viewport=vp)
            page = ctx.new_page()
            page.goto(url, wait_until='networkidle', timeout=30000)
            page.wait_for_timeout(500)
            analysis = page.evaluate('''() => {
                const vw = window.innerWidth;
                const vh = window.innerHeight;
                const offenders = [];
                const els = Array.from(document.querySelectorAll('*'));
                for (const el of els) {
                    try {
                        const w = el.offsetWidth || 0;
                        if (w > vw + 5) {
                            offenders.push({tag: el.tagName, id: el.id || null, class: el.className || null, width: w});
                        }
                    } catch(e) {}
                }
                const topMenu = document.querySelector('.topMenu') || document.querySelector('#topMenu') || null;
                let topMenuIssue = null;
                if (topMenu) {
                    const r = topMenu.getBoundingClientRect();
                    topMenuIssue = {left: r.left, right: r.right, top: r.top, bottom: r.bottom, width: r.width, height: r.height, outOfView: (r.left < -1 || r.right > vw + 1 || r.top > vh || r.bottom < 0)};
                }
                const horizOverflow = document.documentElement.scrollWidth > vw + 5;
                const bodyOverflowX = getComputedStyle(document.body).overflowX;
                const docOverflowX = getComputedStyle(document.documentElement).overflowX;
                return {vw, vh, horizOverflow, bodyOverflowX, docOverflowX, offenders: offenders.slice(0,20), offendersCount: offenders.length, topMenu: topMenuIssue};
            }''')
            report[name][label] = analysis
            ctx.close()
    browser.close()

out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(json.dumps(report, indent=2, ensure_ascii=False))
print('Wrote', out)
print('Summary:')
for page, data in report.items():
    for vp, res in data.items():
        flags = []
        if res['horizOverflow']: flags.append('horizontal-overflow')
        if res['topMenu'] and res['topMenu']['outOfView']: flags.append('topMenu-out-of-view')
        if res['offendersCount']>0: flags.append(f'{res["offendersCount"]} wide-elements')
        print(f"{page} @ {vp}: {', '.join(flags) if flags else 'ok'}")

print('Done')
