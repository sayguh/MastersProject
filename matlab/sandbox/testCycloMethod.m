function [AMOut SSBOut FMOut BPSKOut QAMOut QAM16Out QAM64Out] = testCycloMethod()
printf('Testing CycloStationary Method....this could be a while\n\n');
fflush(stdout);

% Number of trials
numTrials = 100;
snrArray = [-3 0 3 5 10 15];
%snrArray = 5;
Fc = 0;
Fs = 8192;
sampleType = 'C';

BlockSize = 128;
numAvg = 100;


cycloAMData = zeros(length(snrArray), 7);
cycloSSBData = zeros(length(snrArray), 7);
cycloFMData = zeros(length(snrArray), 7);
cycloBPSKData = zeros(length(snrArray), 7);
cycloQAMData = zeros(length(snrArray), 7);
cycloQAM16Data = zeros(length(snrArray), 7);
cycloQAM64Data = zeros(length(snrArray), 7);


printf('Loading test Data\n'); fflush(stdout);
load('testDataSet.mat');

printf('Generating templates\n'); fflush(stdout);
template = generateTemplates(BlockSize, numAvg);

% Testing Cumulant method.

for j = 1:length(snrArray)
  printf('\nTesting SNR: %i\n', snrArray(j))
  for i = 1:numTrials
    printf('Percent Done with current SNR: %i \n',i);
    fflush(stdout);
    cycloAMData(j, testCyclo(dataSet.AMdata, template, snrArray(j), Fc, Fs, sampleType, BlockSize, numAvg)) += 1;
    cycloSSBData(j, testCyclo(dataSet.SSBdata, template, snrArray(j), Fc, Fs, sampleType, BlockSize, numAvg)) += 1;
    cycloFMData(j, testCyclo(dataSet.FMdata, template, snrArray(j), Fc, Fs, sampleType, BlockSize, numAvg)) += 1;
    cycloBPSKData(j, testCyclo(dataSet.BPSKdata, template, snrArray(j), Fc, Fs, sampleType, BlockSize, numAvg)) += 1;
    cycloQAMData(j, testCyclo(dataSet.QAMdata, template, snrArray(j), Fc, Fs, sampleType, BlockSize, numAvg)) += 1;
    cycloQAM16Data(j, testCyclo(dataSet.QAM16data, template, snrArray(j), Fc, Fs, sampleType, BlockSize, numAvg)) += 1;
    cycloQAM64Data(j, testCyclo(dataSet.QAM64data, template, snrArray(j), Fc, Fs, sampleType, BlockSize, numAvg)) += 1;
  end
end


AMOut = cycloAMData;
SSBOut = cycloSSBData;
FMOut = cycloFMData;
BPSKOut = cycloBPSKData;
QAMOut =  cycloQAMData;
QAM16Out = cycloQAM16Data;
QAM64Out = cycloQAM64Data;

printf('AM    &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \\hline \n', AMOut(1,1), AMOut(1,2), AMOut(1,3), AMOut(1,4), AMOut(1,5), AMOut(1,6), AMOut(1,7));
printf('SSB   &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \\hline \n', SSBOut(1,1), SSBOut(1,2), SSBOut(1,3), SSBOut(1,4), SSBOut(1,5), SSBOut(1,6), SSBOut(1,7));
printf('FM    &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \\hline \n', FMOut(1,1), FMOut(1,2), FMOut(1,3), FMOut(1,4), FMOut(1,5), FMOut(1,6), FMOut(1,7));
printf('BPSK  &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \\hline \n', BPSKOut(1,1), BPSKOut(1,2), BPSKOut(1,3), BPSKOut(1,4), BPSKOut(1,5), BPSKOut(1,6), BPSKOut(1,7));
printf('QAM   &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \\hline \n', QAMOut(1,1), QAMOut(1,2), QAMOut(1,3), QAMOut(1,4), QAMOut(1,5), QAMOut(1,6), QAMOut(1,7));
printf('QAM16 &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \\hline \n', QAM16Out(1,1), QAM16Out(1,2), QAM16Out(1,3), QAM16Out(1,4), QAM16Out(1,5), QAM16Out(1,6), QAM16Out(1,7));
printf('QAM64 &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \\hline \n', QAM64Out(1,1), QAM64Out(1,2), QAM64Out(1,3), QAM64Out(1,4), QAM64Out(1,5), QAM64Out(1,6), QAM64Out(1,7));

