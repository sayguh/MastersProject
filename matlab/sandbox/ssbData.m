function rawData = ssbData(fs, fc, bw, T, sampleType)

if sampleType == 'C'
  fs = fs*2;
end


t = linspace(0,T-1/fs, T*fs);  % This makes it 4 samples per symbol exactly

% pink noise used for input 
normDist = randn(1, length(t));
fNorm = (bw/2) / (fs/2);
[b,a] = butter(10, fNorm, 'low');
pinkNoise = filtfilt(b,a, normDist);

rawData=ssbmod(pinkNoise,fc,fs);

if sampleType == 'C'
  rawData = hilbert(rawData);
  rawData = rawData(1:2:end);
end
