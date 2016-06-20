function frame2=frameFlip(frame, frameMean, plotOpt)
% frameFlip: Do necessary flip of a given frame based on energy [�ھڭ��q�j�p�A�ﭵ�ضi����g]
%	Usage: frame2=frameFlip(frame, frameMean, plotOpt)
%		frame: input frame
%		frameMean: average value of the given frame

%	Roger Jang, 20040920

%if nargin<2|isempty(frameMean), frameMean=fix(mean(frame)); end	% �t�X int frame in �ѡA�ҥH�[ fix
if nargin<2|isempty(frameMean), frameMean=mean(frame); end		% �t�X double frame in ��...
if nargin<3, plotOpt=0; end

frameSize=length(frame);
energy1=sum(abs(frame(1:floor(frameSize/2))-frameMean));
energy2=sum(abs(frame(ceil(frameSize/2)+1:end)-frameMean));
frame2=frame;
if energy1<energy2
	frame2=fliplr(flipud(frame));
	if plotOpt, fprintf('Frame flipped!\n'); end
end