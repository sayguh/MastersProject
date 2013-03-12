function [Sxa Ia] = mySxa();


%addpath('/home/ylb/workspace/gnuradio_src/gnuradio/gnuradio-core/src/utils/');

% Test BPSK Signal
T = 2; % Seconds
fc = 2048;
rb = 2048;
fs = 8192;


rawData = qamData(16, T);
%rawData = qamData(4, T);
%rawData = bpskData(4, T);

fftData = fftshift(fft(rawData));
freq = linspace(-fs/2, fs/2, length(fftData));

%%%%%%%%%%%%%%%%%

BlockSize = 512;
maxCols = BlockSize;

%Testing
%maxCols = 4;
%BlockSize = 8;

%rawData = read_float_binary("/home/ylb/Fs_2M_Fc_108M.dat");
%rawData = read_float_binary("/home/ylb/NBFM_44_1k_real.dat");
%rawData = read_float_binary("/home/ylb/QAM4_44_1k_real.dat");



%rawData = rand(BlockSize*maxCols,1);

%Testing
%rawData = 1:32;

numCols = min(floor(length(rawData)/BlockSize), maxCols);

dataBlock = reshape(rawData(1:BlockSize*numCols), BlockSize, numCols);

%You have to specify the dimention of the fftshift or else it does multiple dimentions.
fftBlock = fftshift(fft(dataBlock), 1);


%fftBlock = dataBlock;


ansBlock = zeros(BlockSize, BlockSize+1);


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

Sxa(isnan(Sxa))=0;

Ia = max(abs(Sxa));

