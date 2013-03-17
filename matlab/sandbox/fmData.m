function rawData = fmData(fs, fc, T)

% Test FM Signal
t = linspace(0,T-1/fs, T*fs);  % This makes it 4 samples per symbol exactly
carrier = sin(2*pi*fc*t);

%input = sin(2*pi*300*t)+2*sin(2*pi*600*t); % Channel 1
input = rand(1, length(t));
dev = 50;

rawData=fmmod(input,fc,fs,dev);

