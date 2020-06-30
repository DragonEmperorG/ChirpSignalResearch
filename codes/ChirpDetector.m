% Sample Rate in Hz
% Audio CD
m44100SR=44100;
% Chirp Signal Duration in ms
mChirpLength = 45;
% Time Resolution in s
mAudioCDTR = 1 /m44100SR;
% Chirp Signal Time Axis in s
mAudioCDTA = (0:mAudioCDTR:(mChirpLength/1000))';
% Instantaneous Frequency
mFrequencyView0=15000;
mFrequency16=16000;
mFrequency21=21000;
mFrequencyView1=22000;
% Window Size
mCSSize=size(mAudioCDTA,1);
mWSize=2^ceil(log2(mCSSize));
% Chirp Generation
mAudioCDTRCS = chirp(mAudioCDTA, mFrequency16, mAudioCDTA(end), mFrequency21);
% Chirp Signal Templete
m44100CST=zeros(mWSize*2,1);
m44100CST(1:length(mAudioCDTRCS),1)=mAudioCDTRCS;
m44100CSTFFT=fft(m44100CST);

% Data Set
mFileName='ttttfilter';
mFilePath=['D:\Graduated\博士研究相关\室内定位开发\Samples\Audio\44100\MultiPath\' mFileName '.wav'];
[tDS,tSR]=audioread(mFilePath);
mDSSize=size(tDS,1);
% RAW Data Figure
% Data Set Time Axis
tDSTAFig=(0:mDSSize-1)/tSR;
figure('Name','Audio Signal to be Detected');
plot(tDSTAFig,tDS);
xlabel('Time(s)');

% 
mWNum=floor(mDSSize/mWSize)-1;

for i = 0:mWNum
    tStartWI=i*mWSize+1;
    tEndWI=tStartWI+mWSize*2-1;
    tUnknownS=tDS(tStartWI:tEndWI);
    tUnknownSTAFig=tDSTAFig(tStartWI:tEndWI);
    
    tUnknownSFFT=fft(tUnknownS);
    
    mGCCFFT=tUnknownSFFT./m44100CSTFFT;
    
    mGCCiFFT=ifft(mGCCFFT);
    
    figure('Name','Audio Signal Detecting Window');
    plot(tUnknownSTAFig,tUnknownS,tUnknownSTAFig,mGCCiFFT);
    xlabel('Time(s)');
    
    
end

