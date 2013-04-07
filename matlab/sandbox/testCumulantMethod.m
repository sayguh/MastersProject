function [AMOut SSBOut FMOut BPSKOut QAMOut QAM16Out QAM64Out] = testCumulantMethod()

% Number of trials
numTrials = 100;
%snrArray = [-3 0 3 5 10 15];
snrArray = 10;
numPoints = 40000;
Fc = 2048;
Fs = 8192;


cumAMData = zeros(length(snrArray), 7);
cumSSBData = zeros(length(snrArray), 7);
cumFMData = zeros(length(snrArray), 7);
cumBPSKData = zeros(length(snrArray), 7);
cumQAMData = zeros(length(snrArray), 7);
cumQAM16Data = zeros(length(snrArray), 7);
cumQAM64Data = zeros(length(snrArray), 7);


load('testDataSet.mat');


% Testing Cumulant method.

for j = 1:length(snrArray)
  for i = 1:numTrials
    cumAMData(j, testCumulant(dataSet.AMdata(1:numPoints), snrArray(j), Fc, Fs)) += 1;
    cumSSBData(j, testCumulant(dataSet.SSBdata(1:numPoints), snrArray(j), Fc, Fs)) += 1;
    cumFMData(j, testCumulant(dataSet.FMdata(1:numPoints), snrArray(j), Fc, Fs)) += 1;
    cumBPSKData(j, testCumulant(dataSet.BPSKdata(1:numPoints), snrArray(j), Fc, Fs)) += 1;
    cumQAMData(j, testCumulant(dataSet.QAMdata(1:numPoints), snrArray(j), Fc, Fs)) += 1;
    cumQAM16Data(j, testCumulant(dataSet.QAM16data(1:numPoints), snrArray(j), Fc, Fs)) += 1;
    cumQAM64Data(j, testCumulant(dataSet.QAM64data(1:numPoints), snrArray(j), Fc, Fs)) += 1;
  end
end


AMOut = cumAMData;
SSBOut = cumSSBData; 
FMOut = cumFMData;
BPSKOut = cumBPSKData;
QAMOut =  cumQAMData;
QAM16Out = cumQAM16Data;
QAM64Out = cumQAM64Data;

printf('AM    &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \\hline \n', AMOut(1,1), AMOut(1,2), AMOut(1,3), AMOut(1,4), AMOut(1,5), AMOut(1,6), AMOut(1,7));
printf('SSB   &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \\hline \n', SSBOut(1,1), SSBOut(1,2), SSBOut(1,3), SSBOut(1,4), SSBOut(1,5), SSBOut(1,6), SSBOut(1,7));
printf('FM    &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \\hline \n', FMOut(1,1), FMOut(1,2), FMOut(1,3), FMOut(1,4), FMOut(1,5), FMOut(1,6), FMOut(1,7));
printf('BPSK  &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \\hline \n', BPSKOut(1,1), BPSKOut(1,2), BPSKOut(1,3), BPSKOut(1,4), BPSKOut(1,5), BPSKOut(1,6), BPSKOut(1,7));
printf('QAM   &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \\hline \n', QAMOut(1,1), QAMOut(1,2), QAMOut(1,3), QAMOut(1,4), QAMOut(1,5), QAMOut(1,6), QAMOut(1,7));
printf('QAM16 &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \\hline \n', QAM16Out(1,1), QAM16Out(1,2), QAM16Out(1,3), QAM16Out(1,4), QAM16Out(1,5), QAM16Out(1,6), QAM16Out(1,7));
printf('QAM64 &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \\hline \n', QAM64Out(1,1), QAM64Out(1,2), QAM64Out(1,3), QAM64Out(1,4), QAM64Out(1,5), QAM64Out(1,6), QAM64Out(1,7));

return;



printf('----- Cumulant Results -----\n');
printf('SNR   &\t -3 &\t 0 &\t 3 &\t 5 &\t 10 &\t 15\\\\ \\hline \\hline \n');
printf('AM    &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \n ', cumAMData(1,1), cumAMData(2,1), cumAMData(3,1), cumAMData(4,1), cumAMData(5,1), cumAMData(6,1));
printf('SSB   &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \n', cumSSBData(1,2), cumSSBData(2,2), cumSSBData(3,2), cumSSBData(4,2), cumSSBData(5,2), cumSSBData(6,2));
printf('FM    &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \n', cumFMData(1,3), cumFMData(2,3), cumFMData(3,3), cumFMData(4,3), cumFMData(5,3), cumFMData(6,3));
printf('BPSK  &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \n', cumBPSKData(1,4), cumBPSKData(2,4), cumBPSKData(3,4), cumBPSKData(4,4), cumBPSKData(5,4), cumBPSKData(6,4));
printf('QAM   &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \n', cumQAMData(1,5), cumQAMData(2,5), cumQAMData(3,5), cumQAMData(4,5), cumQAMData(5,5), cumQAMData(6,5));
printf('QAM16 &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \n', cumQAM16Data(1,6), cumQAM16Data(2,6), cumQAM16Data(3,6), cumQAM16Data(4,6), cumQAM16Data(5,6), cumQAM16Data(6,6));
printf('QAM64 &\t %i &\t %i &\t %i &\t %i &\t %i &\t %i \\\\ \\hline \n', cumQAM64Data(1,7), cumQAM64Data(2,7), cumQAM64Data(3,7), cumQAM64Data(4,7), cumQAM64Data(5,7), cumQAM64Data(6,7));


