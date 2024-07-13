// 定义变量
let offset = 0;
let maxOffset = 0;
let minOffset = -3;
// 获取所有卡片元素并存储在数组中
const slides = Array.from(document.querySelectorAll(".card"));
// 获取时钟表盘元素
const clock = document.querySelector("#clock-table");
// 设定起始年份为2021
let startYear = 1;
for (let i = -60, year = startYear - 1; i < 300; i += 6) {
    // 调用添加时钟刻度函数
    addClockScale(i);
    if (i % 60 === 0) {
        // 如果为整点时，调用添加粗刻度函数
        addThickClockScale(i, year);
        year++;
    }
}
// 添加时钟刻度
function addClockScale(degree) {
    // 创建一个隐藏的表格元素
    const invisibleClockTable = document.createElement("div");
    // 添加类名
    invisibleClockTable.className = "invisible-table";
    // 设置旋转角度
    invisibleClockTable.style.transform = `rotate(${degree}deg)`;
    // 创建时钟刻度元素
    const clockScale = document.createElement("div");
    // 添加类名
    clockScale.className = "clock-scale";
    // 将时钟刻度元素添加到表格中
    invisibleClockTable.appendChild(clockScale);
    // 将表格添加到时钟表盘中
    clock.appendChild(invisibleClockTable);
}
// 添加粗刻度
function addThickClockScale(degree, time) {
    // 创建一个隐藏的表格元素
    const invisibleClockTable = document.createElement("div");
    invisibleClockTable.className = "invisible-table";
    invisibleClockTable.style.transform = `rotate(${degree}deg)`;
    const thickClockScale = document.createElement("div");
    thickClockScale.className = "clock-thick";
    const scaleContent = document.createElement("span");
    scaleContent.textContent = `0${time}`;
    thickClockScale.appendChild(scaleContent);
    invisibleClockTable.appendChild(thickClockScale);
    clock.appendChild(invisibleClockTable);
}
// 向前切换卡片
function slideToPrev() {
    // 更新偏移量，取最大值
    offset = Math.min(maxOffset, offset + 1);
    slides.forEach(slide => {
        // 根据偏移量设置卡片垂直偏移效果
        slide.style.transform = `translateY(${offset * 100}%)`;
    });
    // 调用旋转时钟表盘函数
    clockRotate(offset * 60);
}
// 向后切换卡片
function slideToNext() {
    offset = Math.max(minOffset, offset - 1);
    slides.forEach(slide => {
        slide.style.transform = `translateY(${offset * 100}%)`;
    });
    clockRotate(offset * 60);
}
// 旋转时钟表盘
function clockRotate(degree) {
    // 根据角度旋转时钟表盘
    clock.style.transform = `rotate(${degree}deg)`;
}