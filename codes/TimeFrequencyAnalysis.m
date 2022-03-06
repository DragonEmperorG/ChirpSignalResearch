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
mAudioStreamTimeAxis = (0 : mAudioStreamLength)' * mTimeResolution;
if (sAudioStreamFigureSwitcher)    
    figure('Name','Analyse audio stream');
    plot(mAudioStreamTimeAxis, mAudioStream, '-x');
end


% STFT
stftHopLength = 128; % stftHopLength * mTimeResolution = 0.002666666666667 s
stftFFTLength = 1024; % mSampleRate / stftFFTLength = 46.875000000000000 Hz
stftOverlapLength = stftFFTLength - stftHopLength;
mStftFrequencyResolution = mSampleRate / stftFFTLength;
mStftTimeResolution = mTimeResolution * stftHopLength;
[audioStreamSpectrum, audioStreamSpectrumFrequence, audioStreamSpectrumTime] = stft(mAudioStream, mSampleRate, 'Window', hann(stftFFTLength), 'OverlapLength', 896, 'FFTLength', stftFFTLength);
audioStreamMagnitudeSpectrum = abs(audioStreamSpectrum);
audioStreamMagnitudeSpectrumPositive = flipud(audioStreamMagnitudeSpectrum(stftFFTLength/2:stftFFTLength,:));
audioStreamSpectrumFrequencyPositive = flipud(audioStreamSpectrumFrequence(stftFFTLength/2:stftFFTLength,:));


% Figure STFT with continuous frequency and time using scatter.
sStftTimeFrequencyFigureSwitcher = false;
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
timeLowerBound4Plot = 0;
timeUpperBound4Plot = mAudioStreamLength * mTimeResolution;
chirpStartTime = (mChirpInsertIndex - 1) * mTimeResolution;
chirpStopTime = chirpStartTime + mChirpLength;
if (sStftTimeFrequencyFigureSwitcher)
    figure('Name','Analyse audio stream magnitude spectrogram');    
    scatter(x4Scatter, y4Scatter, 32, z4Scatter, 's', 'filled');   
    hold on;
    plot([timeLowerBound4Plot, timeUpperBound4Plot], [mChirpStartFrequency, mChirpStartFrequency], '-r');
    plot([timeLowerBound4Plot, timeUpperBound4Plot], [mChirpStopFrequency, mChirpStopFrequency], '-r');
    plot([chirpStartTime, chirpStartTime], [0, mFrequency24000], '-r');
    plot([chirpStopTime, chirpStopTime], [0, mFrequency24000], '-r');
    daspect([mStftTimeResolution mStftFrequencyResolution 1])
    hold off;
end


% Figure STFT with discrete frequency and time using scatter.
figure('Name','Analyse audio stream magnitude spectrogram discrete');
timeCounts = length(audioStreamSpectrumTime);
frequencyCounts = length(audioStreamSpectrumFrequencyPositive);
length4Scatter = timeCounts * frequencyCounts;
x4Scatter = zeros(length4Scatter, 1);
y4Scatter = zeros(length4Scatter, 1);
z4Scatter = zeros(length4Scatter, 1);
for i = 0 : (timeCounts-1)
    endIndex = (i + 1) * frequencyCounts;
    beginIndex = endIndex - frequencyCounts + 1;
    x4Scatter(beginIndex:endIndex) = ones(frequencyCounts, 1) * i;
    y4Scatter(beginIndex:endIndex) = (frequencyCounts-1:-1:0)';
    z4Scatter(beginIndex:endIndex) = audioStreamMagnitudeSpectrumPositive(1:frequencyCounts, i+1);
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
plot([timeLowerBoundDiscrete4Plot, timeUpperBoundDiscrete4Plot], [mChirpStopFrequencyDiscrete, mChirpStopFrequencyDiscrete], '-r');

