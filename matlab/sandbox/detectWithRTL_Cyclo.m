function [Sxa Ia] = detectWithRTL_Cyclo(Ft, ds, BW);

Fs = 2000000;
Fo = Ft - 88100000;
BlockSize = 128;
maxAvg = 100;
N = 1024;

addpath('/home/ylb/workspace/gnuradio_src/gnuradio/gnuradio-core/src/utils/');


rawData = read_complex_binary('/home/ylb/ylb_complex_ctr_88_1M_samp_2M.dat');

rawData = rawData(1:1000000);

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
baseBandSignal = lowData(1:ds:end);

figure; plot(20*log10(fftAvg(baseBandSignal, N))); title('Decimated');
ylabel('dB');


[Sxa Ia] = mySxa(baseBandSignal, 'C', Ft, Fs, BlockSize, maxAvg);
