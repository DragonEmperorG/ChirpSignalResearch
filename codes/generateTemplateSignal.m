function [rAnchorSignal] = generateTemplateSignal(sampleRate, startFrequency, stopFrequency, signalDuration)
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
% Sample Rate in Hz
mSampleRate = sampleRate;
% Time Resolution in s
mTimeResolution = 1 / mSampleRate;
% Chirp Signal Duration in ms
mChirpLength = signalDuration;
% Chirp Signal Time Axis in s
% 由于采样点个数根据采样间隔项下取整，所以信号的持续时间比设计的要短（误差小于一个采样间隔）
mChirpSampleLength = floor(mChirpLength / mTimeResolution);
mChirpSampleCounts = mChirpSampleLength + 1;

% 采用冒号运算符计算时间轴和采用采样时间间隔计算时间轴在数值计算结果上存在差异
% mChirpTimeAxis = (0:mTimeResolution:mChirpLength)';
mChirpTimeAxis = (0 : mChirpSampleLength)' * mTimeResolution;

mFrequencyDividedByTimeRatio = (stopFrequency - startFrequency) * (mChirpLength ^ (-1));

% Chirp Generation
mChirpStartFrequency = startFrequency;
mChirpStopFrequency = startFrequency + mFrequencyDividedByTimeRatio * mChirpTimeAxis(end);
mChirpSignalValue = chirp(mChirpTimeAxis, mChirpStartFrequency, mChirpTimeAxis(end), mChirpStopFrequency);

% Window Size
mWindowSampleCounts = 2^ceil(log2(mChirpSampleLength));

% Analyse chirp templete
mChirpTempleteCounts = mWindowSampleCounts;
mChirpTemplete = zeros(mChirpTempleteCounts, 1);
mChirpTemplete(1:(mChirpSampleCounts)) = mChirpSignalValue;

mChirpTempleteTimeAxis = (0 : (mChirpTempleteCounts-1))' * mTimeResolution;
mChirpStartFrequency = startFrequency;
mChirpStopFrequency = startFrequency + mFrequencyDividedByTimeRatio * mChirpTempleteTimeAxis(end);
mChirpTemplete = chirp(mChirpTempleteTimeAxis, mChirpStartFrequency, mChirpTempleteTimeAxis(end), mChirpStopFrequency);

% mChirpTempleteTimeAxis = (0 : (mChirpTempleteCounts-1))' * mTimeResolution;
% mChirpStopFrequency = stopFrequency;
% mChirpStartFrequency = stopFrequency - mFrequencyDividedByTimeRatio * mChirpTempleteTimeAxis(end);
% mChirpTemplete = chirp(mChirpTempleteTimeAxis, mChirpStartFrequency, mChirpTempleteTimeAxis(end), mChirpStopFrequency);


% if plotAudioStream == 1
%     % Time Resolution in s
%     mTimeResolution = 1 / mSampleRate;
%     mHalfTimeResolution = mTimeResolution * 0.5;
%     mAudioStreamSampleAxis = (0 : (mAudioStreamCounts-1))';
%     mAudioStreamTimeAxis = mAudioStreamSampleAxis * mTimeResolution + mHalfTimeResolution;
%     figure('Name','Analyse chirp template');
%     subplot(2,1,1);
%     plot(mAudioStreamSampleAxis, mAudioStream, '-x');    
%     subplot(2,1,2);
%     plot(mAudioStreamTimeAxis, mAudioStream, '-x');
% end

% fprintf("Template Signal counts: %d\n", mChirpSampleCounts);
rAnchorSignal = mChirpTemplete;

end

