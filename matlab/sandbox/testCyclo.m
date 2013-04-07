function M = testCyclo(input, templates, SNR, Fc, Fs, sampleType, BlockSize, maxAvg)

% The templates should be columns of ideal data to compare to
% Add noise to the signal to the desired SNR
noisySig = awgn(input, SNR, 'measured');

[Sxa Ia] = mySxa(noisySig, sampleType, Fc, Fs, BlockSize, maxAvg);

%Ia = Ia / max(abs(Ia)); % Scale to unity.

Ia = Ia(:); % Insure it's a Column Vector

numTemplates = columns(templates);

compareMatrix = kron(Ia, ones(1, numTemplates));

% I never scaled the data points, need to do that when implementing in C++
diffMatrix = (abs(compareMatrix) - abs(templates)).^2; % Subtract and square

diffVector = sum(diffMatrix);

[C M] = min(diffVector);
