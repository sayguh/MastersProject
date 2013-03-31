function M = testCyclo(input, SNR, Fc, Fs)

% Add noise to the signal to the desired SNR
noisySig = awgn(input, SNR, 'measured');

[M C40 C42] = CycloClassifier(IQdata);

% Redistributing M so that:
% AM = 1
% SSB = 2
% FM = 3
% BPSK = 4
% QAM = 5
% 16QAM = 6
% 64QAM = 7

if M == -3
  M = 1;
elseif M == -2
  M = 2;
elseif M == -1
  M = 3;
elseif M == 2
  M = 4;
elseif M == 4
  M = 5;
elseif M == 16
  M = 6;
elseif M == 64
  M = 7;
end

