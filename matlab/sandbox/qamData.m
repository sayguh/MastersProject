function rawData = qamData(fs, fc, rb, m, T, sampleType)

if sampleType == 'C'
  fs = fs*2;
end


% m is the number of points in constellation

if m == 4
  scale = [-1 1];
elseif m == 16
  scale = [-3 -1 1 3];
elseif m == 64
  scale = [-7 -5 -3 -1 1 3 5 7];
end


t = linspace(0,T-1/fs, T*fs);  % This makes it 4 samples per symbol exactly
carrier1 = -sin(2*pi*fc*t);
carrier2 = cos(2*pi*fc*t);

sampPerSym = fs/rb;
input1 = [];
input2 = [];
% There has to be a better way to do this but whatever
while (length(input1) < length(carrier1))
  input1 = [input1 scale(ceil(sqrt(m)*rand))*ones(1, sampPerSym)];
  input2 = [input2 scale(ceil(sqrt(m)*rand))*ones(1, sampPerSym)];
endwhile

rawData = input1(1:length(carrier1)).*carrier1 + input2(1:length(carrier2)).*carrier2;

if sampleType == 'C'
  rawData = hilbert(rawData);
  rawData = rawData(1:2:end);
end
