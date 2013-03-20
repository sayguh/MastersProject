function noise = scaledNoise(N, Es_N0_dB)



% noise
% -----
n = 1/sqrt(2)*[randn(1,N) + j*randn(1,N)]; % white guassian noise, 0dB variance 
noise = 10^(-Es_N0_dB/20)*n; % additive white gaussian noise