printf('----- Cumulant Results False Positive-----\n');
printf('SNR   &\t -3 &\t 0 &\t 3 &\t 5 &\t 10 &\t 15\\\\ \\hline \\hline \n');
printf('AM &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f \\\\ \\hline \n ', 
(cumSSBData(1,1) + cumFMData(1,1) + cumBPSKData(1,1) + cumQAMData(1,1) + cumQAM16Data(1,1) + cumQAM64Data(1,1))/7 , 
(cumSSBData(2,1) + cumFMData(2,1) + cumBPSKData(2,1) + cumQAMData(2,1) + cumQAM16Data(2,1) + cumQAM64Data(2,1))/7 , 
(cumSSBData(3,1) + cumFMData(3,1) + cumBPSKData(3,1) + cumQAMData(3,1) + cumQAM16Data(3,1) + cumQAM64Data(3,1))/7 , 
(cumSSBData(4,1) + cumFMData(4,1) + cumBPSKData(4,1) + cumQAMData(4,1) + cumQAM16Data(4,1) + cumQAM64Data(4,1))/7 , 
(cumSSBData(5,1) + cumFMData(5,1) + cumBPSKData(5,1) + cumQAMData(5,1) + cumQAM16Data(5,1) + cumQAM64Data(5,1))/7 ,
(cumSSBData(6,1) + cumFMData(6,1) + cumBPSKData(6,1) + cumQAMData(6,1) + cumQAM16Data(6,1) + cumQAM64Data(6,1))/7);

printf('SSB &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f \\\\ \\hline \n',
(cumAMData(1,2) + cumFMData(1,2) + cumBPSKData(1,2) + cumQAMData(1,2) + cumQAM16Data(1,2) + cumQAM64Data(1,2))/7 , 
(cumAMData(2,2) + cumFMData(2,2) + cumBPSKData(2,2) + cumQAMData(2,2) + cumQAM16Data(2,2) + cumQAM64Data(2,2))/7 , 
(cumAMData(3,2) + cumFMData(3,2) + cumBPSKData(3,2) + cumQAMData(3,2) + cumQAM16Data(3,2) + cumQAM64Data(3,2))/7 , 
(cumAMData(4,2) + cumFMData(4,2) + cumBPSKData(4,2) + cumQAMData(4,2) + cumQAM16Data(4,2) + cumQAM64Data(4,2))/7 , 
(cumAMData(5,2) + cumFMData(5,2) + cumBPSKData(5,2) + cumQAMData(5,2) + cumQAM16Data(5,2) + cumQAM64Data(5,2))/7 ,
(cumAMData(6,2) + cumFMData(6,2) + cumBPSKData(6,2) + cumQAMData(6,2) + cumQAM16Data(6,2) + cumQAM64Data(6,2))/7); 

printf('FM &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f  \\\\ \\hline \n', 
(cumSSBData(1,3) + cumAMData(1,3) + cumBPSKData(1,3) + cumQAMData(1,3) + cumQAM16Data(1,3) + cumQAM64Data(1,3))/7 , 
(cumSSBData(2,3) + cumAMData(2,3) + cumBPSKData(2,3) + cumQAMData(2,3) + cumQAM16Data(2,3) + cumQAM64Data(2,3))/7 , 
(cumSSBData(3,3) + cumAMData(3,3) + cumBPSKData(3,3) + cumQAMData(3,3) + cumQAM16Data(3,3) + cumQAM64Data(3,3))/7 , 
(cumSSBData(4,3) + cumAMData(4,3) + cumBPSKData(4,3) + cumQAMData(4,3) + cumQAM16Data(4,3) + cumQAM64Data(4,3))/7 , 
(cumSSBData(5,3) + cumAMData(5,3) + cumBPSKData(5,3) + cumQAMData(5,3) + cumQAM16Data(5,3) + cumQAM64Data(5,3))/7 , 
(cumSSBData(6,3) + cumAMData(6,3) + cumBPSKData(6,3) + cumQAMData(6,3) + cumQAM16Data(6,3) + cumQAM64Data(6,3))/7); 

