let hasUserInteracted = sessionStorage.getItem('__hasUserInteracted') === 'true';

document.addEventListener('DOMContentLoaded', () => {
    initializeShareFeature();
    try {
        const audio = document.getElementById('music');
        if (audio) {
            audio.preload = 'auto';
            audio.loop = true;
            if (hasUserInteracted) {
                audio.muted = false;
            } else {
                audio.muted = true;
            }
            const tryAutoPlay = () => {
                audio.play().then(() => {
                    isPlaying = true;
                    image1.src = "https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/images/musicPlay.webp";
                }).catch(err => {
                    isPlaying = false;
                    hasUserInteracted = false;
                    sessionStorage.removeItem('__hasUserInteracted');
                });
            };
            const savedTime = sessionStorage.getItem('__musicTime');
            const savedPlaying = sessionStorage.getItem('__musicPlaying');
            if (savedTime !== null) {
                const t = parseFloat(savedTime);
                const resume = savedPlaying === '1';
                const restore = () => {
                    try { audio.currentTime = Math.max(0, Math.min(t, (audio.duration || t))); } catch (e) {}
                    if (resume) {
                        tryAutoPlay();
                    }
                    sessionStorage.removeItem('__musicTime');
                    sessionStorage.removeItem('__musicPlaying');
                };
                if (audio.readyState >= 1) restore();
                else audio.addEventListener('loadedmetadata', restore, { once: true });
            } else {
                if (audio.readyState >= 1) tryAutoPlay();
                else audio.addEventListener('loadedmetadata', tryAutoPlay, { once: true });
            }
        }
    } catch (e) {
        console.error('Music initialization error:', e);
    }
    setTimeout(() => {
        if (!hasUserInteracted) {
            setupUserInteractionListener();
        } else {
        }
    }, 100);
});

function initializeShareFeature() {
    const shareIcon = document.getElementById('right-share');
    const sharePanel = document.getElementById('share-panel');
    if (shareIcon && sharePanel) {
        var hideTimer = null;
        // 移动端：将面板移到body下，避免父元素backdrop-filter破坏fixed定位
        if (window.innerWidth <= 768) {
            document.body.appendChild(sharePanel);
        }

        function showPanel() {
            if (hideTimer) { clearTimeout(hideTimer); hideTimer = null; }
            if (window.innerWidth > 768) {
                var rect = shareIcon.getBoundingClientRect();
                sharePanel.style.position = 'absolute';
                sharePanel.style.left = (rect.left - 160) + 'px';
                sharePanel.style.top = (rect.bottom + window.scrollY) + 'px';
                sharePanel.style.transform = '';
                sharePanel.style.width = '';
            }
            sharePanel.style.display = 'block';
        }

        function hidePanel() {
            sharePanel.style.display = 'none';
        }

        shareIcon.addEventListener('click', function (e) {
            e.stopPropagation();
            if (sharePanel.style.display === 'block') {
                hidePanel();
            } else {
                showPanel();
            }
        });

        shareIcon.addEventListener('mouseenter', function () {
            if (window.innerWidth > 768) { showPanel(); }
        });
        shareIcon.addEventListener('mouseleave', function () {
            if (window.innerWidth > 768) {
                hideTimer = setTimeout(hidePanel, 1500);
            }
        });
        sharePanel.addEventListener('mouseenter', function () {
            if (hideTimer) { clearTimeout(hideTimer); hideTimer = null; }
        });
        sharePanel.addEventListener('mouseleave', function () {
            if (window.innerWidth > 768) {
                hideTimer = setTimeout(hidePanel, 800);
            }
        });

        document.addEventListener('click', function (e) {
            if (!shareIcon.contains(e.target) && !sharePanel.contains(e.target)) {
                hidePanel();
            }
        });
        document.addEventListener('touchstart', function (e) {
            if (!shareIcon.contains(e.target) && !sharePanel.contains(e.target)) {
                hidePanel();
            }
        }, { passive: true });
    }
}

function setupUserInteractionListener() {
    const unmuteAudio = (event) => {
        const music = document.getElementById('music');
        if (music && !hasUserInteracted) {
            music.muted = false;
            music.play().then(() => {
                hasUserInteracted = true;
                sessionStorage.setItem('__hasUserInteracted', 'true');
                isPlaying = true;
                const image1 = document.getElementsByClassName("right")[0];
                if (image1) {
                    image1.src = "https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/images/musicPlay.webp";
                }
            }).catch(err => {
                console.error('❌ 播放失败:', err);
                music.muted = true;
            });
        } else if (hasUserInteracted) {
        } else {
        }
    };
    document.addEventListener('click', unmuteAudio, { once: true, capture: true });
    document.addEventListener('keydown', unmuteAudio, { once: true, capture: true });
    document.addEventListener('touchstart', unmuteAudio, { once: true, capture: true });
}

let music = document.getElementById('music');
let image1 = document.getElementsByClassName("right")[0];
const video = document.querySelector('.productVideo');
const videoPanel = document.querySelector('.videoPanel');
const bg = document.querySelector('.main_body_bg');
let isPlaying = true;
function playMusic() {
    if (music) {
        music.play().then(() => {
            if (!hasUserInteracted) {
                hasUserInteracted = true;
                music.muted = false;
            }
            image1.src = "https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/images/musicPlay.webp";
            isPlaying = true;
        }).catch(err => {
            console.error('Play failed:', err);
        });
    }
}
function pauseMusic() {
    if (music) {
        music.pause();
        image1.src = "https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/images/musicMute.webp";
        isPlaying = false;
    }
}
function changeState() {
    if (isPlaying) {
        pauseMusic();
    } else {
        playMusic();
    }
}
function playVideo() {
    music.pause();
    video.className = 'productVideo-active';
    video.play();
    videoPanel.className = 'videoPanel-active'
}
function exitVideo() {
    playMusic();
    video.className = 'productVideo';
    video.pause();
    videoPanel.className = 'videoPanel';
}

function copyLink() {
    var panel = document.getElementById('share-panel');
    var input = panel ? panel.querySelector('input') : null;
    if (!input) return;
    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(input.value).then(function () {
            alert('链接已复制到剪贴板！');
        }).catch(function () {
            fallbackCopy(input);
        });
    } else {
        fallbackCopy(input);
    }
}
function fallbackCopy(input) {
    input.select();
    input.setSelectionRange(0, 99999);
    document.execCommand('copy');
    alert('链接已复制到剪贴板！');
}
