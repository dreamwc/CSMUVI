function s = reverseWavelet(x, wave)

x = reshape(x, wave.siz);
tmp = wavedec2(x, wave.level, wave.name);
s = tmp(:);
