function rawData = bpskData(fs, fc, rb, T, sampleType)

if sampleType == 'C' 
  fs = fs*2;
end

% Test BPSK Signal
t = linspace(0,T-1/fs, T*fs);
carrier = sin(2*pi*fc*t);

% Sample frequency divided by bit rate is the number of samples per symbol
% We'll round so we get only integer multiples.
sampPerSym = round(fs/rb);
input = [];
% There has to be a better way to do this but whatever
while (length(input) < length(carrier))
  input = [input (2*round(rand)-1)*ones(1,sampPerSym)];
endwhile

rawData = input(1:length(carrier)).*carrier;

if sampleType == 'C'
  rawData = hilbert(rawData);
  rawData = rawData(1:2:end);
end