%return;






printf('----- Cumulant Results -----\n');
printf('SNR   &\t -3 &\t 0 &\t 3 &\t 5 &\t 10 &\t 15\\\\ \\hline \\hline \n');
printf('AM    &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \n ', cycloAMData(1,1), cycloAMData(2,1), cycloAMData(3,1), cycloAMData(4,1), cycloAMData(5,1), cycloAMData(6,1));
printf('SSB   &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \n', cycloSSBData(1,2), cycloSSBData(2,2), cycloSSBData(3,2), cycloSSBData(4,2), cycloSSBData(5,2), cycloSSBData(6,2));
printf('FM    &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \n', cycloFMData(1,3), cycloFMData(2,3), cycloFMData(3,3), cycloFMData(4,3), cycloFMData(5,3), cycloFMData(6,3));
printf('BPSK  &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \n', cycloBPSKData(1,4), cycloBPSKData(2,4), cycloBPSKData(3,4), cycloBPSKData(4,4), cycloBPSKData(5,4), cycloBPSKData(6,4));
printf('QAM   &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \n', cycloQAMData(1,5), cycloQAMData(2,5), cycloQAMData(3,5), cycloQAMData(4,5), cycloQAMData(5,5), cycloQAMData(6,5));
printf('QAM16 &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \n', cycloQAM16Data(1,6), cycloQAM16Data(2,6), cycloQAM16Data(3,6), cycloQAM16Data(4,6), cycloQAM16Data(5,6), cycloQAM16Data(6,6));
printf('QAM64 &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \n', cycloQAM64Data(1,7), cycloQAM64Data(2,7), cycloQAM64Data(3,7), cycloQAM64Data(4,7), cycloQAM64Data(5,7), cycloQAM64Data(6,7));


printf('----- Cumulant Results False Positive-----\n');
printf('SNR   &\t -3 &\t 0 &\t 3 &\t 5 &\t 10 &\t 15\\\\ \\hline \\hline \n');
printf('AM &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f \\\\ \\hline \n ', 
(cycloSSBData(1,1) + cycloFMData(1,1) + cycloBPSKData(1,1) + cycloQAMData(1,1) + cycloQAM16Data(1,1) + cycloQAM64Data(1,1))/7 , 
(cycloSSBData(2,1) + cycloFMData(2,1) + cycloBPSKData(2,1) + cycloQAMData(2,1) + cycloQAM16Data(2,1) + cycloQAM64Data(2,1))/7 , 
(cycloSSBData(3,1) + cycloFMData(3,1) + cycloBPSKData(3,1) + cycloQAMData(3,1) + cycloQAM16Data(3,1) + cycloQAM64Data(3,1))/7 , 
(cycloSSBData(4,1) + cycloFMData(4,1) + cycloBPSKData(4,1) + cycloQAMData(4,1) + cycloQAM16Data(4,1) + cycloQAM64Data(4,1))/7 , 
(cycloSSBData(5,1) + cycloFMData(5,1) + cycloBPSKData(5,1) + cycloQAMData(5,1) + cycloQAM16Data(5,1) + cycloQAM64Data(5,1))/7 ,
(cycloSSBData(6,1) + cycloFMData(6,1) + cycloBPSKData(6,1) + cycloQAMData(6,1) + cycloQAM16Data(6,1) + cycloQAM64Data(6,1))/7);

