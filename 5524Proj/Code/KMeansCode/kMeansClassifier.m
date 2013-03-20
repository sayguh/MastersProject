function M = kMeansClassifier(scaledPoints, thresh)



if nargin == 1
	thresh = 0.1;
end

Marray = [2 4 16 64];

centers(1).array = [-1 1];  % BPSK is a special case and can be expressed simply as -1 1

% Each of the QAMs initial centers are calculated here
for i = 2:length(Marray)
	alphaRe = [-(2*sqrt(Marray(i))/2-1):2:-1 1:2:2*sqrt(Marray(i))/2-1];
	alphaIm = [-(2*sqrt(Marray(i))/2-1):2:-1 1:2:2*sqrt(Marray(i))/2-1];
	normFactor = 1 / sqrt(2/3 * (Marray(i)-1));

	centersMatrix = normFactor * (kron(alphaRe, ones(sqrt(Marray(i)), 1)) + j *kron(alphaIm', ones(1,sqrt(Marray(i)))));

	[row col] = size(centersMatrix);

	centers(i).array = reshape(centersMatrix,1,row*col);

end


%plot(real(scaledPoints), imag(scaledPoints),'o')

% Here we go through each Modulation type
for i = 1:length(Marray)
	% We try and fit the Modulation type to the data points and create a new converged Center list
	convergedCenter = kMeans(scaledPoints, centers(i).array, thresh);

	% Finally we compare the new centers to the old centers and get an average divergence per group point
	d(i) = mean(abs(centers(i).array - convergedCenter));
end

[value index] = min(d);

M = Marray(index);




