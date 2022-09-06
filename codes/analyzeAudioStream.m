function [outputArg1] = analyzeAudioStream(audioStream, templateSignal, mChirpInsertStartTimeindex)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

% GCC Analysis Window
audioStreamCounts = length(audioStream);
mFftLength = length(templateSignal);
mHalfFftLength = mFftLength * 0.5;

mAudioStreamGccWindowStartIndexArrayCounts = audioStreamCounts - mFftLength + 1;
mGccAnalysisValues = zeros(mAudioStreamGccWindowStartIndexArrayCounts, 3);
for i = 1 : mAudioStreamGccWindowStartIndexArrayCounts
    tAudioStreamGccWindowStartIndex = i;
    tAudioStreamGccWindow = audioStream(tAudioStreamGccWindowStartIndex:(tAudioStreamGccWindowStartIndex + mFftLength - 1));
    tGccSimilarityTimeDomain = corssCorrelation(tAudioStreamGccWindow, templateSignal);
    
    mGccSimilarityTimeDomainAbs = abs(tGccSimilarityTimeDomain);    
    [mMaxVal, mMaxIndex] = max(mGccSimilarityTimeDomainAbs);
    
    gccDetectorGlobalTimeindex = tAudioStreamGccWindowStartIndex + (mMaxIndex - 1);
    gccDetectorTimeindexDiff = gccDetectorGlobalTimeindex - mChirpInsertStartTimeindex;
    
%     if mAudioStreamGccWindowStartIndex == 1983 || mAudioStreamGccWindowStartIndex == 1984
%         plotStftAnalyzerPara1{2, 1} = sprintf("Stft analyzer %d", mAudioStreamGccWindowStartIndex);
%         plotStftAnalyzerPara3{1, 1} = [gccDetectorGlobalTimeindex];
%         plotStftAnalyzer(plotStftAnalyzerPara1, plotStftAnalyzerPara2, plotStftAnalyzerPara3);
%     end
    
    mGccAnalysisValues(i, 1) = tAudioStreamGccWindowStartIndex;
    mGccAnalysisValues(i, 2) = tAudioStreamGccWindowStartIndex + mHalfFftLength - 1;
    mGccAnalysisValues(i, 3) = mMaxIndex;
    mGccAnalysisValues(i, 4) = gccDetectorGlobalTimeindex;
    mGccAnalysisValues(i, 5) = gccDetectorTimeindexDiff;
    mGccAnalysisValues(i, 6) = mMaxVal;
end

% 理想信号互相关特征
% 从数据流包含第1个信号样本，互相关算法就可以探测到信号变化，在包含3个样本的时候可以探测到信号真值位置
% 从包含28个样本的时候可以收敛固定信号真值位置，这是互相关的第一个特征，
% 特征1：数据流滑窗包含完整信号头部的互相关结果最大值对应的时延索引会收敛到信号真值位置；
% 特征2：当滑窗刚滑动到不包含信号第一个采样点时，时延索引会发生突变；
% 特征3：突变后的索引值会收敛到信号真值加滑窗大小的位置；
% 特征4：随着滑窗包含的信号完整度越高，互相关结果最大值也逐渐增大，在包含完整信号的时候达到最大，并保持该最大值，直至信号变为不完整；
figureName = sprintf('Analyse for GCC Window and Chirp %d Hz to %d Hz Relative Relation', 0, 0);
figure('Name', figureName);
subplot(2,1,1);
plot(mGccAnalysisValues(:, 1), mGccAnalysisValues(:, 4), 'Marker', 'o');
hold on;
plot(mGccAnalysisValues(:, 1), mGccAnalysisValues(:, 3), 'Marker', 'd');
hold off;
subplot(2,1,2);
plot(mGccAnalysisValues(:, 1), mGccAnalysisValues(:, 6), 'Marker', 'o');


outputArg1 = inputArg1;
end

