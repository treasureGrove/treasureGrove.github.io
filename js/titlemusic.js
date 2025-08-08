document.addEventListener('DOMContentLoaded', () => {
    initializeShareFeature();
});
function initializeShareFeature() {
    const shareIcon = document.getElementById('right-share');
    const sharePanel = document.getElementById('share-panel');

    if (shareIcon && sharePanel) {
        shareIcon.addEventListener('mouseenter', () => {
            // 每次显示时自动填入当前页面URL
            const input = sharePanel.querySelector('input');
            if (input) {
                input.value = window.location.href;
            }
            const rect = shareIcon.getBoundingClientRect();
            sharePanel.style.left = `${rect.left-160}px`;
            sharePanel.style.top = `${rect.bottom + window.scrollY}px`;
            sharePanel.style.display = 'block';
            console.log('鼠标进入了');
        });

        shareIcon.addEventListener('mouseleave', () => {
            setTimeout(() => {
                sharePanel.style.display = 'none';
            }, 1500);
            console.log('鼠标离开了');
        });
    }
}
//musics
const music = document.getElementById('music');
const image1 = document.getElementsByClassName("right")[0];
//videos
const video = document.querySelector('.productVideo');
const videoPanel = document.querySelector('.videoPanel');
const bg = document.querySelector('.main_body_bg');
//shares
let isPlaying = true;
function playMusic() {
    music.play();
    image1.src = "images/musicPlay.png";
    isPlaying = true;
    console.log('Music playing');
}
function pauseMusic() {
    music.pause();
    image1.src = "images/musicMute.png";
    isPlaying = false;
    console.log('Music paused');
}
function changeState() {
    if (isPlaying) {
        pauseMusic();
    } else {
        playMusic();
    }
}
document.addEventListener('visibilitychange', () => {
    if (document.visibilityState === 'hidden') {
        pauseMusic();
    } else {
        playMusic();
    }
});
function playVideo() {
    music.pause();
    video.className = 'productVideo-active';
    video.play();
    videoPanel.className = 'videoPanel-active'
    console.log('点击了按钮');
}
function exitVideo() {
    playMusic();
    video.className = 'productVideo';
    video.pause();
    videoPanel.className = 'videoPanel';
}


// 复制链接功能
function copyLink() {
    const sharePanel = document.getElementById('share-panel');
    const input = sharePanel ? sharePanel.querySelector('input') : null;
    if (input) {
        // 现代浏览器优先使用Clipboard API
        if (navigator.clipboard) {
            navigator.clipboard.writeText(input.value).then(() => {
                alert('链接已复制到剪贴板！');
            }, () => {
                // 失败时回退到旧方法
                input.select();
                document.execCommand('copy');
                alert('链接已复制到剪贴板！');
            });
        } else {
            input.select();
            document.execCommand('copy');
            alert('链接已复制到剪贴板！');
        }
    }
}