printf('SSB &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f \\\\ \\hline \n',
(cycloAMData(1,2) + cycloFMData(1,2) + cycloBPSKData(1,2) + cycloQAMData(1,2) + cycloQAM16Data(1,2) + cycloQAM64Data(1,2))/7 , 
(cycloAMData(2,2) + cycloFMData(2,2) + cycloBPSKData(2,2) + cycloQAMData(2,2) + cycloQAM16Data(2,2) + cycloQAM64Data(2,2))/7 , 
(cycloAMData(3,2) + cycloFMData(3,2) + cycloBPSKData(3,2) + cycloQAMData(3,2) + cycloQAM16Data(3,2) + cycloQAM64Data(3,2))/7 , 
(cycloAMData(4,2) + cycloFMData(4,2) + cycloBPSKData(4,2) + cycloQAMData(4,2) + cycloQAM16Data(4,2) + cycloQAM64Data(4,2))/7 , 
(cycloAMData(5,2) + cycloFMData(5,2) + cycloBPSKData(5,2) + cycloQAMData(5,2) + cycloQAM16Data(5,2) + cycloQAM64Data(5,2))/7 ,
(cycloAMData(6,2) + cycloFMData(6,2) + cycloBPSKData(6,2) + cycloQAMData(6,2) + cycloQAM16Data(6,2) + cycloQAM64Data(6,2))/7); 

printf('FM &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f  \\\\ \\hline \n', 
(cycloSSBData(1,3) + cycloAMData(1,3) + cycloBPSKData(1,3) + cycloQAMData(1,3) + cycloQAM16Data(1,3) + cycloQAM64Data(1,3))/7 , 
(cycloSSBData(2,3) + cycloAMData(2,3) + cycloBPSKData(2,3) + cycloQAMData(2,3) + cycloQAM16Data(2,3) + cycloQAM64Data(2,3))/7 , 
(cycloSSBData(3,3) + cycloAMData(3,3) + cycloBPSKData(3,3) + cycloQAMData(3,3) + cycloQAM16Data(3,3) + cycloQAM64Data(3,3))/7 , 
(cycloSSBData(4,3) + cycloAMData(4,3) + cycloBPSKData(4,3) + cycloQAMData(4,3) + cycloQAM16Data(4,3) + cycloQAM64Data(4,3))/7 , 
(cycloSSBData(5,3) + cycloAMData(5,3) + cycloBPSKData(5,3) + cycloQAMData(5,3) + cycloQAM16Data(5,3) + cycloQAM64Data(5,3))/7 , 
(cycloSSBData(6,3) + cycloAMData(6,3) + cycloBPSKData(6,3) + cycloQAMData(6,3) + cycloQAM16Data(6,3) + cycloQAM64Data(6,3))/7); 

printf('BPSK &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f \\\\ \\hline \n',
(cycloSSBData(1,4) + cycloFMData(1,4) + cycloAMData(1,4) + cycloQAMData(1,4) + cycloQAM16Data(1,4) + cycloQAM64Data(1,4))/7 , 
(cycloSSBData(2,4) + cycloFMData(2,4) + cycloAMData(2,4) + cycloQAMData(2,4) + cycloQAM16Data(2,4) + cycloQAM64Data(2,4))/7 , 
(cycloSSBData(3,4) + cycloFMData(3,4) + cycloAMData(3,4) + cycloQAMData(3,4) + cycloQAM16Data(3,4) + cycloQAM64Data(3,4))/7 , 
(cycloSSBData(4,4) + cycloFMData(4,4) + cycloAMData(4,4) + cycloQAMData(4,4) + cycloQAM16Data(4,4) + cycloQAM64Data(4,4))/7 , 
(cycloSSBData(5,4) + cycloFMData(5,4) + cycloAMData(5,4) + cycloQAMData(5,4) + cycloQAM16Data(5,4) + cycloQAM64Data(5,4))/7 , 
(cycloSSBData(6,4) + cycloFMData(6,4) + cycloAMData(6,4) + cycloQAMData(6,4) + cycloQAM16Data(6,4) + cycloQAM64Data(6,4))/7); 

