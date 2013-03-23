function rawData = ssbData(fs, fc, T, sampleType)

if sampleType == 'C'
  fs = fs*2;
end


t = linspace(0,T-1/fs, T*fs);  % This makes it 4 samples per symbol exactly

input = rand(1, length(t));
rawData=ssbmod(input,fc,fs);

if sampleType == 'C'
  rawData = hilbert(rawData);
  rawData = rawData(1:2:end);
end
