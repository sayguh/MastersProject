function rawData = bpskData(T)

% Test BPSK Signal
fc = 2048;
rb = 2048;
fs = 8192;

t = linspace(0,T-1/fs, T*fs);  % This makes it 4 samples per symbol exactly
carrier = sin(2*pi*fc*t);


sampPerSym = fs/fc;
input = [];
% There has to be a better way to do this but whatever
while (length(input) < length(carrier))
  input = [input (2*round(rand)-1)*ones(1,sampPerSym)];
endwhile

rawData = input.*carrier;
