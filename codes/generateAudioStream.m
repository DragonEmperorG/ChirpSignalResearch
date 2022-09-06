function [rAudioStream] = generateAudioStream(sampleRate, sampleCounts, insertIndex, anchorSignal, plotAudioStream)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
mAudioStreamCounts = sampleCounts;
mAudioStream = zeros(mAudioStreamCounts, 1);

anchorSignalCounts = length(anchorSignal);
mChirpInsertStartTimeindex = insertIndex;
mChirpInsertStopTimeindex = mChirpInsertStartTimeindex + anchorSignalCounts - 1;
mAudioStream(mChirpInsertStartTimeindex:mChirpInsertStopTimeindex) = anchorSignal;

if plotAudioStream == 1
    % Time Resolution in s
    mTimeResolution = 1 / sampleRate;
    mHalfTimeResolution = mTimeResolution * 0.5;
    mAudioStreamSampleAxis = (0 : (mAudioStreamCounts-1))';
    mAudioStreamTimeAxis = mAudioStreamSampleAxis * mTimeResolution + mHalfTimeResolution;
    figure('Name','Analyse audio stream');
    subplot(2,1,1);
    plot(mAudioStreamSampleAxis, mAudioStream, '-x');    
    subplot(2,1,2);
    plot(mAudioStreamTimeAxis, mAudioStream, '-x');
end


rAudioStream = mAudioStream;
end

