function [outputArg1,outputArg2] = plotStftAnalyzer(plotCell, stftAnalyzerCell, featureIndicatorCell)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

% STFT
pPlotFlag = plotCell{1, 1};
pPlotFigureName = plotCell{2, 1};

mAudioStream = stftAnalyzerCell{1, 1};
pSampleRate = stftAnalyzerCell{1, 2};
pTimeResolution = 1 / pSampleRate;
pStftFftLength = 1024;
pStftHopLength = 128;
pStftOverlapLength = pStftFftLength - pStftHopLength;
pStftFrequencyResolution = pSampleRate / pStftFftLength;
pStftTimeResolution = pTimeResolution * pStftHopLength;
[audioStreamSpectrum, audioStreamSpectrumFrequence, audioStreamSpectrumTime] = stft(mAudioStream, pSampleRate, 'Window', hann(pStftFftLength), 'OverlapLength', pStftOverlapLength, 'FFTLength', pStftFftLength);
audioStreamMagnitudeSpectrum = abs(audioStreamSpectrum);
audioStreamMagnitudeSpectrumPositive = flipud(audioStreamMagnitudeSpectrum(pStftFftLength/2:pStftFftLength,:));
audioStreamSpectrumFrequencePositive = flipud(audioStreamSpectrumFrequence(pStftFftLength/2:pStftFftLength,:));
timeCounts = length(audioStreamSpectrumTime);
frequencyCounts = length(audioStreamSpectrumFrequencePositive);
length4Scatter = timeCounts * frequencyCounts;
x4Scatter = zeros(length4Scatter, 1);
y4Scatter = zeros(length4Scatter, 1);
z4Scatter = zeros(length4Scatter, 1);

pAudioStreamCounts = size(mAudioStream, 1);

pSignalStftTimestampCorrection = pStftFftLength / 2 / pStftHopLength - 1;

pSignalStartTimeindex = stftAnalyzerCell{2, 1};
pSignalStartTimestamp = convertTimeindex2Timestamp(pSignalStartTimeindex, pSampleRate);
pSignalStartTimestampMarker4Plot = [pSignalStartTimestamp pSignalStartTimestamp];
pSignalStartStftTimestamp = convertRealTimeindex2StftTimestamp(pSignalStartTimeindex, pStftHopLength);
pSignalStartStftTimestampMarker4Plot = [pSignalStartStftTimestamp pSignalStartStftTimestamp];

pSignalStopTimeindex = stftAnalyzerCell{2, 2};
pSignalStopTimestamp = convertTimeindex2Timestamp(pSignalStopTimeindex, pSampleRate);
pSignalStopTimestampMarker4Plot = [pSignalStopTimestamp pSignalStopTimestamp];
pSignalStopStftTimestamp = convertRealTimeindex2StftTimestamp(pSignalStopTimeindex, pStftHopLength);
pSignalStopStftTimestampMarker4Plot = [pSignalStopStftTimestamp pSignalStopStftTimestamp];

pSignalStartFrequency = stftAnalyzerCell{2, 3};
pSignalStartFrequencyMarker4Plot = [pSignalStartFrequency pSignalStartFrequency];
pSignalStartFrequencyStftstamp = convertRealFrequency2StftFrequencystamp(pSignalStartFrequency, pSampleRate, pStftFftLength);
pSignalStartFrequencyStftstampMarker4Plot = [pSignalStartFrequencyStftstamp pSignalStartFrequencyStftstamp];

pSignalStopFrequency = stftAnalyzerCell{2, 4};
pSignalStopFrequencyMarker4Plot = [pSignalStopFrequency pSignalStopFrequency];
pSignalStopFrequencyStftstamp = convertRealFrequency2StftFrequencystamp(pSignalStopFrequency, pSampleRate, pStftFftLength);
pSignalStopFrequencyStftstampMarker4Plot = [pSignalStopFrequencyStftstamp pSignalStopFrequencyStftstamp];

pGlobalTimestampLowerBound4Plot = 0;
pGlobalTimestampUpperBound4Plot = convertTimeindex2Timestamp(pAudioStreamCounts, pSampleRate);
pGlobalTimestampBound4Plot = [pGlobalTimestampLowerBound4Plot pGlobalTimestampUpperBound4Plot];
pGlobalStftTimestampLowerBound4Plot = 0;
pGlobalStftTimestampUpperBound4Plot = convertRealTimeindex2StftTimestamp(pAudioStreamCounts, pStftHopLength);
pGlobalStftTimestampBound4Plot = [pGlobalStftTimestampLowerBound4Plot pGlobalStftTimestampUpperBound4Plot];

