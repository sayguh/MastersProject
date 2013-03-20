function convergedCenter = kMeans(scaledPoints, initialCenters, thresh)

N = length(initialCenters);

while(1)
	% For each initial center
	for i = 1:N
		% Initialize the pointCount and point sum to zero.
		centers(i).pointCount = 0;
		centers(i).pointSum = 0;
	end
	
	% Initialize the delta between previous and current iterations
	delta = 0;

	N = length(scaledPoints);

	% For each of the points in the input vector
	for i = 1:N
		% Find the nearest neighbor
		[center index] = NearestNeighbor(scaledPoints(i), initialCenters);
		% Increment the nearest neighbors point count and add that point to the total point sum
		centers(index).pointCount ++;
		centers(index).pointSum += scaledPoints(i);


% Note to self, looks like the index and point that's being returned is wrong, a problem my lie in NearestNeighbor.m
		%initCent = initialCenters
		%ind = index
		%testCenter = center
		%testPoint = scaledPoints(i)
		%printf("\n")
	
	end

	% Now for each of the centers, we compute the new center
	N = length(initialCenters);
	for i = 1:N
		
		% Sometimes no points are mapped to a center.  We should only update if there are new points to avoid / by 0.
		if centers(i).pointCount > 0;
			centers(i).center = centers(i).pointSum / centers(i).pointCount;
			delta += abs(centers(i).center - initialCenters(i));
			initialCenters(i) = centers(i).center;
		end
	end	

	if delta < thresh
		break;
	end
end

convergedCenter = initialCenters;
