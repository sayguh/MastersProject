%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function will calculate the known cdf of a QAM signal as defined by 
% equation 11 in the paper "Low Complexity Kolmogrorov-Smirnov
% Modulation Classification"
% by Wang, Xu, Zhong.
% Checked for proper operation with Octave Version 3.0.0
% Author	: Youssef Bagoulla
% Email		: sayguh@gmail.com
% Version	: 1.0
% Date		: 15 April 2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [F, Qsum] = qamCDF(M, z, SNR);

if M > 2
  normFactor = 1 / sqrt(2/3 * (M-1));
end

if (M == 2)
  realComp = [-1 1];
elseif (M == 4)
  realComp = normFactor* [-1 1];
elseif (M == 16)
  realComp = normFactor * [-3 -1 1 3];
elseif (M == 64)
  realComp = normFactor * [-7 -5 -3 -1 1 3 5 7];
end


Q = qfunc(sqrt(2 * SNR) * (z - realComp));
F = 1 - mean(Q);  

