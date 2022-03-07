% Sample Rate in Hz
% Audio CD
m44100SR = 44100;
mSampleRate = m44100SR;
% Chirp Signal Duration in ms
mChirpLength = 0.045;
% Time Resolution in s
mTR=1/1000;
mTimeResolution = 1 /mSampleRate;
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
mChirpInsertIndex = mWindowSampleLength + 1;
mAudioStream(mChirpInsertIndex:(mChirpInsertIndex + mChirpSampleCounts - 1)) = mChirpSignalValue;

% mAudioStreamTimeAxis = (0 : (mAudioStreamLength-1))' * mTimeResolution;
% figure('Name','Analyse audio stream');
% plot(mAudioStreamTimeAxis, mAudioStream, '-x');

% STFT
stftHopLength = 128;
stftFFTLength = 1024;
stftOverlapLength = stftFFTLength - stftHopLength;
mFrequencyResolution = mSampleRate / stftFFTLength;
[audioStreamSpectrum, audioStreamSpectrumFrequence, audioStreamSpectrumTime] = stft(mAudioStream, mSampleRate, 'Window', hann(stftFFTLength), 'OverlapLength', 896, 'FFTLength', stftFFTLength);
audioStreamMagnitudeSpectrum = abs(audioStreamSpectrum);
audioStreamMagnitudeSpectrumPositive = flipud(audioStreamMagnitudeSpectrum(stftFFTLength/2:stftFFTLength,:));
audioStreamSpectrumFrequencePositive = flipud(audioStreamSpectrumFrequence(stftFFTLength/2:stftFFTLength,:));

figure('Name','Analyse audio stream magnitude spectrogram');
timeCounts = length(audioStreamSpectrumTime);
frequencyCounts = length(audioStreamSpectrumFrequencePositive);
length4Scatter = timeCounts * frequencyCounts;
x4Scatter = zeros(length4Scatter, 1);
y4Scatter = zeros(length4Scatter, 1);
z4Scatter = zeros(length4Scatter, 1);
for i = 1 : timeCounts
    endIndex = i * frequencyCounts;
    beginIndex = endIndex - frequencyCounts + 1;
    x4Scatter(beginIndex:endIndex) = ones(frequencyCounts, 1) * audioStreamSpectrumTime(i);
    y4Scatter(beginIndex:endIndex) = audioStreamSpectrumFrequencePositive;
    z4Scatter(beginIndex:endIndex) = audioStreamMagnitudeSpectrumPositive(1:frequencyCounts, i);
end
scatter(x4Scatter, y4Scatter, 32, z4Scatter, 's', 'filled');

hold on;
plot([audioStreamSpectrumTime(13), audioStreamSpectrumTime(13)], [0, mFrequency24000], '-r');

timeLowerBound4Plot = 0;
timeUpperBound4Plot = mAudioStreamLength * mTimeResolution;
hold on;
plot([timeLowerBound4Plot, timeUpperBound4Plot], [mChirpStartFrequency, mChirpStartFrequency], '-r');
hold on;
plot([timeLowerBound4Plot, timeUpperBound4Plot], [mChirpStopFrequency, mChirpStopFrequency], '-r');

chirpStartTime = (mChirpInsertIndex - 1) * mTimeResolution;
chirpStopTime = chirpStartTime + mChirpLength;
hold on;
plot([chirpStartTime, chirpStartTime], [0, mFrequency24000], '-r');
hold on;
plot([chirpStopTime, chirpStopTime], [0, mFrequency24000], '-r');

figure('Name','Analyse audio stream magnitude spectrogram discrete');
timeCounts = length(audioStreamSpectrumTime);
frequencyCounts = length(audioStreamSpectrumFrequencePositive);
length4Scatter = timeCounts * frequencyCounts;
x4Scatter = zeros(length4Scatter, 1);
y4Scatter = zeros(length4Scatter, 1);
z4Scatter = zeros(length4Scatter, 1);
for i = 1 : timeCounts
    endIndex = i * frequencyCounts;
    beginIndex = endIndex - frequencyCounts + 1;
    x4Scatter(beginIndex:endIndex) = ones(frequencyCounts, 1) * i;
    y4Scatter(beginIndex:endIndex) = (frequencyCounts:-1:1)';
    z4Scatter(beginIndex:endIndex) = audioStreamMagnitudeSpectrumPositive(1:frequencyCounts, i);
end
scatter(x4Scatter, y4Scatter, 32, z4Scatter, 's', 'filled');

