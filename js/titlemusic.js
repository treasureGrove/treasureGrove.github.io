// 标记是否已经有用户交互
let hasUserInteracted = sessionStorage.getItem('__hasUserInteracted') === 'true';

document.addEventListener('DOMContentLoaded', () => {
    initializeShareFeature();
    
    // 初始化音乐：静音模式自动播放
    try {
        const audio = document.getElementById('music');
        if (audio) {
            audio.preload = 'auto';
            audio.loop= true;
            
            // 如果用户之前已经交互过，直接取消静音
            if (hasUserInteracted) {
                audio.muted = false;
            } else {
                audio.muted = true; // 首次访问，设置为静音
            }
            
            // 尝试自动播放
            const tryAutoPlay = () => {
                audio.play().then(() => {
                    console.log(hasUserInteracted ? 'Music started with sound' : 'Music started in muted mode');
                    isPlaying = true;
                    image1.src = "https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/images/musicPlay.webp";
                }).catch(err => {
                    // 静默处理自动播放失败（这是预期行为，等待用户交互）
                    console.log('⏸️ 等待用户交互后播放音乐');
                    isPlaying = false;
                    // 播放失败时，强制需要用户交互
                    hasUserInteracted = false;
                    sessionStorage.removeItem('__hasUserInteracted');
                });
            };

            // 恢复播放位置和状态
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
                // 没有保存状态，直接尝试播放
                if (audio.readyState >= 1) tryAutoPlay();
                else audio.addEventListener('loadedmetadata', tryAutoPlay, { once: true });
            }
        }
    } catch (e) {
        console.error('Music initialization error:', e);
    }

    // 监听用户首次交互，取消静音（延迟到初始化完成后检查）
    setTimeout(() => {
        if (!hasUserInteracted) {
            setupUserInteractionListener();
        } else {
            console.log('✓ 用户之前已交互过，音乐正常播放中');
        }
    }, 100);
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

// 设置用户交互监听器，首次交互时取消静音
function setupUserInteractionListener() {
    console.log('🎵 等待用户交互以取消静音...');
    console.log('📌 hasUserInteracted 当前状态:', hasUserInteracted);
    
    const unmuteAudio = (event) => {
        console.log('🖱️ 检测到用户交互:', event.type);
        console.log('📌 处理前 hasUserInteracted:', hasUserInteracted);
        
        const music = document.getElementById('music');
        console.log('🎵 音乐元素:', music ? '存在' : '不存在');
        
        if (music && !hasUserInteracted) {
            console.log('🔊 当前静音状态:', music.muted);
            console.log('▶️ 当前播放状态:', music.paused ? '暂停' : '播放中');
            
            music.muted = false;
            
            // 取消静音后重新播放音乐
            music.play().then(() => {
                // 只有播放成功后才标记为已交互
                hasUserInteracted = true;
                sessionStorage.setItem('__hasUserInteracted', 'true');
                console.log('✅ 音乐已取消静音并开始播放！');
                isPlaying = true;
                const image1 = document.getElementsByClassName("right")[0];
                if (image1) {
                    image1.src = "https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/images/musicPlay.webp";
                }
            }).catch(err => {
                console.error('❌ 播放失败:', err);
                console.log('💡 提示：请尝试再次点击页面');
                // 播放失败，恢复静音状态，等待下次有效交互
                music.muted = true;
            });
        } else if (hasUserInteracted) {
            console.log('⚠️ 已经标记为交互过了');
        } else {
            console.log('⚠️ 找不到音乐元素');
        }
    };

    // 只监听浏览器认可的有效交互事件（click、keydown、touchstart）
    console.log('📢 注册点击事件监听器...');
    document.addEventListener('click', unmuteAudio, { once: true, capture: true });
    document.addEventListener('keydown', unmuteAudio, { once: true, capture: true });
    document.addEventListener('touchstart', unmuteAudio, { once: true, capture: true });
    console.log('✓ 事件监听器已注册');
}
//musics
let music = document.getElementById('music');
let image1 = document.getElementsByClassName("right")[0];
//videos
const video = document.querySelector('.productVideo');
const videoPanel = document.querySelector('.videoPanel');
const bg = document.querySelector('.main_body_bg');
//shares
let isPlaying = true;
function playMusic() {
    if (music) {
        music.play().then(() => {
            // 如果这是用户主动点击播放，取消静音
            if (!hasUserInteracted) {
                hasUserInteracted = true;
                music.muted = false;
            }
            image1.src = "https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/images/musicPlay.webp";
            isPlaying = true;
            console.log('Music playing');
        }).catch(err => {
            console.log('Play failed:', err);
        });
    }
}
function pauseMusic() {
    if (music) {
        music.pause();
        image1.src = "https://blog-image-1316340567.cos.ap-shanghai.myqcloud.com/blog/images/musicMute.webp";
        isPlaying = false;
        console.log('Music paused');
    }
}
function changeState() {
    if (isPlaying) {
        pauseMusic();
    } else {
        playMusic();
    }
}
// 移除visibilitychange事件，允许后台播放
// 如果需要后台暂停，可以取消注释下面的代码：
// document.addEventListener('visibilitychange', () => {
//     if (document.visibilityState === 'hidden') {
//         pauseMusic();
//     } else if (isPlaying) {
//         playMusic();
//     }
// });
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
