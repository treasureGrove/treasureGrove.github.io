// Hide initial black overlay after key images (or timeout) have loaded.
(function(){
    var ov = document.getElementById('initial-black-overlay');
    if(!ov) return;

    function hide(){
        ov.style.opacity = '0';
        setTimeout(function(){ if(ov && ov.parentNode) ov.parentNode.removeChild(ov); }, 500);
    }

    function preloadImage(url){
        return new Promise(function(resolve){
            if(!url) return resolve();
            var img = new Image();
            img.onload = img.onerror = function(){ resolve(); };
            img.src = url;
            if(img.complete) resolve();
        });
    }

    // collect <img> srcs (exclude video/audio)
    var imgEls = Array.from(document.querySelectorAll('img'));
    var imgUrls = imgEls.map(function(i){ return i.src; }).filter(Boolean);

    // collect CSS background-image urls
    var allEls = Array.from(document.querySelectorAll('*'));
    allEls.forEach(function(el){
        try {
            var bg = getComputedStyle(el).backgroundImage || '';
            var m = bg.match(/url\(["']?(.*?)["']?\)/);
            if(m && m[1]) imgUrls.push(m[1]);
        } catch(e){}
    });

    // dedupe
    imgUrls = Array.from(new Set(imgUrls));

    var promises = imgUrls.map(preloadImage);

    // max wait to avoid long block (ms)
    var MAX_WAIT = 3000;

    Promise.race([
        Promise.allSettled(promises),
        new Promise(function(res){ setTimeout(res, MAX_WAIT); })
    ]).then(function(){
        setTimeout(hide, 80);
    });

    if(document.readyState === 'complete') {
        Promise.resolve().then(function(){ setTimeout(hide, 80); });
    }
})();
