function [ansBlock Sxa Ia] = mySxa(rawData, sampleType, BlockSize, maxCols);


% Make BlockSize 512 and maxCols 100

%addpath('/home/ylb/workspace/gnuradio_src/gnuradio/gnuradio-core/src/utils/');
%rawData = read_complex_binary("/home/ylb/complex_ctr_99_5M_samp_2M.dat");

numCols = min(floor(length(rawData)/BlockSize), maxCols);

dataBlock = reshape(rawData(1:BlockSize*numCols), BlockSize, numCols);

a=hamming(BlockSize);
dataBlock=diag(a)*dataBlock;

%You have to specify the dimention of the fftshift or else it does multiple dimentions.
if sampleType == 'C'
  fftBlock = fft(dataBlock);  % For some reason an fft shift isn't needed with complex data
else
  fftBlock = fftshift(fft(dataBlock), 1);
end
%avgFFT = mean(transpose(fftBlock));
%figure; semilogy(linspace(-fs/2000,fs/2000,length(avgFFT)), abs(avgFFT));
%title('Average of FFT');

ansBlock = zeros(BlockSize, BlockSize+1);

% So alpha has a range in frequency of [-Fs/2, Fs/2] for real samples and [-Fs, Fs] for complex.
for alpha = -BlockSize:2:BlockSize
  for col = 1:numCols

    Xplusa = zeros(size(fftBlock(:,col)));
    Xmina = zeros(size(fftBlock(:,col)));

    if alpha < 0
      Xplusa(1-alpha/2:end) = fftBlock(1:end+alpha/2, col);
      Xmina(1:end+alpha/2) = fftBlock(1-alpha/2:end, col);
    else
      Xplusa(1:end-alpha/2) = fftBlock(1+alpha/2:end, col);
      Xmina(1+alpha/2:end) = fftBlock(1:end-alpha/2, col);
    end
%    printf("alpha = %i, col = %i\n", alpha, col);
%    fflush(stdout);

    Xplusa = Xplusa(:);
    Xmina = Xmina(:);

    % I'm just averaging here.  Where N = numCols.  
    ansBlock(:, alpha/2+BlockSize/2+1) += Xplusa .* conj(Xmina);
  end

%  printf("alpha = %i of %i \n", alpha, BlockSize);
%  fflush(stdout);
end

% Now just get the magnitude from 0 to 1 of each of the columns
% It's Sxa/[Sx(f+a)*Sx(f-a)]
Sx = ansBlock(:, BlockSize/2 + 1);
Sxa = zeros(BlockSize, BlockSize+1);
for alpha = -BlockSize:2:BlockSize

    SXplusa = zeros(size(Sx));
    SXmina = zeros(size(Sx));

  if alpha < 0
    SXplusa(1-alpha/2:end) = Sx(1:end+alpha/2);
    SXmina(1:end+alpha/2) = Sx(1-alpha/2:end);
  else
    SXplusa(1:end-alpha/2) = Sx(1+alpha/2:end);
    SXmina(1+alpha/2:end) = Sx(1:end-alpha/2);
  end

    Sxa(:,alpha/2+BlockSize/2+1) = ansBlock(:,alpha/2+BlockSize/2+1) ./ (SXplusa .* SXmina).^(1/2);
end
ansBlock(isnan(ansBlock))=0;
Sxa(isnan(Sxa))=0;

Ia = max(abs(Sxa));

% Ia is semetrical around 0 so we only have to plot half of it
numPoints = ceil(length(Ia)/2);
alphaAdj = linspace(0,1,numPoints);

figure; plot(alphaAdj, Ia(numPoints:end));
title('Cycle Frequency Domain Profile');
