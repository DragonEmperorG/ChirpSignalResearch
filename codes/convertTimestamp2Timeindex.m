function timeindex = convertTimestamp2Timeindex(timestamp, sampleRate)
% 
% 输入参数： 
%   timestamp: 采样样本数（0时刻的采样对应Matlab样本序列下标为1的样本）
%   sampleRate: 采样率
% 输出参数：
%   timestamp：采样时刻（从0开始）
% 调用说明：
%   
 
% 

timeindex = floor(timestamp * sampleRate);


