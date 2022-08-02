kTestFolderPath = 'C:\Users\ZLLong\Downloads\20220726_151014';
kBleAnchorQueueFileName = 'BleMeasurementModuleBleAnchorQueue.csv';
kBleAnchorQueueFilePath = [kTestFolderPath, '\', kBleAnchorQueueFileName];

bleAnchorQueue = readmatrix(kBleAnchorQueueFilePath);