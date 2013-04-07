function [Sxa Ia] = mySxa(rawData, sampleType, Fc, Fs, BlockSize, maxAvg);

%Scale incoming data
rawData = rawData / max(rawData);

% Make BlockSize 512 and maxCols 100

doPlot = 0;

numCols = min(floor(length(rawData)/BlockSize), maxAvg);
dataBlock = reshape(rawData(1:BlockSize*numCols), BlockSize, numCols);

a=hamming(BlockSize);
dataBlock=diag(a)*dataBlock;

%You have to specify the dimention of the fftshift or else it does multiple dimentions.
if sampleType == 'C'
  fftBlock = fft(dataBlock);  % For some reason an fft shift isn't needed with complex data
else
  fftBlock = fftshift(fft(dataBlock), 1);
end

Sxa = zeros(BlockSize, BlockSize+1);

% So alpha has a range in frequency of [-Fs/2, Fs/2] for real samples and [-Fs, Fs] for complex.
for alpha = -BlockSize:2:BlockSize
  for col = 1:numCols
    Sxa(:, alpha/2+BlockSize/2+1) += zeroShift(fftBlock(:,col), alpha/2) .* conj(zeroShift(fftBlock(:,col), -alpha/2));
  end
end

S = Sxa(:, BlockSize/2+1);

% alpha = 0 is pointless.
Sxa(:, BlockSize/2+1) = [];

Ia = max(abs(Sxa));
alphaAxis = linspace(-Fs/2, Fs/2, BlockSize);
foAxis = linspace(Fc, Fc+Fs, BlockSize);




if doPlot == 1
  figure; 
  surf(alphaAxis, foAxis, abs(Sxa)); 
  title('Cycle Spectrum');
  xlabel('alpha (hz)');
  ylabel('freq (hz)');
  
  figure;
  plot(alphaAxis, Ia);
  xlabel('alpha (hz)');
  title('Cycle Frequency Domain Profile');

end
