function pointsMatrix = TestKSNumPoints(SNR, dataSet)


pointVector = [100 200 300 400 500 600 700 800 900 1000];
%pointVector = [100];
phaseOffset = 1;

%BPSKClassification = zeros(1,length(pointVector));
QAMClassification = zeros(1,length(pointVector));
QAM16Classification = zeros(1,length(pointVector));
QAM64Classification = zeros(1,length(pointVector));


if (SNR == 0)
	noiseMatrix = dataSet.Noise0dB;
elseif (SNR == 3)
	noiseMatrix = dataSet.Noise3dB;
elseif (SNR == 10)
	noiseMatrix = dataSet.Noise10dB;
elseif (SNR == 20)
	noiseMatrix = dataSet.Noise20dB;
elseif (SNR == 100)
	noiseMatrix = dataSet.Noise100dB;
end


for ii = 1: length(pointVector)
	fprintf("Number of Points: %i \n", pointVector(ii));
	fflush(1);

	for i = 1:25
		fprintf("Percent Complete: %i \n", 4*i);
		fflush(1);
%		BPSKClassification(ii) += ...
%		(KsClassifier(phaseOffset*dataSet.BPSKdata(i,1:pointVector(ii)) + noiseMatrix(i,1:pointVector(ii)), SNR) == 2);

		QAMClassification(ii) += ...
		(KsClassifier(phaseOffset*dataSet.QAMdata(i,1:pointVector(ii)) + noiseMatrix(i,1:pointVector(ii)), SNR) == 4);

		QAM16Classification(ii) += ...
		(KsClassifier(phaseOffset*dataSet.QAM16data(i,1:pointVector(ii)) + noiseMatrix(i,1:pointVector(ii)), SNR) == 16);

		QAM64Classification(ii) += ...
		(KsClassifier(phaseOffset*dataSet.QAM64data(i,1:pointVector(ii)) + noiseMatrix(i,1:pointVector(ii)), SNR) == 64);

	end
end

%pointsMatrix = [ BPSKClassification; QAMClassification; QAM16Classification; QAM64Classification];
pointsMatrix = [QAMClassification; QAM16Classification; QAM64Classification];
