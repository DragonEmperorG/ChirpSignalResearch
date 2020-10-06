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
mChirpTimeAxis = (0 : (mChirpSampleLength-1))' * mTimeResolution;
% Instantaneous Frequency
mFrequency15000 = 15000;
mFrequency16000 = 16000;
mFrequency17000 = 17000;
mFrequency18000 = 18000;
mFrequency21000 = 21000;
mFrequency22000 = 22000;
% Window Size
mWindowSampleLength = 2^ceil(log2(mChirpSampleLength));

% Chirp Generation
mChirpStartFrequence = mFrequency15000;
mChirpStopFrequence = mFrequency18000;
mChirpSignalValue = chirp(mChirpTimeAxis, mChirpStartFrequence, mChirpTimeAxis(end), mChirpStopFrequence);

% Analyse chirp templete
mChirpTempleteLength = mWindowSampleLength;
mChirpTemplete = zeros(mChirpTempleteLength, 1);
mChirpTemplete(1:(mChirpSampleLength)) = mChirpSignalValue;

% mChirpTempleteTimeAxis = (0 : (mChirpTempleteLength-1))' * mTimeResolution;
% figure('Name','Analyse chirp template');
% plot(mChirpTempleteTimeAxis, mChirpTemplete, '-x');

% Analyse audio stream generation
mAudioStreamLength = mWindowSampleLength * 3;
mAudioStream = zeros(mAudioStreamLength, 1);
mChirpInsertIndex = mWindowSampleLength + 1;
mAudioStream(mChirpInsertIndex:(mChirpInsertIndex + mChirpSampleLength - 1)) = mChirpSignalValue;

% mAudioStreamTimeAxis = (0 : (mAudioStreamLength-1))' * mTimeResolution;
% figure('Name','Analyse audio stream');
% plot(mAudioStreamTimeAxis, mAudioStream, '-x');

figure('Name','Analyse audio stream magnitude spectrogram');
stftHopLength = 128;
stftFFTLength = 1024;
stftOverlapLength = stftFFTLength - stftHopLength;
[audioStreamSpectrum, audioStreamSpectrumFrequence, audioStreamSpectrumTime] = stft(mAudioStream, mSampleRate, 'Window', hann(stftFFTLength), 'OverlapLength', 896, 'FFTLength', stftFFTLength);
audioStreamMagnitudeSpectrum = abs(audioStreamSpectrum);
audioStreamMagnitudeSpectrumPositive = flipud(audioStreamMagnitudeSpectrum(stftFFTLength/2:stftFFTLength,:));
audioStreamSpectrumFrequencePositive = flipud(audioStreamSpectrumFrequence(stftFFTLength/2:stftFFTLength,:));


% figure('Name','Standard Chirp Signal 17k to 21k Spectrogram');
% pspectrum(mAudioCDTRCS17k21k,mAudioCDTRCS17k21kTA,'spectrogram','FrequencyLimits',[mFrequency15000 mFrequencyView1],'TimeResolution',mTR)
% 
% 
% % 
% mGCCFD=m44100CSTFD./m44100CS17kDTFD;
% 
% % Time Domain
% mGCCTD=ifft(mGCCFD);
% 
% 
% 
% mGCCTDModulus=abs(mGCCTD);
% 
% % Time Delay
% [mCORRCOEF,mTimeDelay]=max(mGCCTDModulus);
