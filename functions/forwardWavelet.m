function x = forwardWavelet(s, wave)

tmp = waverec2(s, wave.Cbook, wave.name);
x = tmp(:);
