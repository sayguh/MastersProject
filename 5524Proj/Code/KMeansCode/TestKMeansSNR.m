function snrMatrix = TestKMeansSNR(numPointsUsed, dataSet, phaseOffset)


BPSKClassification = zeros(1,length(dataSet.SNRArray));
QAMClassification = zeros(1,length(dataSet.SNRArray));
QAM16Classification = zeros(1,length(dataSet.SNRArray));
QAM64Classification = zeros(1,length(dataSet.SNRArray));

% Create 4 arrays, one for each of the SNRs which contain the % correct classification for the kMeansClassifier
for i = 1:100


	printf('Percent Complete: %d \n', i)
	fflush(stdout);

	BPSKClassification(1) = ...
	BPSKClassification(1) + (kMeansClassifier(phaseOffset*dataSet.BPSKdata(i,1:numPointsUsed) + dataSet.Noise0dB(i,1:numPointsUsed)) == 2);

	BPSKClassification(2) = ...
	BPSKClassification(2) + (kMeansClassifier(phaseOffset*dataSet.BPSKdata(i,1:numPointsUsed) + dataSet.Noise3dB(i,1:numPointsUsed)) == 2);

	BPSKClassification(3) = ...
	BPSKClassification(3) + (kMeansClassifier(phaseOffset*dataSet.BPSKdata(i,1:numPointsUsed) + dataSet.Noise10dB(i,1:numPointsUsed)) == 2);

	BPSKClassification(4) = ...
	BPSKClassification(4) + (kMeansClassifier(phaseOffset*dataSet.BPSKdata(i,1:numPointsUsed) + dataSet.Noise20dB(i,1:numPointsUsed)) == 2);

	BPSKClassification(5) = ...
	BPSKClassification(5) + (kMeansClassifier(phaseOffset*dataSet.BPSKdata(i,1:numPointsUsed) + dataSet.Noise100dB(i,1:numPointsUsed)) == 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	QAMClassification(1) = ...
	QAMClassification(1) + (kMeansClassifier(phaseOffset*dataSet.QAMdata(i,1:numPointsUsed) + dataSet.Noise0dB(i,1:numPointsUsed)) == 4);

	QAMClassification(2) = ...
	QAMClassification(2) + (kMeansClassifier(phaseOffset*dataSet.QAMdata(i,1:numPointsUsed) + dataSet.Noise3dB(i,1:numPointsUsed)) == 4);

	QAMClassification(3) = ...
	QAMClassification(3) + (kMeansClassifier(phaseOffset*dataSet.QAMdata(i,1:numPointsUsed) + dataSet.Noise10dB(i,1:numPointsUsed)) == 4);

	QAMClassification(4) = ...
	QAMClassification(4) + (kMeansClassifier(phaseOffset*dataSet.QAMdata(i,1:numPointsUsed) + dataSet.Noise20dB(i,1:numPointsUsed)) == 4);

	QAMClassification(5) = ...
	QAMClassification(5) + (kMeansClassifier(phaseOffset*dataSet.QAMdata(i,1:numPointsUsed) + dataSet.Noise100dB(i,1:numPointsUsed)) == 4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	QAM16Classification(1) = ...
	QAM16Classification(1) + (kMeansClassifier(phaseOffset*dataSet.QAM16data(i,1:numPointsUsed) + dataSet.Noise0dB(i,1:numPointsUsed)) == 16);

	QAM16Classification(2) = ...
	QAM16Classification(2) + (kMeansClassifier(phaseOffset*dataSet.QAM16data(i,1:numPointsUsed) + dataSet.Noise3dB(i,1:numPointsUsed)) == 16);

	QAM16Classification(3) = ...
	QAM16Classification(3) + (kMeansClassifier(phaseOffset*dataSet.QAM16data(i,1:numPointsUsed) + dataSet.Noise10dB(i,1:numPointsUsed)) == 16);

	QAM16Classification(4) = ...
	QAM16Classification(4) + (kMeansClassifier(phaseOffset*dataSet.QAM16data(i,1:numPointsUsed) + dataSet.Noise20dB(i,1:numPointsUsed)) == 16);

	QAM16Classification(5) = ...
	QAM16Classification(5) + (kMeansClassifier(phaseOffset*dataSet.QAM16data(i,1:numPointsUsed) + dataSet.Noise100dB(i,1:numPointsUsed)) == 16);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	QAM64Classification(1) = ...
	QAM64Classification(1) + (kMeansClassifier(phaseOffset*dataSet.QAM64data(i,1:numPointsUsed) + dataSet.Noise0dB(i,1:numPointsUsed)) == 64);

	QAM64Classification(2) = ...
	QAM64Classification(2) + (kMeansClassifier(phaseOffset*dataSet.QAM64data(i,1:numPointsUsed) + dataSet.Noise3dB(i,1:numPointsUsed)) == 64);

	QAM64Classification(3) = ...
	QAM64Classification(3) + (kMeansClassifier(phaseOffset*dataSet.QAM64data(i,1:numPointsUsed) + dataSet.Noise10dB(i,1:numPointsUsed)) == 64);

	QAM64Classification(4) = ...
	QAM64Classification(4) + (kMeansClassifier(phaseOffset*dataSet.QAM64data(i,1:numPointsUsed) + dataSet.Noise20dB(i,1:numPointsUsed)) == 64);

	QAM64Classification(5) = ...
	QAM64Classification(5) + (kMeansClassifier(phaseOffset*dataSet.QAM64data(i,1:numPointsUsed) + dataSet.Noise100dB(i,1:numPointsUsed)) == 64);
end

snrMatrix = [ BPSKClassification; QAMClassification; QAM16Classification; QAM64Classification];
