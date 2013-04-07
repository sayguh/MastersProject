function detectWithRTL(Ft, ds, BW)

Fs = 2000000;
Fo = Ft - 88100000;
N = 1024;

addpath('/home/ylb/workspace/gnuradio_src/gnuradio/gnuradio-core/src/utils/');


rawData = read_complex_binary('/home/ylb/ylb_complex_ctr_88_1M_samp_2M.dat');

rawData = rawData(1:1000000);

%figure; plot(linspace( fftshift(abs(fft(rawData)))); title('rawData');

% Tune
shiftedSignal = freqShift(rawData, Fo, Fs);
f = linspace(Ft/1000000 - 1, Ft/1000000 + 1, N);
figure; plot(f, 20*log10(fftAvg(shiftedSignal, N))); title('Frequency Shifted');
xlabel('Frequency (Mhz)');
ylabel('dB');

% Filter
fnorm = BW/Fs;
[b1,a1] = butter(10,fnorm,'low'); % Low pass Butterworth filter of order 10
lowData = filtfilt(b1,a1,shiftedSignal); % filtering
figure; plot(f, 20*log10(fftAvg(lowData, N))); title('Filtered');
xlabel('Frequency (Mhz)');
ylabel('dB');

% Decimate
IQdata = lowData(1:ds:end);

figure; plot(20*log10(fftAvg(IQdata, N))); title('Decimated');
ylabel('dB');
figure; plot(real(IQdata), imag(IQdata),'.'); title('IQ Plot');


[M C40 C42] = CumulantClassifier(shiftedSignal)
