function manipulateCollect(N)

addpath('/home/ylb/workspace/gnuradio_src/gnuradio/gnuradio-core/src/utils/');


rawData = read_complex_binary('/home/ylb/ylb_complex_ctr_88_1M_samp_2M.dat');

numCols = floor(length(rawData)/N);


dataMatrix = reshape(rawData(1:numCols*N), N, numCols);

fftMatrix = abs(fft(dataMatrix));
fftVector = fftshift(mean(fftMatrix'));

freq = linspace(87.1, 89.1, N);

plot(freq, 20*log10(fftVector));
title('FFT Average: Fc 88.1Mhz Fs 2Msps');
xlabel('Frequency (Mhz)');
ylabel('dB');
