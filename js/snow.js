let canvas =document.querySelector('canvas');
let context=canvas.getContext('2d');
let w=window.innerWidth;
let h=window.innerHeight;
canvas.width=w;
canvas.height=h;

let num = 200;
let snows=[];
for(let i=0;i<num;i++){
    snows.push({
        x:Math.random()*w,y:Math.random()*h,r:Math.random()*5
    });
}
// let move=()=>{
//     for(let i=0;i<num;i++){
//         let snow =snows[i];
//         snow.x+=Math.random()*2+1;
//         snow.y+=Math.random()*2+1;
//         if(snow.x>w){
//             snow.x=0;
//         }
//         if(snow.y>h){
//             snow.y=0;
//         }
//     }
// }
let draw=()=>{
    context.clearRect(0,0,w,h);
    context.beginPath();
    context.fillStyle='rgb(255,255,255)';
    context.shadowColor='rgb(255,255,255)';
    context.shadowBlur=10;

    for(let i=0;i<num;i++){
        let snow=snows[i];
        context.moveTo(snow.x,snow.y);
        context.arc(snow.x,snow.y,snow.r,0,Math.PI*2);
    }
    context.fill();
    move();
}

function move(){
    for(var i=0;i<num;i++){
        var snow=snows[i];
        snow.y+=(7-snow.r)/10;
        snow.x+=Math.random();
        if(snow.y>h){
            snows[i]={x:Math.random() * w,y:0,r:snow.r}
        }
        if(snow.x>w){
            snows[i]={x:0,y:Math.random() * h,r:snow.r}
        }
    }
}
setInterval(draw,5)