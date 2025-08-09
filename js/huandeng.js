
// 幻灯片轮播旧版还原
let chosenSlideNumber = 1; // 当前显示的幻灯片编号
let intervalID;

function slideTo(slideNumber) {
  // 切换抽屉面板和按钮状态
  const drawerboxes = document.querySelectorAll('.drawerbox');
  const drawerBtns = document.querySelectorAll('.drawer-btn');
  // 取消上一个active
  drawerboxes[chosenSlideNumber - 1].classList.remove('active');
  drawerBtns[chosenSlideNumber - 1].classList.remove('active');
  // 设置当前active
  drawerboxes[slideNumber - 1].classList.add('active');
  drawerBtns[slideNumber - 1].classList.add('active');
  // 切换幻灯片
  const slides = document.querySelectorAll('.card');
  slides.forEach((slide, idx) => {
    slide.style.transform = `translateY(${(idx - (slideNumber - 1)) * 100}%)`;
  });
  // 移动导航条
  const bar = document.querySelector('#bar');
  bar.style.transform = `translateY(${(slideNumber - 1) * 100}%)`;
  chosenSlideNumber = slideNumber;
}

function startSlide() {
  clearInterval(intervalID);
  intervalID = setInterval(() => {
    let next = chosenSlideNumber + 1;
    if (next > 4) next = 1;
    slideTo(next);
  }, 3000);
}

// 按钮事件
document.addEventListener('DOMContentLoaded', () => {
  const drawerBtns = Array.from(document.querySelectorAll('.drawer-btn'));
  drawerBtns.forEach((btn, idx) => {
    btn.addEventListener('click', () => {
      slideTo(idx + 1);
      startSlide();
    });
  });
  // 鼠标悬停暂停轮播
  const slideSection = document.querySelector('#slide-section');
  slideSection.addEventListener('mouseenter', () => {
    clearInterval(intervalID);
  });
  slideSection.addEventListener('mouseleave', () => {
    startSlide();
  });
  // 初始化
  slideTo(1);
  startSlide();
});

