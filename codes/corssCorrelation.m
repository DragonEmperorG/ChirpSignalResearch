function [outputArg1] = corssCorrelation(samples,template)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
ccFftCounts = length(template);
samplesFft = fft(samples, ccFftCounts);
templeteFft = fft(template, ccFftCounts);
ccIntermediate = samplesFft .* conj(templeteFft);
ccResult = ifft(ccIntermediate, ccFftCounts);

% r = xcorr(x,y);

outputArg1 = ccResult;
end

