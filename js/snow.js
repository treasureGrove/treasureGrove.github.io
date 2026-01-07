let canvas = document.querySelector('canvas');
let context = canvas.getContext('2d');
let w = window.innerWidth;
let h = window.innerHeight;
canvas.width = w;
canvas.height = h;

let num = 100; // 适量的雪花数量
let snows = [];
for(let i = 0; i < num; i++){
    snows.push({
        x: Math.random() * w,
        y: Math.random() * h,
        r: Math.random() * 4 + 1,
        speed: Math.random() * 1.2 + 0.8
    });
}

let draw = () => {
    context.clearRect(0, 0, w, h);
    context.fillStyle = 'rgba(255, 255, 255, 0.8)';
    context.shadowColor = 'rgba(255, 255, 255, 0.5)';
    context.shadowBlur = 8;

    for(let i = 0; i < num; i++){
        let snow = snows[i];
        context.beginPath();
        context.arc(snow.x, snow.y, snow.r, 0, Math.PI * 2);
        context.fill();
    }
}

function move(){
    for(let i = 0; i < num; i++){
        let snow = snows[i];
        snow.y += snow.speed;
        snow.x += snow.speed * 1.333; 
        
        if(snow.y > h){
            snow.y = -10;
            snow.x = Math.random() * w;
        }
        if(snow.x > w){
            snow.x = 0;
        }
    }
}

function animate(){
    move();
    draw();
    requestAnimationFrame(animate);
}

// 启动动画
animate();