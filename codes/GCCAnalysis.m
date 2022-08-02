% Sample Rate in Hz
% Audio CD
m44100SR = 44100;
mSampleRate = m44100SR;
% Chirp Signal Duration in ms
mChirpLength = 0.045;
% Time Resolution in s
mTR=1/1000;
mTimeResolution = 1 / mSampleRate;
% Chirp Signal Time Axis in s
mChirpSampleLength = floor(mChirpLength / mTimeResolution);
mChirpSampleCounts = mChirpSampleLength + 1;
mChirpTimeAxis = (0 : mChirpSampleLength)' * mTimeResolution;
% Instantaneous Frequency
mFrequency15000 = 15000;
mFrequency16000 = 16000;
mFrequency17000 = 17000;
mFrequency18000 = 18000;
mFrequency21000 = 21000;
mFrequency22000 = 22000;
mFrequency24000 = 24000;
% Window Size
mWindowSampleLength = 2^ceil(log2(mChirpSampleLength));

% Chirp Generation
% mChirpStartFrequency = mFrequency15000;
% mChirpStopFrequency = mFrequency18000;
mChirpStartFrequency = mFrequency15000;
mChirpStopFrequency = mFrequency18000;
mChirpSignalValue = chirp(mChirpTimeAxis, mChirpStartFrequency, mChirpTimeAxis(end), mChirpStopFrequency);

% Analyse chirp templete
mChirpTempleteLength = mWindowSampleLength;
mChirpTemplete = zeros(mChirpTempleteLength, 1);
mChirpTemplete(1:(mChirpSampleCounts)) = mChirpSignalValue;

% mChirpTempleteTimeAxis = (0 : (mChirpTempleteLength-1))' * mTimeResolution;
% figure('Name','Analyse chirp template');
% plot(mChirpTempleteTimeAxis, mChirpTemplete, '-x');

% Analyse audio stream generation
mAudioStreamLength = mWindowSampleLength * 3;
mAudioStreamCounts = mAudioStreamLength + 1;
mAudioStream = zeros(mAudioStreamCounts, 1);
mChirpInsertStartTimeindex = mWindowSampleLength;
mChirpInsertStopTimeindex = mChirpInsertStartTimeindex + mChirpSampleCounts - 1;
mAudioStream(mChirpInsertStartTimeindex:mChirpInsertStopTimeindex) = mChirpSignalValue;

% mAudioStreamTimeAxis = (0 : (mAudioStreamLength-1))' * mTimeResolution;
% figure('Name','Analyse audio stream');
% plot(mAudioStreamTimeAxis, mAudioStream, '-x');

plotStftAnalyzerPara1 = cell(2,1);
plotStftAnalyzerPara1{1, 1} = 1;
plotStftAnalyzerPara1{2, 1} = sprintf("Stft analyzer %d", mChirpInsertStartTimeindex);
plotStftAnalyzerPara2 = cell(2,4);
plotStftAnalyzerPara2{1, 1} = mAudioStream;
plotStftAnalyzerPara2{1, 2} = mSampleRate;
plotStftAnalyzerPara2{2, 1} = mChirpInsertStartTimeindex;
plotStftAnalyzerPara2{2, 2} = mChirpInsertStopTimeindex;
plotStftAnalyzerPara2{2, 3} = mChirpStartFrequency;
plotStftAnalyzerPara2{2, 4} = mChirpStopFrequency;
plotStftAnalyzerPara3 = cell(3,1);
% plotStftAnalyzer(plotStftAnalyzerPara1, plotStftAnalyzerPara2, plotStftAnalyzerPara3)

tChirpShiftFrequency = +300;
tChirpStartFrequency = mChirpStartFrequency + tChirpShiftFrequency;
tChirpStopFrequency = mChirpStopFrequency + tChirpShiftFrequency;
mChirpSignalValue = chirp(mChirpTimeAxis, tChirpStartFrequency, mChirpTimeAxis(end), tChirpStopFrequency);
mChirpTempleteLength = mWindowSampleLength;
mChirpTemplete = zeros(mChirpTempleteLength, 1);
mChirpTemplete(1:(mChirpSampleCounts)) = mChirpSignalValue;


% GCC Analysis Window
mGccFftLength = mWindowSampleLength;
mAudioStreamGccWindowStartIndexArrayCounts = mAudioStreamCounts - mGccFftLength + 1;
mGccAnalysisValues = zeros(mAudioStreamGccWindowStartIndexArrayCounts, 3);
for i = 1 : mAudioStreamGccWindowStartIndexArrayCounts
    mAudioStreamGccWindowStartIndex = i;
    mAudioStreamGccWindow = mAudioStream(mAudioStreamGccWindowStartIndex:(mAudioStreamGccWindowStartIndex + mGccFftLength - 1));
    mAudioStreamGccWindowFft = fft(mAudioStreamGccWindow, mGccFftLength);
    
    mChirpTempleteFft = fft(mChirpTemplete, mGccFftLength);
    
    mGccIntermediate = mAudioStreamGccWindowFft .* conj(mChirpTempleteFft);
    mGccSimilarityTimeDomain = ifft(mGccIntermediate, mGccFftLength);
    
    %     mGccIntermediate = mChirpTempleteFft .* conj(mAudioStreamGccWindowFft);
    %     mGccIntermediateNormalize = mGccIntermediate ./ abs(mGccIntermediate);
    %     mGccSimilarityTimeDomain = ifft(mGccIntermediateNormalize, mGccFftLength);
    
    mGccSimilarityTimeDomainAbs = abs(mGccSimilarityTimeDomain);
    
    [mMaxVal, mMaxIndex] = max(mGccSimilarityTimeDomainAbs);
    
    gccDetectorGlobalTimeindex = mAudioStreamGccWindowStartIndex + (mMaxIndex - 1);
    gccDetectorTimeindexDiff = gccDetectorGlobalTimeindex - mChirpInsertStartTimeindex;
    
%     if mAudioStreamGccWindowStartIndex == 1983 || mAudioStreamGccWindowStartIndex == 1984
%         plotStftAnalyzerPara1{2, 1} = sprintf("Stft analyzer %d", mAudioStreamGccWindowStartIndex);
%         plotStftAnalyzerPara3{1, 1} = [gccDetectorGlobalTimeindex];
%         plotStftAnalyzer(plotStftAnalyzerPara1, plotStftAnalyzerPara2, plotStftAnalyzerPara3);
%     end
    
    mGccAnalysisValues(i, 1) = mAudioStreamGccWindowStartIndex;
    mGccAnalysisValues(i, 2) = gccDetectorGlobalTimeindex;
    mGccAnalysisValues(i, 3) = mMaxVal;
    mGccAnalysisValues(i, 4) = gccDetectorTimeindexDiff;
end

figureName = sprintf('Analyse for GCC Window and Chirp %d Hz to %d Hz Relative Relation', tChirpStartFrequency, tChirpStopFrequency);
figure('Name', figureName);
plot(mGccAnalysisValues(:, 1), mGccAnalysisValues(:, 4), 'Marker', 'o');
hold on;
plot(mGccAnalysisValues(:, 1), mGccAnalysisValues(:, 3), 'Marker', 'd');
hold off;


