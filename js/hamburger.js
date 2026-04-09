// 移动端汉堡菜单切换
document.addEventListener('DOMContentLoaded', function () {
    var btn = document.getElementById('hamburger-btn');
    var menu = document.querySelector('.topMenu .center');
    if (!btn || !menu) return;

    btn.addEventListener('click', function (e) {
        e.stopPropagation();
        menu.classList.toggle('open');
        btn.classList.toggle('open');
    });

    // 点击菜单外区域关闭
    document.addEventListener('click', function (e) {
        if (menu.classList.contains('open') && !menu.contains(e.target) && !btn.contains(e.target)) {
            menu.classList.remove('open');
            btn.classList.remove('open');
        }
    });

    // 点击菜单项后关闭菜单
    menu.querySelectorAll('li a').forEach(function (link) {
        link.addEventListener('click', function () {
            menu.classList.remove('open');
            btn.classList.remove('open');
        });
    });
});
