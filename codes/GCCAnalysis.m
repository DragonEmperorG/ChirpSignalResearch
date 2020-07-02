% Sample Rate in Hz
% Audio CD
m44100SR = 44100;
mSampleRate = m44100SR;
% Chirp Signal Duration in ms
mChirpLength = 45;
% Time Resolution in s
mTR=1/1000;
mAudioCDTR = 1 / m44100SR;
% Chirp Signal Time Axis in s
mAudioTimeAxis = (0 : 1 / mSampleRate : (mChirpLength / 1000))';
% Instantaneous Frequency
mFrequency15k = 15000;
mFrequency16k = 16000;
mFrequency17k = 17000;
mFrequency18k = 18000;
mFrequency21k = 21000;
mFrequency22k = 22000;
mFrequency24k = 24000;
% Window Size
mChirpSignalSize=size(mAudioTimeAxis,1);
mWindowSize=2^ceil(log2(mChirpSignalSize));
% Frequence Index
m17kFI=floor((mFrequency17k-mFrequency16k)*mChirpSignalSize/(mFrequency21k-mFrequency16k));
m18kFI=floor((mFrequency18k-mFrequency16k)*mChirpSignalSize/(mFrequency21k-mFrequency16k));

% Chirp Generation

mAudioTRCS = chirp(mAudioTimeAxis, mFrequency16k, mAudioCDTA(end), mFrequency21k);
mAudioCDTRCS17k21k = mAudioTRCS(m17kFI:end);
mAudioCDTRCS17k21kTA = mAudioCDTA(m17kFI:end);

% Chirp Signal Templete
m44100CST=randn(mWindowSize,1)/100;
m44100CST(1:length(mAudioTRCS),1)=mAudioTRCS;

% Chirp Signal Detector Templete
m44100CS17kDT=randn(mWindowSize,1)/100;
m44100CS17kDT(1:length(mAudioCDTRCS17k21k),1)=mAudioCDTRCS17k21k;

% Frequency Domain
m44100CSTFD=fft(m44100CST);
m44100CS17kDTFD=fft(m44100CS17kDT);

% figure('Name','Standard Chirp Signal 16k to 21k Frequency Domain');
% pspectrum(mAudioCDTRCS,mAudioCDTA,'FrequencyLimits',[mFrequencyView0 mFrequencyView1]);
% figure('Name','Standard Chirp Signal 17k to 21k Frequency Domain');
% pspectrum(mAudioCDTRCS17k21k,mAudioCDTRCS17k21kTA,'FrequencyLimits',[mFrequencyView0 mFrequencyView1])

% figure('Name','Standard Chirp Signal 16k to 21k Spectrogram');
% pspectrum(mAudioCDTRCS,mAudioCDTA,'spectrogram','FrequencyLimits',[mFrequencyView0 mFrequencyView1],'TimeResolution',mTR);
% figure('Name','Standard Chirp Signal 17k to 21k Spectrogram');
% pspectrum(mAudioCDTRCS17k21k,mAudioCDTRCS17k21kTA,'spectrogram','FrequencyLimits',[mFrequencyView0 mFrequencyView1],'TimeResolution',mTR)


% 
% mGCCFD=m44100CSTFD./m44100CS17kDTFD;

% Time Domain
% mGCCTD=ifft(mGCCFD);



% mGCCTDModulus=abs(mGCCTD);

% Time Delay
% [mCORRCOEF,mTimeDelay]=max(mGCCTDModulus);
