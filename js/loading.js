// Simplified loading helper — visual loading overlay removed.
// Keep `loading.in(target)` and `loading.out()` APIs safe for existing onclicks.
const loading = {
    in(target) {
        if (typeof target === 'string' && target) {
            window.location.href = target;
        }
    },
    out() {
        /* no-op (no visual loading overlay) */
    }
};

window.addEventListener('load', () => {
    // no visual loading behavior required
});