function M = CumulantClassifier(scaledPoints)

% Here are the theoretical values for our classifier.
% M  |C40| C42
lookUpTable = [[2 2 -2]; [4 1 -1]; [16 0.68 -0.68]; [64 0.6191 -0.6191]];

% We compute the cumulants, note that C40 is NOT rotation in variant but |C40| is.
[C20, C21, C40, C41, C42] = Cumulant(scaledPoints);


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