% timeLowerBound4Discrete4Plot = 0;
% timeUpperBound4Discrete4Plot = frequencyCounts + 1;
timeLowerBoundDiscrete4Plot = convertRealTime2STFTDiscreteTime(timeLowerBound4Plot, audioStreamSpectrumTime);
timeUpperBoundDiscrete4Plot = convertRealTime2STFTDiscreteTime(timeUpperBound4Plot, audioStreamSpectrumTime);
mChirpStartFrequenceDiscrete = mChirpStartFrequency / mFrequencyResolution + 1;
mChirpStopFrequenceDiscrete = mChirpStopFrequency / mFrequencyResolution + 1;
hold on;
plot([timeLowerBoundDiscrete4Plot, timeUpperBoundDiscrete4Plot], [mChirpStartFrequenceDiscrete, mChirpStartFrequenceDiscrete], '-r');
hold on;
plot([timeLowerBoundDiscrete4Plot, timeUpperBoundDiscrete4Plot], [mChirpStopFrequenceDiscrete, mChirpStopFrequenceDiscrete], '-r');

chirpStartTimeDiscrete = convertRealTime2STFTDiscreteTime(chirpStartTime, audioStreamSpectrumTime);
chirpStopTimeDiscrete = convertRealTime2STFTDiscreteTime(chirpStopTime, audioStreamSpectrumTime);
mFrequency24000Discrete = mFrequency24000 / mFrequencyResolution + 1;
hold on;
plot([chirpStartTimeDiscrete, chirpStartTimeDiscrete], [0, mFrequency24000Discrete], '-r');
hold on;
plot([chirpStopTimeDiscrete, chirpStopTimeDiscrete], [0, mFrequency24000Discrete], '-r');
hold on;
plot([chirpStartTimeDiscrete, chirpStopTimeDiscrete], [mChirpStartFrequenceDiscrete, mChirpStopFrequenceDiscrete], '-r');

hold on;
axis equal;

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
    gccDetectorGlobalTimestamp = convertTimeindex2Timestamp(gccDetectorGlobalTimeindex, mSampleRate);
    gccDetectorTimeDiscrete = convertRealTime2STFTDiscreteTime(gccDetectorGlobalTimestamp, audioStreamSpectrumTime);
    gccDetectorTimeindexDiff = gccDetectorGlobalTimeindex - mChirpInsertIndex;

%     hold on;
%     plot([gccDetectorTimeDiscrete, gccDetectorTimeDiscrete], [0, mFrequency24000Discrete], '-r');

    mGccAnalysisValues(i, 1) = mAudioStreamGccWindowStartIndex;
    mGccAnalysisValues(i, 2) = gccDetectorGlobalTimeindex;
    mGccAnalysisValues(i, 3) = mMaxVal;
    mGccAnalysisValues(i, 4) = gccDetectorTimeindexDiff;
end

figure('Name', 'Analyse for GCC Window and Chirp Relative Relation');
plot(mGccAnalysisValues(:, 1), mGccAnalysisValues(:, 4), 'Marker', 'o');
hold on;
plot(mGccAnalysisValues(:, 1), mGccAnalysisValues(:, 3), 'Marker', 'd');

mAudioStreamGccWindowStartIndex = 1025;
mAudioStreamGccWindow = mAudioStream(mAudioStreamGccWindowStartIndex:(mAudioStreamGccWindowStartIndex + mGccFftLength - 1));
mAudioStreamGccWindowFft = fft(mAudioStreamGccWindow, mGccFftLength);

mChirpTempleteFft = fft(mChirpTemplete, mGccFftLength);

mGccIntermediate = mAudioStreamGccWindowFft .* conj(mChirpTempleteFft);
mGccIntermediateNormalize = mGccIntermediate ./ abs(mGccIntermediate);

mGccSimilarityTimeDomain = ifft(mGccIntermediateNormalize, mGccFftLength);
mGccSimilarityTimeDomainAbs = abs(mGccSimilarityTimeDomain);

[mMaxVal, mMaxIndex] = max(mGccSimilarityTimeDomainAbs);

gccDetectorTime = (mAudioStreamGccWindowStartIndex + (mMaxIndex - 1) - 1) * mTimeResolution;
gccDetectorTimeDiscrete = convertRealTime2STFTDiscreteTime(gccDetectorTime, audioStreamSpectrumTime);
gccDetectorTimeDiff = gccDetectorTime - chirpStartTime;

hold on;
plot([gccDetectorTimeDiscrete, gccDetectorTimeDiscrete], [0, mFrequency24000Discrete], '-r');


