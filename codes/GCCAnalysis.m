% Instantaneous Frequency
mFrequency15000 = 15000;
mFrequency16000 = 16000;
mFrequency17000 = 17000;
mFrequency18000 = 18000;
mFrequency21000 = 21000;
mFrequency22000 = 22000;
mFrequency24000 = 24000;

mFrequency16600 = 16600;
mFrequency18900 = 18900;
mFrequency21200 = 21200;
mFrequency23500 = 23500;


kSampleRate = 44100;
kSignalDuration = 0.045;
kSignalInsertStartSampleIndex = 10000;
mChirpStartFrequency = mFrequency18000;
mChirpStopFrequency = mFrequency15000;

% kSampleRate = 48000;
% kSignalDuration = 0.042;
% kSignalInsertStartSampleIndex = 10000 - 4096 + 1;
% mChirpStartFrequency = mFrequency18900;
% mChirpStopFrequency = mFrequency16600;

mAnchorSignal = generateSimulationAnchorSignal(kSampleRate, mChirpStartFrequency, mChirpStopFrequency, kSignalDuration);
% mAnchorSignal = readRealAnchorSignal();
mAnchorSignalCouts = length(mAnchorSignal);
kSignalInsertStopSampleIndex = kSignalInsertStartSampleIndex + mAnchorSignalCouts - 1;

cFrequencyShift = 0;
mTemplateChirpStartFrequency = mChirpStartFrequency + cFrequencyShift;
mTemplateChirpStopFrequency = mChirpStopFrequency + cFrequencyShift;
mTemplateSignal = generateTemplateSignal(kSampleRate, mTemplateChirpStartFrequency, mTemplateChirpStopFrequency, kSignalDuration);

% Analyse audio stream generation
cSampleCounts = 22050;
mAudioStream = generateAudioStream(kSampleRate, cSampleCounts, kSignalInsertStartSampleIndex, mAnchorSignal, 0);
t = zeros(401,11);
for i = -200:200
    
%     if i ~= 0
%         continue;
%     end
    
    cFrequencyShift = i;
    mTemplateChirpStartFrequency = mChirpStartFrequency + cFrequencyShift;
    mTemplateChirpStopFrequency = mChirpStopFrequency + cFrequencyShift;
    mTemplateSignal = generateTemplateSignal(kSampleRate, mTemplateChirpStartFrequency, mTemplateChirpStopFrequency, kSignalDuration);
    feature = analyzeAudioStream(mAudioStream, mTemplateSignal, kSignalInsertStartSampleIndex, mTemplateChirpStartFrequency, mTemplateChirpStopFrequency);
    t(i+201,1) = cFrequencyShift;
    t(i+201,2) = mTemplateChirpStartFrequency;
    t(i+201,3) = mTemplateChirpStopFrequency;
    t(i+201,4:11) = feature;
    
    fprintf("Iterator: %d\n", i);
    
end

plotStftAnalyzerPara1 = cell(2,1);
plotStftAnalyzerPara1{1, 1} = 1;
plotStftAnalyzerPara1{2, 1} = sprintf("Stft analyzer %d", kSignalInsertStartSampleIndex);
plotStftAnalyzerPara2 = cell(2,4);
plotStftAnalyzerPara2{1, 1} = mAudioStream;
plotStftAnalyzerPara2{1, 2} = kSampleRate;
plotStftAnalyzerPara2{2, 1} = 9814;
plotStftAnalyzerPara2{2, 2} = plotStftAnalyzerPara2{2, 1} + 2017 - 1;
plotStftAnalyzerPara2{2, 3} = mTemplateChirpStartFrequency;
plotStftAnalyzerPara2{2, 4} = mTemplateChirpStopFrequency;
plotStftAnalyzerPara3 = cell(3,1);
% plotStftAnalyzer(plotStftAnalyzerPara1, plotStftAnalyzerPara2, plotStftAnalyzerPara3)







