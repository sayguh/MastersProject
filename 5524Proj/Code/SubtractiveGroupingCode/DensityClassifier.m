% Modulation Classification of MQAM Signals from Their Constellation 
% Using Clustering 

% Specifcally this is their subtractive clustering implementation

function M = DensityClassifier(scaledPoints)

ra = 0.2;
rb = 2*ra;

epHigh = 0.5;
epLow = 0.32;


Xi = zeros(1, 2*length(scaledPoints));

% Combine the real and imaginary points (keep in mind this only works for MQAM and not BPSK.  Although it could work if you assume M = 3 for BPSK since there should be 3 clusters.

Xi(1:2:end) = real(scaledPoints);
Xi(2:2:end) = imag(scaledPoints);

% Scale Xi so that each point is equal to 1 or less.
Xi = Xi/max(abs(Xi));

% Find the initial densities
Di = DensityPotential(Xi,ra);

% Initialize M.
confirmedCenters = [];

% Dcl (The first max density point) is used in our stopping criteria
[Dcl index] = max(Di);

% Xcl is the first cluster center
Xcl = Xi(index);

confirmedCenters = [confirmedCenters Xcl];

% Now we 'remove' the cluster center from the density map
Di = Di - Dcl * exp(- abs(Xi - Xcl).^2 / (rb/2)^2);

breakPoint = length(Di);
breakTracker = 0;
while(1)
	if (breakTracker++ > breakPoint)
		fprintf("Looks like I got stuck in an infinite loop.  Leaving.  \n");
		break;
	end

	% Find the next cluster center and matching density
	[Dck index] = max(Di);
	Xck = Xi(index);

	% Stopping criterion

	% a)
	if (Dck > epHigh * Dcl)
		% Consider Xck a cluster and keep going
		confirmedCenters = [confirmedCenters Xck];

		% 'Remove' this center from the density map
		Di = Di - Dck * exp(- abs(Xi - Xck).^2 / (rb/2)^2);

		continue;
	end

	% b)
	if (Dck < epLow * Dcl)
		% Do not consider Xck as a cluster center and stop
		break;
	end

	% c)
	if ( (epLow * Dcl < Dck) & (Dck < epHigh * Dcl) )
		% Dfine dmin as min between Xck and determined cluster centers
		dmin = min(abs(Xck - confirmedCenters));
		
		% d)
		if (dmin / ra + Dck / abs(Xck) >= 1)
			confirmedCenters = [confirmedCenters Xck];
			
			% 'Remove' this center from the density map
			Di = Di - Dck * exp(- abs(Xi - Xck).^2 / (rb/2)^2);

			continue;
		else
			% The english isn't great in the paper but it sounds like I need to zero out this particular Density point and repeat
			% the steps a - d above.
			
			Di(index) = 0;
			continue;
		end
	end
end

% The only possible outcomes we'll accept are 3 (for BPSK), 2 (QAM), 4 (16-QAM), 8 (64-QAM) so M is whichever we're closest to.

options = [3, 2, 4, 8];
matchingMs = [2, 4, 16, 64];

%fprintf("Done running Density Classifier, found %f Centers\n", length(confirmedCenters));
%fflush(stdout);

[value index] = min(abs(options - length(confirmedCenters)));

M = matchingMs(index);

%fprintf("Done running Density Classifier, Returning %f \n\n", M);
%fflush(stdout);



