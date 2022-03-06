% Sampling frequency in Hz
% Audio CD
m44100SR = 44100;
mSampleRate = m44100SR;
% Chirp Signal Duration in s
mChirpLength = 0.045;
% Sampling period in s
mAudioTimeResolution = 1 / mSampleRate;
% Length of chirp signal
% mChirpSignalLength = ceil(mChirpLength / mAudioTimeResolution);
mChirpSignalLength = 2047;
% Chirp Signal Time Axis in s
mAudioSamplingAxis = 0:mChirpSignalLength - 1;
mAudioTimeAxis = mAudioSamplingAxis * mAudioTimeResolution;
% Instantaneous Frequency
mFrequency15000 = 15000;
mFrequency16000 = 16000;
mFrequency17000 = 17000;
mFrequency18000 = 18000;
mFrequency21000 = 21000;
mFrequency22050 = 22050;
mFrequency24000 = 24000;

% Chirp generation
mChirpFreqBegin = mFrequency15000;
mChirpFreqEnd = mFrequency24000;
mChirpSignal = chirp(mAudioTimeAxis, mChirpFreqBegin, mAudioTimeAxis(end), mChirpFreqEnd);

% Chirp signal templete
mChirpSignalTempleteSize = 2^nextpow2(mChirpSignalLength);
mChirpSignalTempleteAxis = 0:mChirpSignalTempleteSize - 1;
mChirpSignalTempleteTimeAxis = mChirpSignalTempleteAxis * mAudioTimeResolution;
mChirpSignalTemplete = zeros(mChirpSignalTempleteSize, 1);
mChirpSignalTemplete(1:length(mChirpSignal), 1) = mChirpSignal;

% Zero phase windowing
t = fftshift(mChirpSignal);

tChirpSignalTempleteShift = fftshift(mChirpSignalTemplete);

hM1 = floor((mChirpSignalLength + 1) / 2);
hM2 = floor(mChirpSignalLength / 2);
mChirpSignalTempleteShift = zeros(mChirpSignalTempleteSize, 1);
mChirpSignalTempleteShift(1:hM1) = mChirpSignal(hM2 + 1:end);
mChirpSignalTempleteShift(mChirpSignalTempleteSize - hM2 + 1:end) = mChirpSignal(1:hM2);

%%% Fiqure
% chirpTimeDomainFigureName = sprintf("Audio Chirp Signal Templete Time Domain Window (%s Samples)", num2str(mChirpSignalTempleteSize));
% figure('Name', chirpTimeDomainFigureName);
% line(mChirpSignalTempleteTimeAxis * 1000, mChirpSignalTempleteShift, 'Color', 'r');
% ax1 = gca; % current axes
% ax1.XColor = 'r';
% ax1.YColor = 'r';
% ax1.XLabel.String = 'Time (ms)';
% ax1.YLabel.String = 'Amplitude';
% ax1.XLim = [0 mChirpSignalTempleteTimeAxis(end) * 1000];
% ax1_pos = ax1.Position; % position of first axes
% ax2 = axes('Position',ax1_pos,...
%     'XAxisLocation','top',...
%     'YAxisLocation','right',...
%     'Color','none');
% ax2.XLabel.String = 'Sample';
% ax2.YLabel.String = 'Amplitude';
% ax2.XLim = [0 mChirpSignalTempleteAxis(end)];
% line(mChirpSignalTempleteAxis, tChirpSignalTempleteShift, 'Parent', ax2)

%%% Magnitude Spectrum
mFftSize = mChirpSignalTempleteSize;
mChirpSignalTempleteFreqFftSamplingAxis = 1:mFftSize;
mChirpSignalFft = fft(mChirpSignalTemplete, mFftSize);
mChirpSignalMagnitudeSpectrum = 20 * log10(abs(mChirpSignalFft));

mChirpSignalFftShift = fft(mChirpSignalTempleteShift, mFftSize);
mChirpSignalShiftMagnitudeSpectrum = 20 * log10(abs(mChirpSignalFftShift));