pGlobalFrequencyLowerBound4Plot = 0;
pGlobalFrequencyUpperBound4Plot = pSampleRate / 2;
pGlobalFrequencyBound4Plot = [pGlobalFrequencyLowerBound4Plot pGlobalFrequencyUpperBound4Plot];
pGlobalStftFrequencystampLowerBound4Plot = 0;
pGlobalStftFrequencystampUpperBound4Plot = convertRealFrequency2StftFrequencystamp(pGlobalFrequencyUpperBound4Plot, pSampleRate, pStftFftLength);;
pGlobalStftFrequencystampBound4Plot = [pGlobalStftFrequencystampLowerBound4Plot pGlobalStftFrequencystampUpperBound4Plot];


pReferenceSignalFeatureColor = 'r';
pReferenceSignalFeatureLineStyle = '--';
switch pPlotFlag
    case 1
        figure('Name',pPlotFigureName);
        for i = 1 : timeCounts
            endIndex = i * frequencyCounts;
            beginIndex = endIndex - frequencyCounts + 1;
            x4Scatter(beginIndex:endIndex) = ones(frequencyCounts, 1) * audioStreamSpectrumTime(i);
            y4Scatter(beginIndex:endIndex) = audioStreamSpectrumFrequencePositive;
            z4Scatter(beginIndex:endIndex) = audioStreamMagnitudeSpectrumPositive(1:frequencyCounts, i);
        end
        scatter(x4Scatter, y4Scatter, 32, z4Scatter, 's', 'filled');
        hold on;
        plot(pSignalStartTimestampMarker4Plot, pGlobalFrequencyBound4Plot, 'Color', pReferenceSignalFeatureColor, 'LineStyle', pReferenceSignalFeatureLineStyle);  
        plot(pSignalStopTimestampMarker4Plot, pGlobalFrequencyBound4Plot, 'Color', pReferenceSignalFeatureColor, 'LineStyle', pReferenceSignalFeatureLineStyle);
        plot(pGlobalTimestampBound4Plot, pSignalStartFrequencyMarker4Plot, 'Color', pReferenceSignalFeatureColor, 'LineStyle', pReferenceSignalFeatureLineStyle);
        plot(pGlobalTimestampBound4Plot, pSignalStopFrequencyMarker4Plot, 'Color', pReferenceSignalFeatureColor, 'LineStyle', pReferenceSignalFeatureLineStyle);
        plot([pSignalStartTimestamp, pSignalStopTimestamp], [pSignalStartFrequency, pSignalStopFrequency], 'Color', pReferenceSignalFeatureColor);
        daspect([pStftTimeResolution pStftFrequencyResolution 1])
        hold off;
    case 2
        for i = 1 : timeCounts
            endIndex = i * frequencyCounts;
            beginIndex = endIndex - frequencyCounts + 1;
            x4Scatter(beginIndex:endIndex) = ones(frequencyCounts, 1) * (i + pSignalStftTimestampCorrection);
            y4Scatter(beginIndex:endIndex) = ((frequencyCounts-1):-1:0)';
            z4Scatter(beginIndex:endIndex) = audioStreamMagnitudeSpectrumPositive(1:frequencyCounts, i);
        end
        figure('Name',pPlotFigureName);
        scatter(x4Scatter, y4Scatter, 32, z4Scatter, 's', 'filled');
        hold on;
        plot(pSignalStartStftTimestampMarker4Plot, pGlobalStftFrequencystampBound4Plot, 'Color', pReferenceSignalFeatureColor, 'LineStyle', pReferenceSignalFeatureLineStyle);  
        plot(pSignalStopStftTimestampMarker4Plot, pGlobalStftFrequencystampBound4Plot, 'Color', pReferenceSignalFeatureColor, 'LineStyle', pReferenceSignalFeatureLineStyle);
        plot(pGlobalStftTimestampBound4Plot, pSignalStartFrequencyStftstampMarker4Plot, 'Color', pReferenceSignalFeatureColor, 'LineStyle', pReferenceSignalFeatureLineStyle);
        plot(pGlobalStftTimestampBound4Plot, pSignalStopFrequencyStftstampMarker4Plot, 'Color', pReferenceSignalFeatureColor, 'LineStyle', pReferenceSignalFeatureLineStyle);
        plot([pSignalStartStftTimestamp, pSignalStopStftTimestamp], [pSignalStartFrequencyStftstamp, pSignalStopFrequencyStftstamp], 'Color', pReferenceSignalFeatureColor);
        axis equal;
        hold off;
end





end

