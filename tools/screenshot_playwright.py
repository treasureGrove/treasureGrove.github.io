from playwright.sync_api import sync_playwright
from pathlib import Path

root = Path(r"e:/ProjectGithub/treasureGrove.github.io")
out = root / 'tmp' / 'screenshots'
out.mkdir(parents=True, exist_ok=True)

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

with sync_playwright() as p:
    browser = p.chromium.launch()
    for name in pages:
        url = (root / name).as_uri()
        for label, vp in viewports:
            context = browser.new_context(viewport=vp)
            page = context.new_page()
            try:
                page.goto(url, wait_until='networkidle', timeout=30000)
            except Exception as e:
                # try a slightly more lenient load
                try:
                    page.goto(url, wait_until='load', timeout=30000)
                except Exception as e2:
                    print(f"Failed to load {url}: {e2}")
            # give some time for JS-driven layout to settle
            page.wait_for_timeout(700)
            filename = out / f"{name.replace('.html','')}_{label}.png"
            page.screenshot(path=str(filename), full_page=True)
            print(f"Saved {filename}")
            context.close()
    browser.close()
print('Done')
