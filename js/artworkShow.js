var items = document.getElementsByClassName('item');
var pages=document.getElementsByClassName('previewOnlinePage');
const mainBg = document.getElementById('mainBodyBG')

const imageCache = new Map();
const preloadQueue = [];

function preloadImage(url) {
    return new Promise((resolve, reject) => {
        if (imageCache.has(url)) {
            resolve(url);
            return;
        }
        
        const img = new Image();
        img.onload = () => {
            imageCache.set(url, true);
            resolve(url);
        };
        img.onerror = () => {
            reject(url);
        };
        img.src = url;
    });
}

function preloadImagesAsync(urls, priority = false) {
    if (priority) {
        urls.forEach(url => preloadImage(url));
    } else {
        preloadQueue.push(...urls);
    }
}

function processPreloadQueue() {
    if (preloadQueue.length === 0) return;
    
    const url = preloadQueue.shift();
    preloadImage(url).finally(() => {
        setTimeout(processPreloadQueue, 200);
    });
}

for (var i = 0; i < items.length; i++) {
    var item = items[i];
   
    var frame = item.getElementsByClassName('frame')[0];
    var frontBox = frame.getElementsByClassName('front')[0];
    var leftBox = frame.getElementsByClassName('left')[0];
    var rightBox = frame.getElementsByClassName('right')[0];
    
    const imageUrl = 'https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/upload/gif/' + (i + 1).toString().padStart(2, '0') + '.webp';
    const bgImageUrl = 'https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/upload/' + (i + 1).toString().padStart(2, '0') + '.webp';
    
    frontBox.style.backgroundImage = 'url(' + imageUrl + ')';
    leftBox.style.backgroundImage = 'url(' + imageUrl + ')';
    rightBox.style.backgroundImage = 'url(' + imageUrl + ')';
    
    if (i < 3) {
        preloadImagesAsync([imageUrl, bgImageUrl], true);
    } else {
        preloadImagesAsync([imageUrl, bgImageUrl], false);
    }
}

window.addEventListener('load', () => {
    setTimeout(() => {
        processPreloadQueue();
    }, 1000); 
});
(function () {
    "use strict";
    var shell = document.getElementsByClassName('shell')[0];
    var slider = shell.getElementsByClassName('shell_slider')[0];
    var items = shell.getElementsByClassName('item');
    
    var prevBtn = shell.getElementsByClassName('prev')[0];
    var nextBtn = shell.getElementsByClassName('next')[0];
    var previewBtn = shell.getElementsByClassName('preview')[0];

    var width, height, totalWidth, margin = 20,
        currIndex = 0,
        interval, intervalTime = 20000;
        
    function init() {
        resize();
        initTransitions();
        move(Math.floor(items.length / 2));
        bindEvents();
        bindItemClickEvents();
        timer();
    }
    
    function initTransitions() {
        for (var i = 0; i < items.length; i++) {
            let item = items[i];
            let box = item.getElementsByClassName('frame')[0];
            item.style.transition = 'opacity 0.6s ease, z-index 0s';
            box.style.transition = 'transform 0.8s cubic-bezier(0.4, 0, 0.2, 1)';
        }
        slider.style.transition = 'transform 0.8s cubic-bezier(0.4, 0, 0.2, 1)';
    }
    
    function resize() {
        width = Math.max(window.innerWidth * .3, 275);
        height = window.innerHeight * .5;
        totalWidth = width * items.length;
        slider.style.width = totalWidth + "px";
        for (var i = 0; i < items.length; i++) {
            let item = items[i];
            item.style.width = (width - (margin * 2)) + "px";
            item.style.height = height + "px";
        }
    }
    
    function bindEvents() {
        window.onresize = resize;
        prevBtn.addEventListener('click', () => { prev(); });
        nextBtn.addEventListener('click', () => { next(); });
        previewBtn.addEventListener('click',()=>{previewCurrentPage()});
    }
    
    function move(index) {
        if (index < 1) index = items.length;
        if (index > items.length) index = 1;
        currIndex = index;
        
        for (var i = 0; i < items.length; i++) {
            let item = items[i],
                box = item.getElementsByClassName('frame')[0];
            item.style.opacity = "0.4";
            item.style.zIndex = "1";
            if (i == (index - 1)) {
                item.classList.add('item--active');
                item.style.opacity = "1";
                item.style.zIndex = "999";
                box.style.transform = "perspective(1200px)";
            } else {
                item.classList.remove('item--active');
                box.style.transform = "perspective(1200px) rotateY(" + (i < (index - 1) ? 40 : -40) + "deg)";
            }
        }

        slider.style.transform = "translate3d(" + ((index * -width) + (width / 2) + window.innerWidth / 2) + "px, 0, 0)";
        
        const newBgUrl = 'https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/upload/' + (index).toString().padStart(2, '0') + '.webp';
        
        const img = new Image();
        img.onload = () => {
            mainBg.style.backgroundImage = 'url(' + newBgUrl + ')';
        };
        img.src = newBgUrl;
    }
    
    function timer() {
        clearInterval(interval);
        interval = setInterval(() => {
            move(++currIndex);
        }, intervalTime);
    }

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
    }
    
    function bindItemClickEvents() {
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