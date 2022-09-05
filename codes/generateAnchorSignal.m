function [rAnchorSignal] = generateAnchorSignal(sampleRate, startFrequency, stopFrequency, signalDuration)
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

Q1 = (0:mTimeResolution:signalDuration)';
Q2 = chirp(Q1, mChirpStartFrequency, mChirpLength, stopFrequency);

Q3 = Q1 - mChirpTimeAxis;
Q4 = Q2 - mChirpSignalValue;

fprintf("Signal counts: %d\n", mChirpSampleCounts);
rAnchorSignal = mChirpSignalValue;

end

