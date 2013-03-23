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
rs = 2048; %Hz symbol per cycle for digital mods
T = 5; %s Five seconds worth of data
sampleType = 'C'; % Denotes we want complex samples not real ones.

dataSet.AMdata = amData(fs, fc, T, sampleType);
dataSet.SSBdata = ssbData(fs, fc, T, sampleType);
dataSet.FMdata = fmData(fs, fc, T, sampleType);
dataSet.BPSKdata = bpskData(fs, fc, rb, T, sampleType);
dataSet.QAMdata = qamData(fs, fc, rb, 4, T, sampleType);
dataSet.QAM16data = qamData(fs, fc, rb, 16, T, sampleType);
dataSet.QAM64data = qamData(fs, fc, rb, 64, T, sampleType);


save('testDataSet.mat', 'dataSet');

