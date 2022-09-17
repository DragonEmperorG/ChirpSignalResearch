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


kSampleRate = 48000;
kSignalDuration = 0.042;

mAnchorSignal = readRealAnchorSignal();
mAnchorSignalCouts = length(mAnchorSignal);
kSignalInsertStartSampleIndex = 10000 - 4096 + 1;
kSignalInsertStopSampleIndex = kSignalInsertStartSampleIndex + mAnchorSignalCouts - 1;

% Analyse audio stream generation
cSampleCounts = 22050;
mAudioStream = generateAudioStream(kSampleRate, cSampleCounts, kSignalInsertStartSampleIndex, mAnchorSignal, 0);
t = zeros(401,11);
% rTemplateChirpStartFrequency = mFrequency18900;
% rTemplateChirpStopFrequency = mFrequency16600;

rTemplateChirpStartFrequency = 18814;
rTemplateChirpStopFrequency = 16531;

% for i = -200:200
%    
% % for i = -2:2
% %     if i ~= 0
% %         continue;
% %     end
%     
%     cFrequencyShift = i;
%     mTemplateChirpStartFrequency = rTemplateChirpStartFrequency + cFrequencyShift;
%     mTemplateChirpStopFrequency = rTemplateChirpStopFrequency + cFrequencyShift;
%     mTemplateSignal = generateTemplateSignal(kSampleRate, mTemplateChirpStartFrequency, mTemplateChirpStopFrequency, kSignalDuration);
%     feature = analyzeAudioStream(0, mAudioStream, mTemplateSignal, kSignalInsertStartSampleIndex, mTemplateChirpStartFrequency, mTemplateChirpStopFrequency);
%     t(i+201,1) = cFrequencyShift;
%     t(i+201,2) = mTemplateChirpStartFrequency;
%     t(i+201,3) = mTemplateChirpStopFrequency;
%     t(i+201,4:11) = feature;
%     
%     fprintf("Iterator: %d\n", i);
%     
% end

plotStftAnalyzerPara1 = cell(2,1);
plotStftAnalyzerPara1{1, 1} = 1;
plotStftAnalyzerPara1{2, 1} = sprintf("Stft analyzer %d", kSignalInsertStartSampleIndex);
plotStftAnalyzerPara2 = cell(2,4);
plotStftAnalyzerPara2{1, 1} = mAudioStream;
plotStftAnalyzerPara2{1, 2} = kSampleRate;
plotStftAnalyzerPara2{2, 1} = 9877;
plotStftAnalyzerPara2{2, 2} = plotStftAnalyzerPara2{2, 1} + 2017 - 1;
plotStftAnalyzerPara2{2, 3} = 18814;
plotStftAnalyzerPara2{2, 4} = 16531;
plotStftAnalyzerPara3 = cell(3,1);
plotStftAnalyzer(plotStftAnalyzerPara1, plotStftAnalyzerPara2, plotStftAnalyzerPara3)







