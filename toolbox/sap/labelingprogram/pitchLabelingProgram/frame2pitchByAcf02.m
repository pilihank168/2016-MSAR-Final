function [pitch, frame2, acf]=frame2pitch4labeling(frame, plotOpt, ptOpt);
% frame2pitch4labeling: �Ѥ@�ӭ��حp��@�I����
%	Usage: pitch=frame2pitch4labeling(frame, ptOpt, plotOpt); 
%		frame: Each element is unsigned integer between 0 and 255 (inclusive).
%		plotOpt: 1 for plotting, 0 for not plotting
%		pitch: Output pitch in semitone

%	Roger Jang, 20021201

if nargin<1, selfdemo; return; end
if nargin<2, plotOpt=0; end
if nargin<3, ptOpt=setPrm; end

ptOpt.maxFreq=pitch2freq(ptOpt.maxPitch);
ptOpt.minFreq=pitch2freq(ptOpt.minPitch);
frameSize=length(frame);

% �D frame ��������
average=mean(frame);
frame=frame-average;

% ====== �p�� ACF ���u
for i = 1:frameSize
	acf(i) = sum(frame(i:end).*frame(1:end-i+1));		% ���� frame(1:end)�A�A�D���|���������n
end

% ====== Find ROI (region of interest)
beginIndex=ceil(ptOpt.fs/ptOpt.maxFreq);
endIndex=min(floor(ptOpt.fs/ptOpt.minFreq), frameSize);
while acf(beginIndex)>acf(beginIndex+1)
	beginIndex=beginIndex+1;
	if beginIndex==frameSize, break; end
end

% ====== Find local maxima in ROI
localMaxIndex=[];
for i=beginIndex+1:endIndex-1
	if acf(i-1)<acf(i) & acf(i)>=acf(i+1)
		localMaxIndex=[localMaxIndex, i];
	end
end

% ====== ��̤j�� in ROI
roi=acf(beginIndex:endIndex);		% region of interest
[maxValue, maxIndex]=max(roi);
maxIndex=maxIndex+beginIndex-1;

freq=ptOpt.fs/(maxIndex-1);
pitch=freq2pitch(freq);

if frame2volume(frame)<ptOpt.volTh
	if plotOpt, fprintf('���q�Ӥp�A�����]�w�� 0�I\n'); end
	pitch=0;
end

% ====== Plot related information
if plotOpt,
	userDataGet;
	
	clf;
	plotNum=2;
	frameAxisH=subplot(plotNum,1,1);
	frameH=plot(1:length(frame), frame, '.-'); axis tight; title('Frame');
	acfAxisH=subplot(plotNum,1,2);
	acfH=plot(1:length(acf), acf, '.-'); axis tight; title('ACF vector');
	if ~isempty(localMaxIndex)
		localMaxIndexH=line(localMaxIndex, acf(localMaxIndex), 'linestyle', 'none', 'color', 'k', 'marker', 'o');
	end
	if ~isempty(maxIndex)
		maxIndexH=line(maxIndex, acf(maxIndex), 'linestyle', 'none', 'color', 'r', 'marker', 'o');
		manualBarH=line(maxIndex*[1 1], get(acfAxisH, 'ylim'), 'color', 'm');
	end
	line(beginIndex*[1 1], get(gca, 'ylim'), 'color', 'r');
	line(  endIndex*[1 1], get(gca, 'ylim'), 'color', 'r');
	
	userDataSet;
	% �]�w�ƹ����s�������ʧ@�A�H�K���ϥΪ̭ץ� pitch
	if gcf~=1;
		frameWinMouseAction;
	end
end

% ====== selfdemo
function selfdemo
waveFile='�۴��K�����U��_����_0.wav';
[y, fs, nbits]=wavread(waveFile);
y=y*2^nbits/2;
frameMat=buffer2(y, 256, 0);
frame=frameMat(:, 220);
ptOpt=setPrm;
plotOpt=1;
feval(mfilename, frame, plotOpt, ptOpt);