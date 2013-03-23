% Creates a data set so that I can use the same random data for each of the classifiers
% When the dataset is saved off, the file size is about 350MB so this takes a little while to run.


clear; close; clc;

% Defining the SNRs we plan on having in our system.
dataSet.SNRArray = [-3, 0, 3, 5, 10];

% Signal types will be:
% AM
% SSB AM
% FM
% BPSK
% QAM
% QAM-16
% QAM-64

fc = 2048; %Hz Center Freq
fs = 8192; %Hz Over sample
rb = 2048; %Hz symbol per cycle for digital mods and BW for AM mod.
T = 5; %s Five seconds worth of data
sampleType = 'C'; % Denotes we want complex samples not real ones.


printf('Creating AM Data Set\n');
fflush(stdout);
dataSet.AMdata = amData(fs, fc, rb, T, sampleType);

printf('Creating SSBAM Data Set\n');
fflush(stdout);
dataSet.SSBdata = ssbData(fs, fc, rb, T, sampleType);

printf('Creating FM Data Set\n');
fflush(stdout);
dataSet.FMdata = fmData(fs, fc, rb, T, sampleType);

printf('Creating BPSK Data Set\n');
fflush(stdout);
dataSet.BPSKdata = bpskData(fs, fc, rb, T, sampleType);

printf('Creating QAM Data Set\n');
fflush(stdout);
dataSet.QAMdata = qamData(fs, fc, rb, 4, T, sampleType);

printf('Creating QAM16 Data Set\n');
fflush(stdout);
dataSet.QAM16data = qamData(fs, fc, rb, 16, T, sampleType);

printf('Creating QAM64 Data Set\n');
fflush(stdout);
dataSet.QAM64data = qamData(fs, fc, rb, 64, T, sampleType);

printf('Saving Data Set\n');
fflush(stdout);
save('testDataSet.mat', 'dataSet');

