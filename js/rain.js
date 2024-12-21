setInterval(function() {
    var rain = document.createElement("div");
    
    rain.style.position = "fixed";
    rain.style.height = "35px";
    rain.style.width = "2px";
    rain.style.background = "#FFF";
    rain.style.filter = "blur(1px)";
    rain.style.top = "0px";
    rain.style.left = Math.random() * 1920 + "px";
    rain.style.opacity = parseInt(Math.random() * 10) / 10 + "";
    
    document.body.appendChild(rain);
    
    var timer = setInterval(function() {
        var height = parseInt(rain.style.top);
        var k = 1;
        k++;
        
        rain.style.top = height + Math.pow(k, 1.5) + "%";
        
        if (parseInt(rain.style.top) >= 100) {
            clearInterval(timer);
            rain.parentNode.removeChild(rain);
        }
    }, 4)
}, 8)
