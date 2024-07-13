const music = document.getElementById('music');
const img=document.getElementsByClassName("right");
const video=document.querySelector('.productVideo');
const videoPanel=document.querySelector('.videoPanel');
const bg=document.querySelector('.main_body_bg');
let isPlaying = false;
function playMusic() {
    if (!isPlaying) {
        music.play();
        img.src="images/musicPlay.png";
        isPlaying = true;
    }
}
function pauseMusic() {
    if (isPlaying) {
        music.pause();
        img.src="images/musicMute.png";
        isPlaying = false;
    }
}
function changeState(){
    if(isPlaying){
        pauseMusic();
    }else{
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
function playVideo(){
    music.pause();
    video.className='productVideo-active';
    video.play();
    videoPanel.className='videoPanel-active'
    console.log('点击了按钮');
}
function exitVideo(){
    playMusic();
    video.className='productVideo';
    video.pause();
    videoPanel.className='videoPanel';
}