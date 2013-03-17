function rawData = ssbData(T)

% Test FM Signal
fc = 2048;
fs = 8192;

t = linspace(0,T-1/fs, T*fs);  % This makes it 4 samples per symbol exactly

input = rand(1, length(t));
rawData=ssbmod(input,fc,fs);

