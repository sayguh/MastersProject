% Creates a data set so that I can use the same random data for each of the classifiers
% When the dataset is saved off, the file size is about 350MB so this takes a little while to run.

clear; close; clc;

% Defining the SNRs we plan on having in our system.
dataSet.SNRArray = [100, 20, 10, 3 0];

% Defining the Phase rotation constants we'll use in our system
dataSet.PhaseArray = [0, pi()/8, 2*pi()/8, 3*pi()/8, 4*pi()/8];

% Defining the differeny M-Ary modulations used (BPSK, QAM, 16-QAM & 64-QAM)
dataSet.ModMArray = [2, 4, 16, 64];

% Each modulation will have 100 data sets consisting of 10,000 data points each
% Each SNR will also have 100 data sets consisting of 10,000 points

for i = 1:100

	dataSet.BPSKdata(i,:) = QamSim(10000, 2, 'IDEAL');
	dataSet.QAMdata(i,:) = QamSim(10000, 4, 'IDEAL');
	dataSet.QAM16data(i,:) = QamSim(10000, 16, 'IDEAL');
	dataSet.QAM64data(i,:) = QamSim(10000, 64, 'IDEAL');

	dataSet.Noise0dB(i,:) = scaledNoise(10000,0);
	dataSet.Noise3dB(i,:) = scaledNoise(10000,3);
	dataSet.Noise10dB(i,:) = scaledNoise(10000,10);
	dataSet.Noise20dB(i,:) = scaledNoise(10000,20);
	dataSet.Noise100dB(i,:) = scaledNoise(10000,100);
end

save('testDataSet.mat', 'dataSet');
