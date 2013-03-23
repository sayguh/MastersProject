function rawData = amData(fs, fc, T, sampleType)

if sampleType == 'C'
  fs = fs*2;
end

t = linspace(0,T-1/fs, T*fs);  
carrier = sin(2*pi*fc*t);

input = rand(1, length(t));
rawData=ammod(input,fc,fs);

if sampleType == 'C'
  rawData = hilbert(rawData);
  rawData = rawData(1:2:end);
end
