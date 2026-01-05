document.addEventListener('DOMContentLoaded', () => {
    initializeShareFeature();
    // restore music playback position and state if available
    try {
        const audio = document.getElementById('music');
        if (audio) audio.preload = 'auto';
        const savedTime = sessionStorage.getItem('__musicTime');
        const savedPlaying = sessionStorage.getItem('__musicPlaying');
        if (audio && savedTime !== null) {
            const t = parseFloat(savedTime);
            const resume = savedPlaying === '1';

            const restore = () => {
                try { audio.currentTime = Math.max(0, Math.min(t, (audio.duration || t))); } catch (e) {}

                if (resume) {
                    // play with muted volume then ramp up to avoid audible glitch
                    try { audio.volume = 0; } catch (e) {}
                    const p = audio.play();
                    if (p && p.catch) p.catch(() => { try { audio.volume = 1; } catch (e) {} });

                    const start = performance.now();
                    const dur = 350;
                    function ramp(now) {
                        const elapsed = now - start;
                        const v = Math.min(1, elapsed / dur);
                        try { audio.volume = v; } catch (e) {}
                        if (v < 1) requestAnimationFrame(ramp);
                    }
                    requestAnimationFrame(ramp);
                }

                sessionStorage.removeItem('__musicTime');
                sessionStorage.removeItem('__musicPlaying');
            };

            if (audio.readyState >= 1) restore();
            else audio.addEventListener('loadedmetadata', restore, { once: true });
        }
    } catch (e) {}
});
function initializeShareFeature() {
    const shareIcon = document.getElementById('right-share');
    const sharePanel = document.getElementById('share-panel');

    if (shareIcon && sharePanel) {
        shareIcon.addEventListener('mouseenter', () => {
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
    image1.src = "https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/images/musicPlay.webp";
    isPlaying = true;
    console.log('Music playing');
}
function pauseMusic() {
    music.pause();
    image1.src = "https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/images/musicMute.webp";
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
    const input = sharePanel.querySelector('input');
    input.select();
    document.execCommand('copy');
    alert('链接已复制到剪贴板！');
}
