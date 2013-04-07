function output = fftAvg(data, N)

rawData = data; 

numCols = floor(length(rawData)/N);

dataMatrix = reshape(rawData(1:numCols*N), N, numCols);

fftMatrix = abs(fft(dataMatrix));
output = fftshift(mean(fftMatrix'));
