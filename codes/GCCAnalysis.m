kSampleRate = 44100;
kSignalDuration = 0.045;
kSignalInsertStartSampleIndex = 5000;

% Instantaneous Frequency
mFrequency15000 = 15000;
mFrequency16000 = 16000;
mFrequency17000 = 17000;
mFrequency18000 = 18000;
mFrequency21000 = 21000;
mFrequency22000 = 22000;
mFrequency24000 = 24000;

mChirpStartFrequency = mFrequency15000;
mChirpStopFrequency = mFrequency18000;

mAnchorSignal = generateAnchorSignal(kSampleRate, mChirpStartFrequency, mChirpStopFrequency, kSignalDuration);
mAnchorSignalCouts = length(mAnchorSignal);
kSignalInsertStopSampleIndex = kSignalInsertStartSampleIndex + mAnchorSignalCouts - 1;

mTemplateSignal = generateTemplateSignal(kSampleRate, mChirpStartFrequency, mChirpStopFrequency, kSignalDuration);

% Analyse audio stream generation
cSampleCounts = 10000;
mAudioStream = generateAudioStream(kSampleRate, cSampleCounts, kSignalInsertStartSampleIndex, mAnchorSignal, 0);

analyzeAudioStream(mAudioStream, mTemplateSignal, kSignalInsertStartSampleIndex);

plotStftAnalyzerPara1 = cell(2,1);
plotStftAnalyzerPara1{1, 1} = 1;
plotStftAnalyzerPara1{2, 1} = sprintf("Stft analyzer %d", kSignalInsertStartSampleIndex);
plotStftAnalyzerPara2 = cell(2,4);
plotStftAnalyzerPara2{1, 1} = mAudioStream;
plotStftAnalyzerPara2{1, 2} = kSampleRate;
plotStftAnalyzerPara2{2, 1} = kSignalInsertStartSampleIndex;
plotStftAnalyzerPara2{2, 2} = kSignalInsertStopSampleIndex;
plotStftAnalyzerPara2{2, 3} = mChirpStartFrequency;
plotStftAnalyzerPara2{2, 4} = mChirpStopFrequency;
plotStftAnalyzerPara3 = cell(3,1);
% plotStftAnalyzer(plotStftAnalyzerPara1, plotStftAnalyzerPara2, plotStftAnalyzerPara3)







