function [M C40 C42] = testCumulant(input, SNR, Fc, Fs)

% I'm guessing that if you don't sample at the proper rate of the input signal
% the IQ plot will start to spin and it'll do a poor job of classifying.

% Add noise to the signal to the desired SNR
noisySig = input + awgn(input, SNR, 'measured');

% Shift the sigal to baseband.
shiftedSignal = freqShift(noisySig, Fc, Fs);

% Down sample:
% NOTE: I do not know why I can't just down sample normally.  I have to take the first sample for real and the next for imag....why? 
IQdata = real(shiftedSignal(1:4:end-1)) + i*imag(shiftedSignal(2:4:end));

% Scale the data to the unit circle.
% Probably not necessary since we scale the result but whatever
IQdata = IQdata/abs(max(IQdata));

%figure; plot(abs(fft(IQdata)));
%figure; plot(real(IQdata), imag(IQdata), 'o');

[M C40 C42] = CumulantClassifier(IQdata);


