% Sample Rate in Hz
% Audio CD
m44100SR = 44100;
m48000SR = 48000;
mSampleRate = m48000SR;
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
mChirpStartFrequency = mFrequency15000;
mChirpStopFrequency = mFrequency18000;
mChirpSignalValue = chirp(mChirpTimeAxis, mChirpStartFrequency, mChirpTimeAxis(end), mChirpStopFrequency);

% Analyse chirp templete
mChirpTempleteLength = mWindowSampleLength;    % 2048
mChirpTemplete = zeros(mChirpTempleteLength, 1);
mChirpTemplete(1:(mChirpSampleCounts)) = mChirpSignalValue;

% mChirpTempleteTimeAxis = (0 : (mChirpTempleteLength-1))' * mTimeResolution;
% figure('Name','Analyse chirp template');
% plot(mChirpTempleteTimeAxis, mChirpTemplete, '-x');

% Analyse audio stream generation
% In this analysis, I assume the the audio value is sampled at the end of
% sampling interval.
mAudioStreamLength = mSampleRate;
mAudioStreamCounts = mAudioStreamLength + 1;
mAudioStream = zeros(mAudioStreamCounts, 1);
mChirpInsertIndex = mSampleRate * 0.5 + 1;
% The mChirpInsertIndex start at 0.5s (mSampleRate * 0.5 * mTimeResolution = 0.5)
mAudioStream(mChirpInsertIndex:(mChirpInsertIndex + mChirpSampleCounts - 1)) = mChirpSignalValue;

sAudioStreamFigureSwitcher = false;
if (sAudioStreamFigureSwitcher)
    mAudioStreamTimeAxis = (0 : mAudioStreamLength)' * mTimeResolution;
    figure('Name','Analyse audio stream');
    plot(mAudioStreamTimeAxis, mAudioStream, '-x');
end


% STFT
stftHopLength = 128; % stftHopLength * mTimeResolution = 0.002666666666667 s
stftFFTLength = 1024; % mSampleRate / stftFFTLength = 46.875000000000000 Hz
stftOverlapLength = stftFFTLength - stftHopLength;
mFrequencyResolution = mSampleRate / stftFFTLength;
[audioStreamSpectrum, audioStreamSpectrumFrequence, audioStreamSpectrumTime] = stft(mAudioStream, mSampleRate, 'Window', hann(stftFFTLength), 'OverlapLength', 896, 'FFTLength', stftFFTLength);
audioStreamMagnitudeSpectrum = abs(audioStreamSpectrum);
audioStreamMagnitudeSpectrumPositive = flipud(audioStreamMagnitudeSpectrum(stftFFTLength/2:stftFFTLength,:));
audioStreamSpectrumFrequencyPositive = flipud(audioStreamSpectrumFrequence(stftFFTLength/2:stftFFTLength,:));

sStftTimeFrequencyFigureSwitcher = true;
if (sStftTimeFrequencyFigureSwitcher)
    figure('Name','Analyse audio stream magnitude spectrogram');
    timeCounts = length(audioStreamSpectrumTime);
    frequencyCounts = length(audioStreamSpectrumFrequencyPositive);
    length4Scatter = timeCounts * frequencyCounts;
    x4Scatter = zeros(length4Scatter, 1);
    y4Scatter = zeros(length4Scatter, 1);
    z4Scatter = zeros(length4Scatter, 1);
    for i = 1 : timeCounts
        endIndex = i * frequencyCounts;
        beginIndex = endIndex - frequencyCounts + 1;
        x4Scatter(beginIndex:endIndex) = ones(frequencyCounts, 1) * audioStreamSpectrumTime(i);
        y4Scatter(beginIndex:endIndex) = audioStreamSpectrumFrequencyPositive;
        z4Scatter(beginIndex:endIndex) = audioStreamMagnitudeSpectrumPositive(1:frequencyCounts, i);
    end
    scatter(x4Scatter, y4Scatter, 32, z4Scatter, 's', 'filled');
    
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
    
    hold on;
    axis tight;
end



