function [outputArg1] = readRealAnchorSignal()
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明

cFolderPath = 'D:\202004SuZhouOlympicSportsCenter\Datasets\Single\Base\20220907_193402';
cAudioFileName = 'Audio.wav';
cAudioFilePath = [cFolderPath, '\', cAudioFileName];

[rAudioStrem, rSampleRate] = audioread(cAudioFilePath);

cToa = 15.3192;
cSampleIndex = convertTimestamp2Timeindex(cToa, rSampleRate);

cHalfCounts = 4096;
start = cSampleIndex - cHalfCounts + 1;
stop = cSampleIndex + cHalfCounts;
clippedSignal = rAudioStrem(start:stop);

outputArg1 = clippedSignal;
end

