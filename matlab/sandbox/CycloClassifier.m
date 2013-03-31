function [M] = CycloClassifier(scaledPoints)

% We'll just use complex data
sampleType = 'C';
BlockSize = 1024;
BlockSize = 500;


[Sxa Ia] = mySxa(scaledPoints, sampleType, BlockSize, BlockSize);


Cth = max(Ia) / sqrt(sum(Ia.^2)/length(Ia));


