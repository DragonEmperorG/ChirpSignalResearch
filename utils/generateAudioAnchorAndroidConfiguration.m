clear;

cFolderName = 'C:\Users\ZLLong\Downloads';
cFileName = '南京南东西通道配置表20220905_1';
cFilePath = [cFolderName '\' cFileName];
configMatrix = readmatrix(cFilePath);

cAnchorConfigFileName = 'AudioAnchorAndroidConfiguration.java';
cAreaAnchorConfigFileName = 'AudioAreaAndroidConfiguration.java';

cAreaAnchorConfigFilePath = [cFolderName '\' cAnchorConfigFileName];

tAnchorConfigFile = fopen(cAreaAnchorConfigFilePath, 'w');

kBuildingCodeIndex = 2;
kFloorCodeIndex = 3;
kZoneCodeIndex = 5;
kRegionCodeIndex = 6;
kSynchronizationCodeIndex = 7;
kEpochCodeIndex = 8;
kAreaCodeIndex = 9;
kEmitCodeIndex = 10;
kChannelCodeIndex = 11;
kSignalCodeIndex = 12;
kLocalCoordinateXCodeIndex = 20;
kLocalCoordinateYCodeIndex = 21;
kLocalCoordinateZCodeIndex = 22;

configMatrixSorted = sortrows(...
    configMatrix,...
    [kBuildingCodeIndex,kFloorCodeIndex...
    ,kZoneCodeIndex,kAreaCodeIndex,kEpochCodeIndex,kEmitCodeIndex
    ]);
configItemCounts = size(configMatrixSorted, 1);
for i = 1:configItemCounts
    fprintf(tAnchorConfigFile, '{');
%     fprintf(tAnchorConfigFile, '%d', configMatrixSorted(i, kBuildingCodeIndex));
%     fprintf(tAnchorConfigFile, ', %d', configMatrixSorted(i, kFloorCodeIndex));
    fprintf(tAnchorConfigFile, '%2d', configMatrixSorted(i, kZoneCodeIndex));
    fprintf(tAnchorConfigFile, ', %2d', configMatrixSorted(i, kRegionCodeIndex));
    fprintf(tAnchorConfigFile, ', %2d', configMatrixSorted(i, kSynchronizationCodeIndex));
    fprintf(tAnchorConfigFile, ', %d', configMatrixSorted(i, kEpochCodeIndex));
    fprintf(tAnchorConfigFile, ', %d', configMatrixSorted(i, kAreaCodeIndex));
    fprintf(tAnchorConfigFile, ', %d', configMatrixSorted(i, kEmitCodeIndex));
    fprintf(tAnchorConfigFile, ', %d', configMatrixSorted(i, kChannelCodeIndex));
    fprintf(tAnchorConfigFile, ', %d', configMatrixSorted(i, kSignalCodeIndex));
    fprintf(tAnchorConfigFile, ', %7.3f', configMatrixSorted(i, kLocalCoordinateXCodeIndex));
    fprintf(tAnchorConfigFile, ', %7.3f', configMatrixSorted(i, kLocalCoordinateYCodeIndex));
    fprintf(tAnchorConfigFile, ', %6.3f', configMatrixSorted(i, kLocalCoordinateZCodeIndex));
    fprintf(tAnchorConfigFile, '},\n');
end
fclose(tAnchorConfigFile);

% tAreaConfigFile = fopen(cAreaAnchorConfigFileName, 'w');
% areaConfigItemCounts = configItemCounts / 4;
% for i = 1:areaConfigItemCounts
%     j = i * 4;
%     buildingCode = configMatrixSorted(j, kBuildingCodeIndex);
%     floorCode = configMatrixSorted(j, kFloorCodeIndex);
%     zoneCode = configMatrixSorted(j, kZoneCodeIndex);
%     epochCode = configMatrixSorted(j, kEpochCodeIndex);
%     areaCode = configMatrixSorted(j, kAreaCodeIndex);
%     zoneAreaEpochCode = zoneCode * 100000 + areaCode + epochCode;
%     fprintf(tAreaConfigFile, 'AudioArea audioAreaB%dF%dZ%d = new AudioArea(%d, %d, %d, %d, %d);',...
%         buildingCode, floorCode, zoneAreaEpochCode, buildingCode, floorCode, zoneCode, epochCode, areaCode);
%     fprintf(tAreaConfigFile, '\n');
% end
% fclose(tAreaConfigFile);