tChirpSignalFftShift = fft(tChirpSignalTempleteShift, mFftSize);
tChirpSignalShiftMagnitudeSpectrum = 20 * log10(abs(tChirpSignalFftShift));

%%% Fiqure
% chirpFreqDomainFigureName = sprintf("Magnitude Spectrum of Audio Chirp Signal Templete (in dB) (FFT %s Samples)", num2str(mFftSize));
% figure('Name', chirpFreqDomainFigureName);
% line(mChirpSignalTempleteFreqFftSamplingAxis, mChirpSignalShiftMagnitudeSpectrum, 'Color', 'r');
% xlabel('Sample');
% ylabel('Magnitude Spectrum (dB)');
% ax1 = gca; % current axes
% ax1.XColor = 'r';
% ax1.YColor = 'r';
% ax1.XLabel.String = 'Sample';
% ax1.YLabel.String = 'Magnitude Spectrum (dB)';
% ax1_pos = ax1.Position; % position of first axes
% ax2 = axes('Position',ax1_pos,...
%     'XAxisLocation','top',...
%     'YAxisLocation','right',...
%     'Color','none');
% ax2.XLabel.String = 'Sample';
% ax2.YLabel.String = 'Amplitude';
% line(mChirpSignalTempleteFreqFftSamplingAxis, tChirpSignalShiftMagnitudeSpectrum, 'Parent', ax2)

mAudioFftResolution = mSampleRate / mFftSize;
mChirpSignalTempleteFreqSamplingAxis = 0:(mFftSize / 2);
mChirpSignalTempleteFreqFftAxis = mChirpSignalTempleteFreqSamplingAxis * mAudioFftResolution;
mAmplitudeSpectrum = abs(mChirpSignalFft/mFftSize);
mAmplitudeSpectrum = mAmplitudeSpectrum(1:(mFftSize/2+1));
mAmplitudeSpectrum(2:end-1) = 2*mAmplitudeSpectrum(2:end-1);
mMagnitudeSpectrum = 20 * log10(abs(mChirpSignalFft));
mMagnitudeSpectrum = mMagnitudeSpectrum(1:(mFftSize/2+1));
%%% Fiqure
% chirpSingleSidedFreqDomainFigureName = sprintf("Single-Sided Amplitude Spectrum of Audio Chirp Signal Templete  (%s Samples)", num2str(mFftSize));
% figure('Name', chirpSingleSidedFreqDomainFigureName);
% line(mChirpSignalTempleteFreqFftAxis, mMagnitudeSpectrum, 'Color', 'r');
% ax1 = gca; % current axes
% ax1.XColor = 'r';
% ax1.YColor = 'r';
% ax1.XLabel.String = 'Frequence(Hz)';
% ax1.YLabel.String = 'Magnitude Spectrum(dB)';
% ax1.XLim = [0 (mFftSize/2+1)*mAudioFftResolution];
% ax1_pos = ax1.Position; % position of first axes
% ax2 = axes('Position',ax1_pos,...
%     'XAxisLocation','top',...
%     'YAxisLocation','right',...
%     'Color','none');
% line(mChirpSignalTempleteFreqSamplingAxis, mMagnitudeSpectrum, 'Parent', ax2)
% ax2.XLabel.String = 'Sample';
% ax2.YLabel.String = 'Amplitude Spectrum';
% ax2.XLim = [0 mFftSize/2+1];
% mMagnitudeSpectrumMax = max(mMagnitudeSpectrum);
% mMagnitudeSpectrumMin = min(mMagnitudeSpectrum);
% mFrequency15000Sample = mFrequency15000 / mAudioFftResolution;
% mFrequency22050Sample = mFrequency22050 / mAudioFftResolution;
% line([mFrequency15000, mFrequency15000],[mMagnitudeSpectrumMin, mMagnitudeSpectrumMax],'linestyle','--', 'Color', 'r', 'Parent', ax1)
% line([mFrequency22050, mFrequency22050],[mMagnitudeSpectrumMin, mMagnitudeSpectrumMax],'linestyle','--', 'Color', 'r', 'Parent', ax1)
% line([mFrequency15000Sample, mFrequency15000Sample],[mMagnitudeSpectrumMin, mMagnitudeSpectrumMax],'linestyle','--', 'Parent', ax2)
% line([mFrequency22050Sample, mFrequency22050Sample],[mMagnitudeSpectrumMin, mMagnitudeSpectrumMax],'linestyle','--', 'Parent', ax2)

