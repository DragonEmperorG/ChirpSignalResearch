function realTime = convertSTFTDiscreteTime2RealTime(stftDiscreteTime, stftTimeAxis)
% 
% 输入参数： 
%   stftDiscreteTime：STFT 离散时间轴（从0开始）
%   stftTimeAxis: stft() 函数返回的对应时间轴
% 输出参数：
%   realTime: 采样时间（0时刻的采样对应Matlab样本序列下标为1的样本） 
% 调用说明：
%   
 
% 

stftStartTime = stftTimeAxis(1);
stftTimeResolution = stftTimeAxis(2) - stftTimeAxis(1);
realTime = stftStartTime + stftDiscreteTime * stftTimeResolution;
