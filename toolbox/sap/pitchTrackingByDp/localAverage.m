function newFrame=localAverage(frame)
% LOCALAVERAGE Low-pass filter implemented as local average

%	Roger Jang, 20030115

newFrame=frame;
for i=2:length(frame)-1,
%	newFrame(i)=floor(mean(frame(i-1:i+1)));
	newFrame(i)=floor((frame(i-1)+2)/4)+floor((frame(i)+1)/2)+floor((frame(i+1)+2)/4);	% frame ���M�����t���A���O�����i�M Assembly �P�B�I
%	newFrame(i)=intDiv(frame(i-1),4)+intDiv(frame(i),2)+intDiv(frame(i+1),4);
%	newFrame(i)=fix(frame(i-1)/4)+fix(frame(i)/2)+fix(frame(i+1)/4);
end