printf('BPSK &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f \\\\ \\hline \n',
(cumSSBData(1,4) + cumFMData(1,4) + cumAMData(1,4) + cumQAMData(1,4) + cumQAM16Data(1,4) + cumQAM64Data(1,4))/7 , 
(cumSSBData(2,4) + cumFMData(2,4) + cumAMData(2,4) + cumQAMData(2,4) + cumQAM16Data(2,4) + cumQAM64Data(2,4))/7 , 
(cumSSBData(3,4) + cumFMData(3,4) + cumAMData(3,4) + cumQAMData(3,4) + cumQAM16Data(3,4) + cumQAM64Data(3,4))/7 , 
(cumSSBData(4,4) + cumFMData(4,4) + cumAMData(4,4) + cumQAMData(4,4) + cumQAM16Data(4,4) + cumQAM64Data(4,4))/7 , 
(cumSSBData(5,4) + cumFMData(5,4) + cumAMData(5,4) + cumQAMData(5,4) + cumQAM16Data(5,4) + cumQAM64Data(5,4))/7 , 
(cumSSBData(6,4) + cumFMData(6,4) + cumAMData(6,4) + cumQAMData(6,4) + cumQAM16Data(6,4) + cumQAM64Data(6,4))/7); 

printf('QAM &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f \\\\ \\hline \n', 
(cumSSBData(1,5) + cumFMData(1,5) + cumBPSKData(1,5) + cumAMData(1,5) + cumQAM16Data(1,5) + cumQAM64Data(1,5))/7 , 
(cumSSBData(2,5) + cumFMData(2,5) + cumBPSKData(2,5) + cumAMData(2,5) + cumQAM16Data(2,5) + cumQAM64Data(2,5))/7 , 
(cumSSBData(3,5) + cumFMData(3,5) + cumBPSKData(3,5) + cumAMData(3,5) + cumQAM16Data(3,5) + cumQAM64Data(3,5))/7 , 
(cumSSBData(4,5) + cumFMData(4,5) + cumBPSKData(4,5) + cumAMData(4,5) + cumQAM16Data(4,5) + cumQAM64Data(4,5))/7 , 
(cumSSBData(5,5) + cumFMData(5,5) + cumBPSKData(5,5) + cumAMData(5,5) + cumQAM16Data(5,5) + cumQAM64Data(5,5))/7 , 
(cumSSBData(6,5) + cumFMData(6,5) + cumBPSKData(6,5) + cumAMData(6,5) + cumQAM16Data(6,5) + cumQAM64Data(6,5))/7); 

printf('QAM16 &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f \\\\ \\hline \n',
(cumSSBData(1,6) + cumFMData(1,6) + cumBPSKData(1,6) + cumQAMData(1,6) + cumAMData(1,6) + cumQAM64Data(1,6))/7 , 
(cumSSBData(2,6) + cumFMData(2,6) + cumBPSKData(2,6) + cumQAMData(2,6) + cumAMData(2,6) + cumQAM64Data(2,6))/7 , 
(cumSSBData(3,6) + cumFMData(3,6) + cumBPSKData(3,6) + cumQAMData(3,6) + cumAMData(3,6) + cumQAM64Data(3,6))/7 , 
(cumSSBData(4,6) + cumFMData(4,6) + cumBPSKData(4,6) + cumQAMData(4,6) + cumAMData(4,6) + cumQAM64Data(4,6))/7 , 
(cumSSBData(5,6) + cumFMData(5,6) + cumBPSKData(5,6) + cumQAMData(5,6) + cumAMData(5,6) + cumQAM64Data(5,6))/7 ,
(cumSSBData(6,6) + cumFMData(6,6) + cumBPSKData(6,6) + cumQAMData(6,6) + cumAMData(6,6) + cumQAM64Data(6,6))/7); 

printf('QAM64 &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f &\t %3.1f \\\\ \\hline \n',
(cumSSBData(1,7) + cumFMData(1,7) + cumBPSKData(1,7) + cumQAMData(1,7) + cumQAM16Data(1,7) + cumAMData(1,7))/7 , 
(cumSSBData(2,7) + cumFMData(2,7) + cumBPSKData(2,7) + cumQAMData(2,7) + cumQAM16Data(2,7) + cumAMData(2,7))/7 , 
(cumSSBData(3,7) + cumFMData(3,7) + cumBPSKData(3,7) + cumQAMData(3,7) + cumQAM16Data(3,7) + cumAMData(3,7))/7 , 
(cumSSBData(4,7) + cumFMData(4,7) + cumBPSKData(4,7) + cumQAMData(4,7) + cumQAM16Data(4,7) + cumAMData(4,7))/7 , 
(cumSSBData(5,7) + cumFMData(5,7) + cumBPSKData(5,7) + cumQAMData(5,7) + cumQAM16Data(5,7) + cumAMData(5,7))/7 ,
(cumSSBData(6,7) + cumFMData(6,7) + cumBPSKData(6,7) + cumQAMData(6,7) + cumQAM16Data(6,7) + cumAMData(6,7))/7); 
