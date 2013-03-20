% Modulation Classification of MQAM Signals from Their Constellation 
% Using Clustering 


function D = DensityPotential(scaledPoints, ra)


N = length(scaledPoints);

D = zeros(1,N);

for i = 1:N
	for j = 1:N
		num = -abs(scaledPoints(i) - scaledPoints(j))^2;
		D(i) += exp(num/(ra/2)^2);
	end
end
