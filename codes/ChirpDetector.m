% Sampling frequency in Hz
% Audio CD
m44100SR = 44100;
mSampleRate = m44100SR;
% Chirp Signal Duration in s
mChirpLength = 0.045;
% Sampling period in s
mAudioTimeResolution = 1 / mSampleRate;
% Length of chirp signal
mChirpSignalLength = ceil(mChirpLength / mAudioTimeResolution);
% Chirp Signal Time Axis in s
mAudioSamplingAxis = 0:mChirpSignalLength - 1;
mAudioTimeAxis = mAudioSamplingAxis * mAudioTimeResolution;
% Instantaneous Frequency
mFrequency15k = 15000;
mFrequency16k = 16000;
mFrequency17k = 17000;
mFrequency18k = 18000;
mFrequency21k = 21000;
mFrequency22k = 22000;
mFrequency24k = 24000;

% Chirp generation
mChirpFreqBegin = mFrequency15k;
mChirpFreqEnd = mFrequency24k;
mChirpSignal = chirp(mAudioTimeAxis, mChirpFreqBegin, mAudioTimeAxis(end), mChirpFreqEnd);

% Chirp signal templete
mChirpSignalTempleteSize = 2^nextpow2(mChirpSignalLength);
mChirpSignalTempleteAxis = 0:mChirpSignalTempleteSize - 1;
mChirpSignalTempleteTimeAxis = mChirpSignalTempleteAxis * mAudioTimeResolution;
mChirpSignalTemplete = zeros(mChirpSignalTempleteSize, 1);
mChirpSignalTemplete(1:length(mChirpSignal), 1) = mChirpSignal;

%%% Fiqure
% chirpTimeDomainFigureName = sprintf("Audio Chirp Signal Templete Time Domain Window (%s Samples)", num2str(mChirpSignalTempleteSize));
% figure('Name', chirpTimeDomainFigureName);
% line(mChirpSignalTempleteTimeAxis * 1000, mChirpSignalTemplete);
% ax1 = gca; % current axes
% % ax1.XColor = 'r';
% % ax1.YColor = 'r';
% ax1_pos = ax1.Position; % position of first axes
% ax2 = axes('Position',ax1_pos,...
%     'XAxisLocation','top',...
%     'YAxisLocation','right',...
%     'Color','none');
% line(mChirpSignalTempleteAxis, mChirpSignalTemplete, 'Parent', ax2)

mFftSize = mChirpSignalTempleteSize;
mChirpSignalTempleteFreqFftSamplingAxis = 1:mFftSize;
mChirpSignalFft = fft(mChirpSignalTemplete, mFftSize);
mChirpSignalMagnitudeSpectrum = 20 * log10(abs(mChirpSignalFft));
%%% Fiqure
% chirpFreqDomainFigureName = sprintf("Magnitude Spectrum of Audio Chirp Signal Templete (in dB) (FFT %s Samples)", num2str(mFftSize));
% figure('Name', chirpFreqDomainFigureName);
% line(mChirpSignalTempleteFreqFftSamplingAxis, mChirpSignalMagnitudeSpectrum);
% xlabel('Sample');
% ylabel('Magnitude Spectrum (dB)');

mAudioFftResolution = mSampleRate / mFftSize;
mChirpSignalTempleteFreqSamplingAxis = 0:(mFftSize / 2);
mChirpSignalTempleteFreqFftAxis = mChirpSignalTempleteFreqSamplingAxis * mAudioFftResolution;
mAmplitudeSpectrum = abs(mChirpSignalFft/mFftSize);
mAmplitudeSpectrum = mAmplitudeSpectrum(1:(mFftSize/2+1));
mAmplitudeSpectrum(2:end-1) = 2*mAmplitudeSpectrum(2:end-1);
mMagnitudeSpectrum = 20 * log10(abs(mChirpSignalFft));
mMagnitudeSpectrum = mMagnitudeSpectrum(1:(mFftSize/2+1));
%%% Fiqure
chirpSingleSidedFreqDomainFigureName = sprintf("Single-Sided Amplitude Spectrum of Audio Chirp Signal Templete  (%s Samples)", num2str(mFftSize));
figure('Name', chirpFreqDomainFigureName);
line(mChirpSignalTempleteFreqFftAxis, mMagnitudeSpectrum, 'Color', 'r');
ax1 = gca; % current axes
ax1.XColor = 'r';
ax1.YColor = 'r';
ax1.XLabel.String = 'Frequence(Hz)';
ax1.YLabel.String = 'Magnitude Spectrum(dB)';
ax1.XLim = [0 (mFftSize/2+1)*mAudioFftResolution];
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
line(mChirpSignalTempleteFreqSamplingAxis, mAmplitudeSpectrum, 'Parent', ax2)
ax2.XLabel.String = 'Sample';
ax2.YLabel.String = 'Amplitude Spectrum';
ax2.XLim = [0 mFftSize/2+1];

% Data Set
% mFileName='ttttfilter';
% mFilePath=['D:\Graduated\博士研究相关\室内定位开发\Samples\Audio\44100\MultiPath\' mFileName '.wav'];
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

