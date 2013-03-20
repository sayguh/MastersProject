function M = KsClassifier(scaledPoints, SNR)

z = zeros(1, 2 * length(scaledPoints));

% Due to symatry, the real and imaginary points can both be used here as data points for the the CDF
z(1:2:end) = real(scaledPoints);
z(2:2:end) = imag(scaledPoints);


N = length(z);
Marray = [4 16 64];
figNum = 0;

% Create the empirical CDF
for i = 1:N
	empir(i) = empirCDF(z(i), z);
end


%figNum = figNum + 1;
%figure(figNum);	
%plot(z, empir,'o');
%title('Empirical CDF');


% Now we must create the expected CDF for each QAM.
for ii = 1:length(Marray)

	for i = 1:N
		qamDist(i) = qamCDF(Marray(ii),z(i), SNR);
    	end

%	figNum = figNum + 1;
%	figure(figNum);	
%	plot(z, qamDist, 'o');

D(ii) = max(abs(qamDist - empir));

end

%    fprintf("For test M = %f, SNR = %d, MaxD = %f, MinD = %f \n", Marray(ii), SNR, max(D), min(D));

[value index] = min(D);

M = Marray(index);
