% Sample Rate in Hz
% Audio CD
m44100SR = 44100;
% Chirp Signal Duration in ms
mChirpLength = 45;
% Time Resolution in s
mTR=1/1000;
mAudioCDTR = 1 /m44100SR;
% Chirp Signal Time Axis in s
mAudioCDTA = (0 : 1 / m44100SR : (mChirpLength / 1000))';
% Instantaneous Frequency
mFrequencyView0 = 15000;
mFrequency16 = 16000;
mFrequency17 = 17000;
mFrequency18 = 18000;
mFrequency21 = 21000;
mFrequencyView1 = 22000;
% Window Size
mCSSize=size(mAudioCDTA,1);
mWSize=2^ceil(log2(mCSSize));
% Frequence Index
m17kFI=floor((mFrequency17-mFrequency16)*mCSSize/(mFrequency21-mFrequency16));
m18kFI=floor((mFrequency18-mFrequency16)*mCSSize/(mFrequency21-mFrequency16));

% Chirp Generation
mAudioCDTRCS = chirp(mAudioCDTA, mFrequency16, mAudioCDTA(end), mFrequency21);
mAudioCDTRCS17k21k = mAudioCDTRCS(m17kFI:end);
mAudioCDTRCS17k21kTA=mAudioCDTA(m17kFI:end);

% Chirp Signal Templete
m44100CST=randn(mWSize,1)/100;
m44100CST(1:length(mAudioCDTRCS),1)=mAudioCDTRCS;

% Chirp Signal Detector Templete
m44100CS17kDT=randn(mWSize,1)/100;
m44100CS17kDT(1:length(mAudioCDTRCS17k21k),1)=mAudioCDTRCS17k21k;

% Frequency Domain
m44100CSTFD=fft(m44100CST);
m44100CS17kDTFD=fft(m44100CS17kDT);

figure('Name','Standard Chirp Signal 16k to 21k Frequency Domain');
pspectrum(mAudioCDTRCS,mAudioCDTA,'FrequencyLimits',[mFrequencyView0 mFrequencyView1]);
figure('Name','Standard Chirp Signal 17k to 21k Frequency Domain');
pspectrum(mAudioCDTRCS17k21k,mAudioCDTRCS17k21kTA,'FrequencyLimits',[mFrequencyView0 mFrequencyView1])

figure('Name','Standard Chirp Signal 16k to 21k Spectrogram');
pspectrum(mAudioCDTRCS,mAudioCDTA,'spectrogram','FrequencyLimits',[mFrequencyView0 mFrequencyView1],'TimeResolution',mTR);
figure('Name','Standard Chirp Signal 17k to 21k Spectrogram');
pspectrum(mAudioCDTRCS17k21k,mAudioCDTRCS17k21kTA,'spectrogram','FrequencyLimits',[mFrequencyView0 mFrequencyView1],'TimeResolution',mTR)


% 
mGCCFD=m44100CSTFD./m44100CS17kDTFD;

% Time Domain
mGCCTD=ifft(mGCCFD);



mGCCTDModulus=abs(mGCCTD);

% Time Delay
[mCORRCOEF,mTimeDelay]=max(mGCCTDModulus);
