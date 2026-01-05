var items = document.getElementsByClassName('item');
var pages=document.getElementsByClassName('previewOnlinePage');
const mainBg = document.getElementById('mainBodyBG')
// 循环遍历每个item
for (var i = 0; i < items.length; i++) {
    // 获取当前item
    var item = items[i];
   
    var frame = item.getElementsByClassName('frame')[0];
    var frontBox = frame.getElementsByClassName('front')[0];
    var leftBox = frame.getElementsByClassName('left')[0];
    var rightBox = frame.getElementsByClassName('right')[0];
    
    // 设置背景图片
    frontBox.style.backgroundImage = 'url(https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/upload/gif/' + (i + 1).toString().padStart(2, '0') + '.webp)';
    leftBox.style.backgroundImage = 'url(https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/upload/gif/' + (i + 1).toString().padStart(2, '0') + '.webp)';
    rightBox.style.backgroundImage = 'url(https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/upload/gif/' + (i + 1).toString().padStart(2, '0') + '.webp)';
}
(function () {
    "use strict";
    var shell = document.getElementsByClassName('shell')[0];
    var slider = shell.getElementsByClassName('shell_slider')[0];
    var items = shell.getElementsByClassName('item');
    
    var prevBtn = shell.getElementsByClassName('prev')[0];
    var nextBtn = shell.getElementsByClassName('next')[0];
    var previewBtn = shell.getElementsByClassName('preview')[0];
    // 定义变量
    var width, height, totalWidth, margin = 20,
        currIndex = 0,
        interval, intervalTime = 20000;
    function init() {
        // 初始化函数
        resize();
        move(Math.floor(items.length / 2));
        bindEvents();
        bindItemClickEvents();
        timer();
    }
    function resize() {
        // 窗口大小变化时调整大小
        width = Math.max(window.innerWidth * .3, 275);
        height = window.innerHeight * .5;
        totalWidth = width * items.length;
        // 设置slider宽度
        slider.style.width = totalWidth + "px";
        // 设置每个item的宽度和高度
        for (var i = 0; i < items.length; i++) {
            let item = items[i];
            item.style.width = (width - (margin * 2)) + "px";
            item.style.height = height + "px";
        }

    }
    function bindEvents() {
        // 窗口大小变化时调整大小
        window.onresize = resize;
        // 点击prev按钮切换item
        prevBtn.addEventListener('click', () => { prev(); });
        nextBtn.addEventListener('click', () => { next(); });
        previewBtn.addEventListener('click',()=>{previewCurrentPage()});

    }
    function move(index) {
        // 移动shell到指定的item
        if (index < 1) index = items.length;
        if (index > items.length) index = 1;
        currIndex = index;
        // 遍历所有item
        for (var i = 0; i < items.length; i++) {
            let item = items[i],
                box = item.getElementsByClassName('frame')[0];
            item.style.opacity = "0.4";
            item.style.zIndex = "1";
            if (i == (index - 1)) {
                // 当前item添加active类并设置3D效果
                item.classList.add('item--active');
                item.style.opacity = "1";
                item.style.zIndex = "999";
                box.style.transform = "perspective(1200px)";
            } else {
                // 其他item移除active类并设置3D效果
                item.classList.remove('item--active');
                box.style.transform = "perspective(1200px) rotateY(" + (i < (index - 1) ? 40 : -40) + "deg)";
            }
        }
        // 移动slider

        slider.style.transform = "translate3d(" + ((index * -width) + (width / 2) + window.innerWidth / 2) + "px, 0, 0)";
        // 设置body背景图片
        var frontBox = items[index - 1].getElementsByClassName('front')[0];
        mainBg.style.backgroundImage = 'url(https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/upload/' + (index).toString().padStart(2, '0') + '.webp)';
    }
    function timer() {
        // 定时器，自动切换shell
        clearInterval(interval);
        interval = setInterval(() => {
            move(++currIndex);
        }, intervalTime);
    }
    // 切换item
    function prev() {
        move(--currIndex);
        timer();
    }
    function next() {
        move(++currIndex);
        timer();
    }
    function previewCurrentPage() {
        window.open("https://"+pages[currIndex-1].innerHTML, "_blank" );

        console.log(pages[currIndex-1].innerHTML);
    }
    function bindItemClickEvents() {
        // 为每个item绑定点击事件
        for (var i = 0; i < items.length; i++) {
            items[i].addEventListener('click', function (i) {
                return function () {
                    move(i + 1);
                };
            }(i));
        }
    }
    init();
})();