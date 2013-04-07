function [M C40 C42] = CumulantClassifier(scaledPoints)

% Here are the theoretical values for our classifier.
% M  |C40| C42
% I'm making it so AM is -3, SSB is -2, FM is -1 
lookUpTable = [[-3 0.040723 0.040723]; [-2 0.079237 0]; [-1 0 -1]; [2 2 -2]; [4 1 -1]; [16 0.68 -0.68]; [64 0.6191 -0.6191]];

% We compute the cumulants, note that C40 is NOT rotation invariant but |C40| is.
[C20, C21, C40, C41, C42] = Cumulant(scaledPoints);

% Normalize by C21
C40 = C40/C21^2;
C41 = C41/C21^2;
C42 = C42/C21^2;

[row col] = size(lookUpTable);

% We are using |C40| as our classifier since it is theoretically rotation in variant.
% Compute the deltas between theory and output
deltaMatrix = lookUpTable(:, 2:3) - kron([abs(C40) C42], ones(row, 1));

% Find magnitude of our 2 dimentional delta vector for each M value
for i = 1:row
	normArray(i) = norm(deltaMatrix(i,:),2);
end

% Find the minimum error vector and use that to find M
[minDelta index] = min(normArray);

M = lookUpTable(index,1);
