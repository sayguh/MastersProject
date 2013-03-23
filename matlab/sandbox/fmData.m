function rawData = fmData(fs, fc, bw, T, sampleType)

if sampleType == 'C'
  fs = 2*fs;
end

% Test FM Signal
t = linspace(0,T-1/fs, T*fs);  % This makes it 4 samples per symbol exactly
carrier = sin(2*pi*fc*t);


% pink noise used for input 
normDist = randn(1, length(t));
fNorm = (bw/2) / (fs/2);
[b,a] = butter(10, fNorm, 'low');
pinkNoise = filtfilt(b,a, normDist);


dev = 50;

rawData=fmmod(pinkNoise,fc,fs,dev);

if sampleType == 'C'
  rawData = hilbert(rawData);
  rawData = rawData(1:2:end);
end
