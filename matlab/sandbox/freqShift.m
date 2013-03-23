function output = freqShift(input, fo, Fs)

numP = length(input);
output = input.*exp(-i*2*pi*fo*1/Fs*(0:(numP-1)));