figure('Name','Analyse audio stream magnitude spectrogram discrete');
timeCounts = length(audioStreamSpectrumTime);
frequencyCounts = length(audioStreamSpectrumFrequencyPositive);
length4Scatter = timeCounts * frequencyCounts;
x4Scatter = zeros(length4Scatter, 1);
y4Scatter = zeros(length4Scatter, 1);
z4Scatter = zeros(length4Scatter, 1);
for i = 0 : (timeCounts - 1)
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
mChirpStartFrequencyDiscrete = mChirpStartFrequency / mFrequencyResolution + 1;
mChirpStopFrequencyDiscrete = mChirpStopFrequency / mFrequencyResolution + 1;
hold on;
plot([timeLowerBoundDiscrete4Plot, timeUpperBoundDiscrete4Plot], [mChirpStartFrequencyDiscrete, mChirpStartFrequencyDiscrete], '-r');
hold on;
plot([timeLowerBoundDiscrete4Plot, timeUpperBoundDiscrete4Plot], [mChirpStopFrequencyDiscrete, mChirpStopFrequencyDiscrete], '-r');

chirpStartTimeDiscrete = convertRealTime2STFTDiscreteTime(chirpStartTime, audioStreamSpectrumTime);
chirpStopTimeDiscrete = convertRealTime2STFTDiscreteTime(chirpStopTime, audioStreamSpectrumTime);
mFrequency24000Discrete = mFrequency24000 / mFrequencyResolution + 1;
hold on;
plot([chirpStartTimeDiscrete, chirpStartTimeDiscrete], [0, mFrequency24000Discrete], '-r');
hold on;
plot([chirpStopTimeDiscrete, chirpStopTimeDiscrete], [0, mFrequency24000Discrete], '-r');
hold on;
plot([chirpStartTimeDiscrete, chirpStopTimeDiscrete], [mChirpStartFrequencyDiscrete, mChirpStopFrequencyDiscrete], '-r');

hold on;
axis equal;

% Chirp Traversaler
mChirpMidFrequenceDiscrete = (mChirpStartFrequencyDiscrete + mChirpStopFrequencyDiscrete) * 0.5;
hold on;
plot([timeLowerBoundDiscrete4Plot, timeUpperBoundDiscrete4Plot], [mChirpMidFrequenceDiscrete, mChirpMidFrequenceDiscrete], '-r');

mChirpStftTimeLength = chirpStopTimeDiscrete - chirpStartTimeDiscrete;
mHalfChirpStftTimeLength = mChirpStftTimeLength * 0.5;
mChirpStftFreqLength = mChirpStopFrequencyDiscrete - mChirpStartFrequencyDiscrete;
mChirpStftSlope = mChirpStftFreqLength / mChirpStftTimeLength;

for discreteTimeTraversaler = timeLowerBoundDiscrete4Plot:timeUpperBoundDiscrete4Plot
    % Equation of the discreteTimeTraversaler
    % y - mChirpMidFrequenceDiscrete = mChirpStftSlope * (x - discreteTimeTraversaler)
    timeTraversalerStart = discreteTimeTraversaler - mHalfChirpStftTimeLength;
    timeTraversalerStop = discreteTimeTraversaler + mHalfChirpStftTimeLength;
    
    timeTraversalerStartDiscrete = ceil(timeTraversalerStart);
    timeTraversalerStopDiscrete = floor(timeTraversalerStop);
    
    timeTraversalerStartDiscrete4Window = max([1, timeTraversalerStartDiscrete]);
    timeTraversalerStopDiscrete4Window = min([timeCounts, timeTraversalerStopDiscrete]);
    
    freqTraversalerStartDiscrete4Window = mChirpStftSlope * (timeTraversalerStartDiscrete4Window - discreteTimeTraversaler) + mChirpMidFrequenceDiscrete;
    freqTraversalerStopDiscrete4Window = mChirpStftSlope * (timeTraversalerStopDiscrete4Window - discreteTimeTraversaler) + mChirpMidFrequenceDiscrete;
    
    hold on;
    plot([timeTraversalerStartDiscrete4Window, timeTraversalerStopDiscrete4Window], [freqTraversalerStartDiscrete4Window, freqTraversalerStopDiscrete4Window], '-r');
    
end



