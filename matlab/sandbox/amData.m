function rawData = amData(T)

% Test FM Signal
fc = 2048;
fs = 8192;

t = linspace(0,T-1/fs, T*fs);  % This makes it 4 samples per symbol exactly
carrier = sin(2*pi*fc*t);

input = rand(1, length(t));
rawData=ammod(input,fc,fs);

