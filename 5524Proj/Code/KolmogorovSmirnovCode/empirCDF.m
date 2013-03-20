%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function will calculate the empirical cdf as defined by 
% equation 4 in the paper "Low Complexity Kolmogrorov-Smirnov
% Modulation Classification"
% by Wang, Xu, Zhong.
% Checked for proper operation with Octave Version 3.0.0
% Author	: Youssef Bagoulla
% Email		: sayguh@gmail.com
% Version	: 1.0
% Date		: 15 April 2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FofZ = empirCDF(z, zArray) 

N = length(zArray);

FofZ = 1/N*sum(z >= zArray);
