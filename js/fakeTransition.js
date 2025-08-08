const loading = {
    container: document.querySelector(".loading"),
    in(target) {
        this.container.classList.remove("fade-out");
        setTimeout(() => {
            window.location.href = target;
        }, 400);
    },
    out() {
        this.container.classList.add("fade-out");
    }
};
window.addEventListener("load", () => {
    loading.out();
});