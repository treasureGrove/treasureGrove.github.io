const audioContext = new (window.AudioContext || window.webkitAudioContext)();
  const audioElement = document.getElementById('music');
  const audioContainer = document.getElementById('audio-container');
  const bars = 30; // 条形的数量
  // 创建条形
  for (let i = 0; i < bars; i++) {
    const bar = document.createElement('div');
    bar.className = 'bar';
    audioContainer.appendChild(bar);
  }

  // 解析音频数据
  const source = audioContext.createMediaElementSource(audioElement);
  const analyser = audioContext.createAnalyser();
  source.connect(analyser);
  analyser.connect(audioContext.destination);
  analyser.fftSize = 64;
  const bufferLength = analyser.frequencyBinCount;
  const dataArray = new Uint8Array(bufferLength);

  function renderFrame() {
    requestAnimationFrame(renderFrame);
    analyser.getByteFrequencyData(dataArray);

    // 更新条形高度
    for (let i = 0; i < bars; i++) {
      const bar = audioContainer.children[i];
      const height = dataArray[i] * (bar.offsetHeight / 255);
      bar.style.height = `${height}px`;
    }
  }

  audioElement.addEventListener('play', () => {
    audioContext.resume();
    renderFrame();
  });