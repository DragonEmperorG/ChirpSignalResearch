kFolderPath = 'C:\Users\lqian\Downloads\20210120\122_2';
kFileName = 'Audio.wav';
kFilePath = [kFolderPath, '\', kFileName];

[kUnhandledAudioStream, kSampleRate] = audioread(kFilePath);

writeAudioStream = kUnhandledAudioStream(1:kSampleRate*10, :);

kWriteFileName = 'UnlWxTestAudio_202101201303.csv';
kWriteFilePath = [kFolderPath, '\', kWriteFileName];
writematrix(writeAudioStream, kWriteFilePath);