// Fake page transition loader (visual only).
// Behavior:
//  - `loading.in(target)`: show overlay, animate staged progress, set a session flag and navigate after DURATION.
//  - On the next page load, if the session flag exists, the new page will show the overlay briefly and call `loading.out()` to fade it away.
const loading = (function () {
    const DURATION = 800; // ms total animation length
    let inProgress = false;

    function createOverlay() {
        let overlay = document.getElementById('fake-loading-overlay');
        if (overlay) return overlay;
        overlay = document.createElement('div');
        overlay.id = 'fake-loading-overlay';
        overlay.innerHTML = `
            <div class="fake-loader">
                <div class="fake-bar"></div>
            </div>
        `;
        document.body.appendChild(overlay);
        // reflow
        void overlay.offsetWidth;
        return overlay;
    }

    function startAnimation(overlay) {
        const bar = overlay.querySelector('.fake-bar');
        overlay.classList.add('show');
        bar.style.transition = 'none';
        bar.style.width = '6%';

        // staged progression to mimic realistic loading
        const t1 = Math.max(80, Math.floor(DURATION * 0.15));
        const t2 = Math.max(300, Math.floor(DURATION * 0.6));
        const t3 = Math.max(160, Math.floor(DURATION * 0.25));

        setTimeout(() => {
            bar.style.transition = `width ${t2}ms cubic-bezier(.22,.9,.3,1)`;
            bar.style.width = '68%';
        }, t1);

        setTimeout(() => {
            bar.style.transition = `width ${t3}ms cubic-bezier(.22,.9,.3,1)`;
            bar.style.width = '92%';
        }, t1 + t2);

        return bar;
    }

    function fadeOutOverlay(overlay) {
        if (!overlay) return;
        // trigger fade by removing show class (CSS transitions opacity)
        overlay.classList.remove('show');
        // shrink bar for subtle effect
        const bar = overlay.querySelector('.fake-bar');
        if (bar) bar.style.width = '100%';
        setTimeout(() => {
            if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
        }, 380);
    }

    // When a page loads, if previous navigation requested a fake loading,
    // restore the overlay briefly and then fade it out for continuity.
    function handleIncoming() {
        try {
            if (sessionStorage.getItem('__fakeLoadingActive') === '1') {
                sessionStorage.removeItem('__fakeLoadingActive');
                const overlay = createOverlay();
                // immediately show a near-complete bar
                const bar = overlay.querySelector('.fake-bar');
                overlay.classList.add('show');
                bar.style.transition = 'none';
                bar.style.width = '96%';
                // after a short delay, finish and fade out
                setTimeout(() => {
                    bar.style.transition = 'width 160ms ease-out';
                    bar.style.width = '100%';
                    setTimeout(() => fadeOutOverlay(overlay), 140);
                }, 220);
            }
        } catch (e) {
            // sessionStorage may be unavailable in some contexts — fail silently
        }
    }

    // expose API
    const api = {
        in(target) {
            if (inProgress) return;
            if (typeof target !== 'string' || !target) return;
            inProgress = true;
            try { sessionStorage.setItem('__fakeLoadingActive', '1'); } catch (e) {}
            const overlay = createOverlay();
            const bar = startAnimation(overlay);

            // finalize to 100% shortly before navigation for a satisfying finish
            const finalizeMs = 180;
            setTimeout(() => {
                if (bar) {
                    bar.style.transition = `width ${finalizeMs}ms ease-out`;
                    bar.style.width = '100%';
                }
            }, Math.max(0, DURATION - finalizeMs - 20));

            setTimeout(() => {
                // navigate after the visual animation completes
                window.location.href = target;
            }, DURATION);
        },
        out() {
            const overlay = document.getElementById('fake-loading-overlay');
            fadeOutOverlay(overlay);
            inProgress = false;
        }
    };

    // run incoming handler immediately so pages that include this script can
    // perform the fade-out when loaded.
    if (document.readyState === 'complete') handleIncoming();
    else window.addEventListener('load', handleIncoming);

    return api;
})();

// no-op safe listener
window.addEventListener('load', () => {});