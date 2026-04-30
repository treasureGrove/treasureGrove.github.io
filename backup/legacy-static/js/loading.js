// Page transition loader with smooth fade effect
const loading = (function () {
    const TRANSITION_DELAY = 400; // ms before navigation
    let inProgress = false;

    function createOverlay() {
        let overlay = document.getElementById('fake-loading-overlay');
        if (overlay) return overlay;
        overlay = document.createElement('div');
        overlay.id = 'fake-loading-overlay';
        overlay.innerHTML = `
            <div class="fake-loader">
                <div class="spinner"></div>
                <div class="loading-text">Loading...</div>
            </div>
        `;
        document.body.appendChild(overlay);
        // Force reflow
        void overlay.offsetWidth;
        return overlay;
    }

    function showOverlay(overlay) {
        overlay.classList.remove('hide');
        overlay.classList.add('show');
    }

    function hideOverlay(overlay) {
        if (!overlay) return;
        overlay.classList.remove('show');
        overlay.classList.add('hide');
        setTimeout(() => {
            if (overlay.parentNode) {
                overlay.parentNode.removeChild(overlay);
            }
        }, 350);
    }

    // Handle page load - show overlay without spinner and fade out
    function handleIncoming() {
        try {
            if (sessionStorage.getItem('__pageTransition') === '1') {
                sessionStorage.removeItem('__pageTransition');
                const overlay = createOverlay();
                // Hide spinner and text, just show background fade
                const loader = overlay.querySelector('.fake-loader');
                if (loader) loader.style.display = 'none';
                // Immediately show without animation
                overlay.style.transition = 'none';
                overlay.classList.add('show');
                // Force reflow
                void overlay.offsetWidth;
                // Re-enable transition
                overlay.style.transition = '';
                // Fade out gradually
                setTimeout(() => {
                    hideOverlay(overlay);
                    inProgress = false;
                }, 100);
            }
        } catch (e) {
            // sessionStorage may be unavailable - fail silently
        }
    }

    // Public API
    const api = {
        in(target) {
            if (inProgress) return;
            if (typeof target !== 'string' || !target) return;
            inProgress = true;
            
            try { 
                    sessionStorage.setItem('__pageTransition', '1'); 
                    // save music playback state so it can be resumed on the next page
                    try {
                        const _music = document.getElementById('music');
                        if (_music) {
                            sessionStorage.setItem('__musicTime', String(_music.currentTime || 0));
                            sessionStorage.setItem('__musicPlaying', _music.paused ? '0' : '1');
                        }
                    } catch (e) {}
            } catch (e) {}
            
            const overlay = createOverlay();
            showOverlay(overlay);

            // Navigate after brief delay
            setTimeout(() => {
                window.location.href = target;
            }, TRANSITION_DELAY);
        },
        out() {
            const overlay = document.getElementById('fake-loading-overlay');
            hideOverlay(overlay);
            inProgress = false;
        }
    };

    // Initialize immediately - don't wait for load event
    handleIncoming();

    return api;
})();