%%% Phase Spectrum
mPhaseSpectrum = angle(mChirpSignalFft);
mPhaseSpectrumUnwrapped = unwrap(mPhaseSpectrum);

mPhaseSpectrumShift = angle(mChirpSignalFftShift);
mPhaseSpectrumShiftUnwrapped = unwrap(mPhaseSpectrumShift);

tPhaseSpectrumShift = angle(tChirpSignalFftShift);
tPhaseSpectrumShiftUnwrapped = unwrap(tPhaseSpectrumShift);

%%% Fiqure
chirpSingleSidedFreqDomainPhaseSpectrumFigureName = sprintf("Single-Sided Phase Spectrum of Audio Chirp Signal Templete  (%s Samples)", num2str(mFftSize));
figure('Name', chirpSingleSidedFreqDomainPhaseSpectrumFigureName);
line(mChirpSignalTempleteFreqFftSamplingAxis, mPhaseSpectrumShiftUnwrapped, 'Color', 'r');
ax1 = gca; % current axes
ax1.XColor = 'r';
ax1.YColor = 'r';
ax1.XLabel.String = 'Sample';
ax1.YLabel.String = 'Phase Spectrum';
mPhaseSpectrumMax = max(mPhaseSpectrumShiftUnwrapped);
mPhaseSpectrumMin = min(mPhaseSpectrumShiftUnwrapped);
line([1024, 1024],[mPhaseSpectrumMin, mPhaseSpectrumMax], 'linestyle','--', 'Color', 'r', 'Parent', ax1)
line([1025, 1025],[mPhaseSpectrumMin, mPhaseSpectrumMax], 'linestyle','--', 'Color', 'r', 'Parent', ax1)
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
ax2.XLabel.String = 'Sample';
ax2.YLabel.String = 'Phase Spectrum';
line(mChirpSignalTempleteFreqFftSamplingAxis, tPhaseSpectrumShiftUnwrapped, 'Parent', ax2)

% Data Set
% mFileName='ttttfilter';
% mFilePath=['D:\Graduated\��ʿ�о����\���ڶ�λ����\Samples\Audio\44100\MultiPath\' mFileName '.wav'];
% [tDS,tSR]=audioread(mFilePath);
% mDSSize=size(tDS,1);
%%% RAW Data Figure

%%% Data Set Time Axis
% tDSTAFig=(0:mDSSize-1)/tSR;
% figure('Name','Audio Signal to be Detected');
% plot(tDSTAFig,tDS);
% xlabel('Time(s)');

% 
% mWNum=floor(mDSSize/mWSize)-1;
% 
% for i = 0:mWNum
%     tStartWI=i*mWSize+1;
%     tEndWI=tStartWI+mWSize*2-1;
%     tUnknownS=tDS(tStartWI:tEndWI);
%     tUnknownSTAFig=tDSTAFig(tStartWI:tEndWI);
%     
%     tUnknownSFFT=fft(tUnknownS);
%     
%     mGCCFFT=tUnknownSFFT./m44100CSTFFT;
%     
%     mGCCiFFT=ifft(mGCCFFT);
%     
%     figure('Name','Audio Signal Detecting Window');
%     plot(tUnknownSTAFig,tUnknownS,tUnknownSTAFig,mGCCiFFT);
%     xlabel('Time(s)');
%     
%     
% end

