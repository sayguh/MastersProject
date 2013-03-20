function speedTest(numPointsUsed, dataSet)

fprintf("---- Speed Test ----\n");
fprintf("10dB SNR will be used\n");
fprintf("%i data points will be used\n", numPointsUsed);


tic 
CumulantClassifier(dataSet.QAMdata(1,1:numPointsUsed) + dataSet.Noise10dB(1,1:numPointsUsed));
speed = toc;

fprintf("Cumulants Classifier: %f ms\n", 1000*speed);


tic 
KsClassifier(dataSet.QAMdata(1,1:numPointsUsed) + dataSet.Noise10dB(1,1:numPointsUsed), 10)
speed = toc;

fprintf("KsClassifier Classifier: %f ms\n", 1000*speed);



tic 
DensityClassifier(dataSet.QAMdata(1,1:numPointsUsed) + dataSet.Noise10dB(1,1:numPointsUsed))
speed = toc;

fprintf("Density Classifier: %f ms\n", 1000*speed);


tic 
kMeansClassifier(dataSet.QAMdata(1,1:numPointsUsed) + dataSet.Noise10dB(1,1:numPointsUsed))
speed = toc;

fprintf("K-Means Classifier: %f ms\n", 1000*speed);





