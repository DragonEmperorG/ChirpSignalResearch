function stftTimestamp = convertRealTimeindex2StftTimestamp(realTimeindex, stftHopLength)
% 
% ��������� 
%   realTime: ����ʱ�䣨0ʱ�̵Ĳ�����ӦMatlab���������±�Ϊ1��������
%   stftTimeAxis: stft() �������صĶ�Ӧʱ����
% ���������
%   stftDiscreteTime��STFT ��ɢʱ���ᣨ��0��ʼ��
% ����˵����
%   
 
% 
stftTimestamp = realTimeindex / stftHopLength;
