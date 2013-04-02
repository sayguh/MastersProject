function templates = generateTemplates(BlockSize, maxAvg)

load('testDataSet.mat')

Fc = 0;
Fs = 8192;
sampleType = 'C';

[Sxa AM_Ia] = mySxa(dataSet.AMdata, sampleType, Fc, Fs, BlockSize, maxAvg);
[Sxa SSB_Ia] = mySxa(dataSet.SSBdata, sampleType, Fc, Fs, BlockSize, maxAvg);
[Sxa FM_Ia] = mySxa(dataSet.FMdata, sampleType, Fc, Fs, BlockSize, maxAvg);
[Sxa BPSK_Ia] = mySxa(dataSet.BPSKdata, sampleType, Fc, Fs, BlockSize, maxAvg);
[Sxa QAM_Ia] = mySxa(dataSet.QAMdata, sampleType, Fc, Fs, BlockSize, maxAvg);
[Sxa QAM16_Ia] = mySxa(dataSet.QAM16data, sampleType, Fc, Fs, BlockSize, maxAvg);
[Sxa QAM64_Ia] = mySxa(dataSet.QAM64data, sampleType, Fc, Fs, BlockSize, maxAvg);


AM_Ia = AM_Ia / max(abs(AM_Ia));
SSB_Ia = SSB_Ia / max(abs(SSB_Ia));
FM_Ia = FM_Ia / max(abs(FM_Ia));
BPSK_Ia = BPSK_Ia / max(abs(BPSK_Ia));
QAM_Ia = QAM_Ia / max(abs(QAM_Ia));
QAM16_Ia = QAM16_Ia / max(abs(QAM16_Ia));
QAM64_Ia = QAM64_Ia / max(abs(QAM64_Ia));


templates = [AM_Ia(:) SSB_Ia(:) FM_Ia(:) BPSK_Ia(:) QAM_Ia(:) QAM16_Ia(:) QAM64_Ia(:)];

