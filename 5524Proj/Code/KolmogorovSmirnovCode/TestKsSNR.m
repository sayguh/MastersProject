function snrMatrix = TestKsSNR(numPointsUsed, iterations, dataSet, phaseOffset)


%BPSKClassification = zeros(1,length(dataSet.SNRArray));
QAMClassification = zeros(1,length(dataSet.SNRArray));
QAM16Classification = zeros(1,length(dataSet.SNRArray));
QAM64Classification = zeros(1,length(dataSet.SNRArray));

% Create 4 arrays, one for each of the SNRs which contain the % correct classification for the KsClassifier
for i = 1:iterations

	printf("Percent Complete = %d \n", i);
	fflush(stdout);
%	BPSKClassification(1) = ...
%	BPSKClassification(1) + (KsClassifier(phaseOffset*dataSet.BPSKdata(i,1:numPointsUsed) + dataSet.Noise0dB(i,1:numPointsUsed), 0) == 2);

%	BPSKClassification(2) = ...
%	BPSKClassification(2) + (KsClassifier(phaseOffset*dataSet.BPSKdata(i,1:numPointsUsed) + dataSet.Noise3dB(i,1:numPointsUsed), 3) == 2);

%	BPSKClassification(3) = ...
%	BPSKClassification(3) + (KsClassifier(phaseOffset*dataSet.BPSKdata(i,1:numPointsUsed) + dataSet.Noise10dB(i,1:numPointsUsed), 10) == 2);

%	BPSKClassification(4) = ...
%	BPSKClassification(4) + (KsClassifier(phaseOffset*dataSet.BPSKdata(i,1:numPointsUsed) + dataSet.Noise20dB(i,1:numPointsUsed), 20) == 2);

%	BPSKClassification(5) = ...
%	BPSKClassification(5) + (KsClassifier(phaseOffset*dataSet.BPSKdata(i,1:numPointsUsed) + dataSet.Noise100dB(i,1:numPointsUsed), 100) == 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	QAMClassification(1) = ...
	QAMClassification(1) + (KsClassifier(phaseOffset*dataSet.QAMdata(i,1:numPointsUsed) + dataSet.Noise0dB(i,1:numPointsUsed), 0) == 4);

	QAMClassification(2) = ...
	QAMClassification(2) + (KsClassifier(phaseOffset*dataSet.QAMdata(i,1:numPointsUsed) + dataSet.Noise3dB(i,1:numPointsUsed), 3) == 4);

	QAMClassification(3) = ...
	QAMClassification(3) + (KsClassifier(phaseOffset*dataSet.QAMdata(i,1:numPointsUsed) + dataSet.Noise10dB(i,1:numPointsUsed), 10) == 4);

	QAMClassification(4) = ...
	QAMClassification(4) + (KsClassifier(phaseOffset*dataSet.QAMdata(i,1:numPointsUsed) + dataSet.Noise20dB(i,1:numPointsUsed), 20) == 4);

	QAMClassification(5) = ...
	QAMClassification(5) + (KsClassifier(phaseOffset*dataSet.QAMdata(i,1:numPointsUsed) + dataSet.Noise100dB(i,1:numPointsUsed), 100) == 4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	QAM16Classification(1) = ...
	QAM16Classification(1) + (KsClassifier(phaseOffset*dataSet.QAM16data(i,1:numPointsUsed) + dataSet.Noise0dB(i,1:numPointsUsed), 0) == 16);

	QAM16Classification(2) = ...
	QAM16Classification(2) + (KsClassifier(phaseOffset*dataSet.QAM16data(i,1:numPointsUsed) + dataSet.Noise3dB(i,1:numPointsUsed), 3) == 16);

	QAM16Classification(3) = ...
	QAM16Classification(3) + (KsClassifier(phaseOffset*dataSet.QAM16data(i,1:numPointsUsed) + dataSet.Noise10dB(i,1:numPointsUsed), 10) == 16);

	QAM16Classification(4) = ...
	QAM16Classification(4) + (KsClassifier(phaseOffset*dataSet.QAM16data(i,1:numPointsUsed) + dataSet.Noise20dB(i,1:numPointsUsed), 20) == 16);

	QAM16Classification(5) = ...
	QAM16Classification(5) + (KsClassifier(phaseOffset*dataSet.QAM16data(i,1:numPointsUsed) + dataSet.Noise100dB(i,1:numPointsUsed), 100) == 16);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	QAM64Classification(1) = ...
	QAM64Classification(1) + (KsClassifier(phaseOffset*dataSet.QAM64data(i,1:numPointsUsed) + dataSet.Noise0dB(i,1:numPointsUsed), 0) == 64);

	QAM64Classification(2) = ...
	QAM64Classification(2) + (KsClassifier(phaseOffset*dataSet.QAM64data(i,1:numPointsUsed) + dataSet.Noise3dB(i,1:numPointsUsed), 3) == 64);

	QAM64Classification(3) = ...
	QAM64Classification(3) + (KsClassifier(phaseOffset*dataSet.QAM64data(i,1:numPointsUsed) + dataSet.Noise10dB(i,1:numPointsUsed), 10) == 64);

	QAM64Classification(4) = ...
	QAM64Classification(4) + (KsClassifier(phaseOffset*dataSet.QAM64data(i,1:numPointsUsed) + dataSet.Noise20dB(i,1:numPointsUsed), 20) == 64);

	QAM64Classification(5) = ...
	QAM64Classification(5) + (KsClassifier(phaseOffset*dataSet.QAM64data(i,1:numPointsUsed) + dataSet.Noise100dB(i,1:numPointsUsed), 100) == 64);
end

%snrMatrix = [ BPSKClassification; QAMClassification; QAM16Classification; QAM64Classification];
snrMatrix = [ QAMClassification; QAM16Classification; QAM64Classification];
