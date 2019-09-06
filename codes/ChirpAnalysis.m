% Sample Rate in Hz
% Audio CD
m44100SR = 44100;
m48000SR = 48000;
m192000SR = 192000;
% Octuple-Rate DSD
mOctRateDSDSR = 22579200;
% Chirp Signal Duration in ms
mChirpLength = 45;
% Time Resolution in s
mTR=1/1000;
mAudioCDTR = 1 /m44100SR;
mOctRateDSDTR = 1 /mOctRateDSDSR;
% Chirp Signal Time Axis in s
mAudioCDTA = 0 : 1 / m44100SR : (mChirpLength / 1000);
m48000TA = 0 : 1 / m48000SR : (mChirpLength / 1000);
m192000TA = 0 : 1 / m192000SR : (mChirpLength / 1000);
mOctRateDSDTA = 0 : 1 / mOctRateDSDSR : (mChirpLength / 1000);
% Instantaneous Frequency
mFrequencyView0 = 0;
mFrequency15k = 15000;
mFrequency0 = 16000;
mFrequency1 = 21000;
mFrequencyView1 = 25000;

% Chirp Generation
mAudioCDTRCS = chirp(mAudioCDTA, mFrequency0, mAudioCDTA(end), mFrequency1);
m48000TRCS = chirp(m48000TA, mFrequency0, m48000TA(end), mFrequency1);
m192000TRCS = chirp(m192000TA, mFrequency0, m192000TA(end), mFrequency1);
mOctRateDSDTRCS = chirp(mOctRateDSDTA, mFrequency0, mAudioCDTA(end), mFrequency1);

% Time Table
m44100TT=timetable(seconds(mAudioCDTA'),mAudioCDTRCS');
m48000TT = timetable(seconds(m48000TA'),m48000TRCS');
mOctRateDSDTT = timetable(seconds(mOctRateDSDTA'),mOctRateDSDTRCS');

% Raw Data
% figure('Name','Raw Chirp Signal');
% plot(mAudioCDTA, mAudioCDTRCS, '-x')
% plot(m48000TA, m48000TRCS, '-x')
% plot(m192000TA, m192000TRCS, '-x')
% plot(mOctRateDSDTA, mOctRateDSDTRCS, '-x');


%
% figure('Name','Chirp Signal Spectrogram');
% pspectrum(m44100TT,'spectrogram','FrequencyLimits',[mFrequencyView0 mFrequencyView1],'TimeResolution',mTR,'Leakage',1,'OverlapPercent',99);
% pspectrum(m48000TRCS, m48000TA,'spectrogram','TimeResolution',mAudioCDTR,'OverlapPercent',99,'Leakage',0.85);
% pspectrum(m48000TRCS, m48000TA,'spectrogram');
% pspectrum(mOctRateDSDTRCS,mOctRateDSDTA,'spectrogram','FrequencyLimits',[mFrequencyView0 mFrequencyView1],'TimeResolution',mOctRateDSDTR);


%
m44100TimeAxis1min=(0:1/m44100SR:60)';
mCSSize=size(mAudioCDTA',1);
mStepSize=2^ceil(log2(mCSSize));
mWindowSize=mStepSize*2;
% Chirp Start Time
mChirpST=20/1000*m44100SR+1;
% Chirp End Time
mChirpET=min(mChirpST+mCSSize-1,mWindowSize);
mChirp2Window=zeros(mWindowSize,1);
mChirp2Window(mChirpST:mChirpET)=mAudioCDTRCS;
mChirp2WindowTA=m44100TimeAxis1min(1:mWindowSize);

figure('Name','Chirp Signal in Window');
plot(mChirp2WindowTA, mChirp2Window, '-x');
figure('Name','Chirp Signal Spectrogram in Window');
mChirp2WindowTT=timetable(seconds(mChirp2WindowTA),mChirp2Window);
pspectrum(mChirp2WindowTT,'spectrogram','FrequencyLimits',[mFrequencyView0 mFrequencyView1],'TimeResolution',mTR,'Leakage',1,'OverlapPercent',99);


% [pxx,f] = pspectrum(mOctRateDSDTT);
% plot(f,pow2db(pxx));
% ylim = [0, 1];
% hold on
% plot([mFrequency0,mFrequency0],ylim,'--r');
% hold on
% plot([mFrequency1,mFrequency1],ylim,'--r');
% grid on
% xlabel('Frequency (Hz)')
% ylabel('Power Spectrum (dB)')
% title('Default Frequency Resolution')
% hold off
