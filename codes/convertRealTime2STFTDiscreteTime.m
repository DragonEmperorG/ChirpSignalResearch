function stftDiscreteTime = convertRealTime2STFTDiscreteTime(realTime, stftTimeAxis)
% 
% ��������� 
%   realTime: ����ʱ�䣨0ʱ�̵Ĳ�����ӦMatlab���������±�Ϊ1��������
%   stftTimeAxis: stft() �������صĶ�Ӧʱ����
% ���������
%   stftDiscreteTime��STFT ��ɢʱ���ᣨ��0��ʼ��
% ����˵����
%   
 
% 

stftStartTime = stftTimeAxis(1);
stftTimeResolution = stftTimeAxis(2) - stftTimeAxis(1);
stftDiscreteTime = (realTime - stftStartTime) / stftTimeResolution;
% stftDiscreteTime = (realTime - stftStartTime) / stftTimeResolution + 1;
