function stftFrequencystamp = convertRealFrequency2StftFrequencystamp(realFrequency, sampleRate, stftFftLength)
% 
% 输入参数： 
%   realTime: 采样时间（0时刻的采样对应Matlab样本序列下标为1的样本）
%   stftTimeAxis: stft() 函数返回的对应时间轴
% 输出参数：
%   stftDiscreteTime：STFT 离散时间轴（从0开始）
% 调用说明：
%   
 
% 

stftFrequencyindexResolution = sampleRate / stftFftLength;
stftFrequencystamp = realFrequency / stftFrequencyindexResolution;
