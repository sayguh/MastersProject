%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function will calculate the Cumulant as defined by 
% equation 2 in the paper "Hierarchical Digital Modulation Classification Using Cumulants
% by Swami, Sadler
% Checked for proper operation with Octave Version 3.0.0
% Author	: Youssef Bagoulla
% Email		: sayguh@gmail.com
% Version	: 1.0
% Date		: 15 April 2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [C20, C21, C40, C41, C42] = Cumulant(y)



N = length(y);

C20 = 1/N * sum(y.^2);
C21 = 1/N * sum(abs(y).^2);
C40 = 1/N * sum(y.^4) - 3 * C20^2;
C41 = 1/N * sum(y.^3 .* conj(y)) - 3*C20*C21;
C42 = 1/N * sum(abs(y).^4) - abs(C20)^2 - 2*(C21^2);