chirpStartTimeDiscrete = convertRealTime2STFTDiscreteTime(chirpStartTime, audioStreamSpectrumTime);
chirpStopTimeDiscrete = convertRealTime2STFTDiscreteTime(chirpStopTime, audioStreamSpectrumTime);
mFrequency24000Discrete = mFrequency24000 / mFrequencyResolution + 1;
plot([chirpStartTimeDiscrete, chirpStartTimeDiscrete], [0, mFrequency24000Discrete], '-r');
plot([chirpStopTimeDiscrete, chirpStopTimeDiscrete], [0, mFrequency24000Discrete], '-r');
plot([chirpStartTimeDiscrete, chirpStopTimeDiscrete], [mChirpStartFrequencyDiscrete, mChirpStopFrequencyDiscrete], '-r');

axis equal;

axDiscrete = gca; % current axes
axDiscrete.XColor = 'r';
axDiscrete.YColor = 'r';

axContinusePosition = axDiscrete.Position; % position of first axes
axContinuous = axes('Position',axContinusePosition,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');

% plot(mAudioStreamTimeAxis, mAudioStream,'Parent',axContinuous,'Color','k');
axDiscreteXlimMin = -5;
axDiscreteXlimMax = timeCounts;
axContinuousXlimMin = convertSTFTDiscreteTime2RealTime(axDiscreteXlimMin, audioStreamSpectrumTime);
axContinuousXlimMax = convertSTFTDiscreteTime2RealTime(timeCounts, audioStreamSpectrumTime);

xlim(axDiscrete, [axDiscreteXlimMin, axDiscreteXlimMax]);
xlim(axContinuous, [axContinuousXlimMin, axContinuousXlimMax]);

hlinkXlim = linkprop([axDiscrete, axContinuous],'xlim');
hlinkYlim = linkprop([axDiscrete, axContinuous],'ylim');

% Chirp Traversaler
% mChirpMidFrequenceDiscrete = (mChirpStartFrequencyDiscrete + mChirpStopFrequencyDiscrete) * 0.5;
% hold on;
% plot([timeLowerBoundDiscrete4Plot, timeUpperBoundDiscrete4Plot], [mChirpMidFrequenceDiscrete, mChirpMidFrequenceDiscrete], '-r');
%
% mChirpStftTimeLength = chirpStopTimeDiscrete - chirpStartTimeDiscrete;
% mHalfChirpStftTimeLength = mChirpStftTimeLength * 0.5;
% mChirpStftFreqLength = mChirpStopFrequencyDiscrete - mChirpStartFrequencyDiscrete;
% mChirpStftSlope = mChirpStftFreqLength / mChirpStftTimeLength;
%
% for discreteTimeTraversaler = timeLowerBoundDiscrete4Plot:timeUpperBoundDiscrete4Plot
%     % Equation of the discreteTimeTraversaler
%     % y - mChirpMidFrequenceDiscrete = mChirpStftSlope * (x - discreteTimeTraversaler)
%     timeTraversalerStart = discreteTimeTraversaler - mHalfChirpStftTimeLength;
%     timeTraversalerStop = discreteTimeTraversaler + mHalfChirpStftTimeLength;
%
%     timeTraversalerStartDiscrete = ceil(timeTraversalerStart);
%     timeTraversalerStopDiscrete = floor(timeTraversalerStop);
%
%     timeTraversalerStartDiscrete4Window = max([1, timeTraversalerStartDiscrete]);
%     timeTraversalerStopDiscrete4Window = min([timeCounts, timeTraversalerStopDiscrete]);
%
%     freqTraversalerStartDiscrete4Window = mChirpStftSlope * (timeTraversalerStartDiscrete4Window - discreteTimeTraversaler) + mChirpMidFrequenceDiscrete;
%     freqTraversalerStopDiscrete4Window = mChirpStftSlope * (timeTraversalerStopDiscrete4Window - discreteTimeTraversaler) + mChirpMidFrequenceDiscrete;
%
%     hold on;
%     plot([timeTraversalerStartDiscrete4Window, timeTraversalerStopDiscrete4Window], [freqTraversalerStartDiscrete4Window, freqTraversalerStopDiscrete4Window], '-r');
%
% end