printf('QAM &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f \\\\ \\hline \n', 
(cycloSSBData(1,5) + cycloFMData(1,5) + cycloBPSKData(1,5) + cycloAMData(1,5) + cycloQAM16Data(1,5) + cycloQAM64Data(1,5))/7 , 
(cycloSSBData(2,5) + cycloFMData(2,5) + cycloBPSKData(2,5) + cycloAMData(2,5) + cycloQAM16Data(2,5) + cycloQAM64Data(2,5))/7 , 
(cycloSSBData(3,5) + cycloFMData(3,5) + cycloBPSKData(3,5) + cycloAMData(3,5) + cycloQAM16Data(3,5) + cycloQAM64Data(3,5))/7 , 
(cycloSSBData(4,5) + cycloFMData(4,5) + cycloBPSKData(4,5) + cycloAMData(4,5) + cycloQAM16Data(4,5) + cycloQAM64Data(4,5))/7 , 
(cycloSSBData(5,5) + cycloFMData(5,5) + cycloBPSKData(5,5) + cycloAMData(5,5) + cycloQAM16Data(5,5) + cycloQAM64Data(5,5))/7 , 
(cycloSSBData(6,5) + cycloFMData(6,5) + cycloBPSKData(6,5) + cycloAMData(6,5) + cycloQAM16Data(6,5) + cycloQAM64Data(6,5))/7); 

printf('QAM16 &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f \\\\ \\hline \n',
(cycloSSBData(1,6) + cycloFMData(1,6) + cycloBPSKData(1,6) + cycloQAMData(1,6) + cycloAMData(1,6) + cycloQAM64Data(1,6))/7 , 
(cycloSSBData(2,6) + cycloFMData(2,6) + cycloBPSKData(2,6) + cycloQAMData(2,6) + cycloAMData(2,6) + cycloQAM64Data(2,6))/7 , 
(cycloSSBData(3,6) + cycloFMData(3,6) + cycloBPSKData(3,6) + cycloQAMData(3,6) + cycloAMData(3,6) + cycloQAM64Data(3,6))/7 , 
(cycloSSBData(4,6) + cycloFMData(4,6) + cycloBPSKData(4,6) + cycloQAMData(4,6) + cycloAMData(4,6) + cycloQAM64Data(4,6))/7 , 
(cycloSSBData(5,6) + cycloFMData(5,6) + cycloBPSKData(5,6) + cycloQAMData(5,6) + cycloAMData(5,6) + cycloQAM64Data(5,6))/7 ,
(cycloSSBData(6,6) + cycloFMData(6,6) + cycloBPSKData(6,6) + cycloQAMData(6,6) + cycloAMData(6,6) + cycloQAM64Data(6,6))/7); 

printf('QAM64 &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f \\\\ \\hline \n',
(cycloSSBData(1,7) + cycloFMData(1,7) + cycloBPSKData(1,7) + cycloQAMData(1,7) + cycloQAM16Data(1,7) + cycloAMData(1,7))/7 , 
(cycloSSBData(2,7) + cycloFMData(2,7) + cycloBPSKData(2,7) + cycloQAMData(2,7) + cycloQAM16Data(2,7) + cycloAMData(2,7))/7 , 
(cycloSSBData(3,7) + cycloFMData(3,7) + cycloBPSKData(3,7) + cycloQAMData(3,7) + cycloQAM16Data(3,7) + cycloAMData(3,7))/7 , 
(cycloSSBData(4,7) + cycloFMData(4,7) + cycloBPSKData(4,7) + cycloQAMData(4,7) + cycloQAM16Data(4,7) + cycloAMData(4,7))/7 , 
(cycloSSBData(5,7) + cycloFMData(5,7) + cycloBPSKData(5,7) + cycloQAMData(5,7) + cycloQAM16Data(5,7) + cycloAMData(5,7))/7 ,
(cycloSSBData(6,7) + cycloFMData(6,7) + cycloBPSKData(6,7) + cycloQAMData(6,7) + cycloQAM16Data(6,7) + cycloAMData(6,7))/7); 
