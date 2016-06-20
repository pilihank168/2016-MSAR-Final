function [pitch, frame2, frame3, amdf]=frame2pitch(frame, plotOpt, PP, mainWindow, correctPitch);
%frame2pitch: Frame to pitch conversion (����SPCE061A�A�ҥH�ɶq������ƹB��)
%	Usage: pitch=frame2pitch(frame, plotOpt, PP); 
%		frame: Each element is unsigned integer between 0 and 255 (inclusive).
%		plotOpt: 1 for plotting, 0 for not plotting
%		pitch: Output pitch in semitone

%	Roger Jang, 20021201

if nargin<1, selfdemo; return; end
if nargin<2, plotOpt=0; end
if nargin<3, [PP, CP]=setParam; end
if nargin<4, mainWindow=0; end
if nargin<5, correctPitch=0; end

%saveAscii(frame, 'text/frame.txt')

PP.maxFreq=pitch2freq(PP.maxPitch);
PP.minFreq=pitch2freq(PP.minPitch);
fs=PP.fs;
maxShift=PP.maxShift;
frameSize=length(frame);

% �p�G���q�Ӥp�A�h�����^�� 0
%if sum(abs(frame-128)) < 9*256,
%	pitch = 0;
%	return;
%end

% �D frame �������Ȭ�
average=intDiv(sum(frame), frameSize);
frame=frame-average;

% frame2: �p�G�e�b���ح��q�p���b���ءA�i����g
frame2=frameFlip(frame, plotOpt);

% frame3: ���Ƥ�
frame3=localAverage(frame2);	% Low-pass filter implemented as local average

% ====== �p�� AMDF ���u
amdf=frame2amdf(frame3, maxShift, 3);

% ====== ��X ROI
beginIndex=ceil(PP.fs/PP.maxFreq);
endIndex=min(floor(PP.fs/PP.minFreq), PP.maxShift);
% Move beginIndex forward until amdf is going down
for i=beginIndex:endIndex-1,
	if amdf(i)>amdf(i+1),
		break;
	end
end
beginIndex=i+1;
if beginIndex==endIndex
%	fprintf('beginIndex==endIndex ==> pitch = 0�I\n');
	pitch=0;
	plotFrame(plotOpt, frame, frame3, amdf, [], [], beginIndex, endIndex, mainWindow, correctPitch, PP.maxShift);
	return;
end

% ====== ��X ROI �� local minima
localMinIndex=[];
for i=beginIndex+1:endIndex-1
	if amdf(i-1)>amdf(i) & amdf(i)<=amdf(i+1)
		localMinIndex=[localMinIndex, i];	
	end
end

n=20;
if length(localMinIndex)>=n,	% ���ӬO�𭵡]����k�n�|�~�P�^
	pitch=0;
	if plotOpt, fprintf('Local minima �W�L %d �� ==> pitch = 0�I\n', n); end
	plotFrame(plotOpt, frame, frame3, amdf, localMinIndex, [], beginIndex, endIndex, mainWindow, correctPitch, PP.maxShift);
	return
end

% ====== ��̤p�� in ROI
roi=amdf(beginIndex:endIndex);	% region of interest
[minValue, minIndex]=min(roi);
minIndex=minIndex+beginIndex-1;

% ===== �q minIndex ���^��i��X�{�� 2, 3, 4, 5, 6 ���W
[maxValue, maxIndex]=max(roi);
difthreshold=minValue+floor((maxValue-minValue)/8);
for i=1:length(localMinIndex)
	if amdf(localMinIndex(i)) <= difthreshold
		if abs(floor((minIndex-1+3)/6)-(localMinIndex(i)-1)) <= floor(6/6)
			if plotOpt, fprintf('�N���� 6 ���W�I\n'); end
			minIndex=localMinIndex(i);
			break;
		elseif abs(floor((2*minIndex-1+5)/10)-(localMinIndex(i)-1)) <= floor(6/5)
			if plotOpt, fprintf('�N���� 5 ���W�I\n'); end
			minIndex=localMinIndex(i);
			break;
		elseif abs(floor((minIndex-1+2)/4)-(localMinIndex(i)-1)) <= floor(6/4)
			if plotOpt, fprintf('�N���� 4 ���W�I\n'); end
			minIndex=localMinIndex(i);
			break;
		elseif abs(floor((2*minIndex-1+3)/6)-(localMinIndex(i)-1)) <= floor(6/3)
			if plotOpt, fprintf('�N���� 3 ���W�I\n'); end
			minIndex=localMinIndex(i);
			break;
		elseif abs(floor((minIndex-1+1)/2)-(localMinIndex(i)-1)) <= floor(6/2)
			if plotOpt, fprintf('�N���� 2 ���W�I\n'); end
			minIndex=localMinIndex(i);
			break;
		end
	end
end


%freq=floor((10*PP.fs+floor((minIndex-1)/2))/(minIndex-1));	% ���Ĥ@�� minimum �ӭp����W�]�|�z���I�^
freq=10*floor((PP.fs+floor((minIndex-1)/2))/(minIndex-1));	% ���Ĥ@�� minimum �ӭp����W
%fprintf('minIndex=%d\n', minIndex);
%fprintf('freq=%d\n', freq);
pitch=freq2pitch(freq);
% ====== Plot all related information
plotFrame(plotOpt, frame, frame3, amdf, localMinIndex, minIndex, beginIndex, endIndex, mainWindow, correctPitch, PP.maxShift);

% ====== Plot related information
function plotFrame(plotOpt, frame, frame3, amdf, localMinIndex, minIndex, beginIndex, endIndex, mainWindow, correctPitch, maxShift)
if plotOpt,
	frameSize=length(frame);
	subplot(2,1,1);
%	plot(1:length(frame), frame, '.-', 1:length(frame3), frame3, '.-'); grid on
	frameH=plot(1:length(frame), frame, '.-'); grid on
	set(frameH, 'tag', 'frame');
	title(['Frame (frameSize=', int2str(frameSize), ')']);
	set(gca, 'xlim', [1 frameSize]);
	subplot(2,1,2);
	amdfH=plot(amdf, '.-'); grid on
	set(amdfH, 'tag', 'amdf');
	amdfAxisH=gca;
	set(gca, 'tag', 'amdfAxis');
	title(['amdf (maxShift=', int2str(maxShift), ')']);
	set(gca, 'xlim', [1 maxShift]);
	if ~isempty(localMinIndex)
		localMinIndexH=line(localMinIndex, amdf(localMinIndex), 'linestyle', 'none', 'color', 'k', 'marker', 'o', 'tag', 'localMinIndexH');
	end
	if ~isempty(minIndex)
		minIndexH=line(minIndex, amdf(minIndex), 'linestyle', 'none', 'color', 'r', 'marker', 'o', 'tag', 'minIndexH');
		if correctPitch==0
			minIndex=nan;
		else
			minIndex=round(1+8000/(440*2^((correctPitch/10-69)/12)));
		end
		manualBarH=line(minIndex*[1 1], get(amdfAxisH, 'ylim'), 'color', 'm', 'erase', 'xor', 'tag', 'manualBar');
	end
	line(beginIndex*[1 1], get(gca, 'ylim'), 'color', 'r');
	line(  endIndex*[1 1], get(gca, 'ylim'), 'color', 'r');
	set(gcf, 'name', mfilename);
	
	% �]�w�ƹ����s�������ʧ@�A�H�K���ϥΪ̭ץ� pitch
	if mainWindow>0;
		set(gcf, 'userdata', mainWindow);
		frameWinMouseAction;
	end
end


% ====== selfdemo
function selfdemo
waveFile='�Ⱖ�Ѫ�.wav';
[y, PP.fs, nbits]=wavread(waveFile);
y=y*(2^nbits/2);

frameSize=256;
overlap=-256;
framedY=buffer2(y, frameSize, overlap);
frame=framedY(:, 100);
plotOpt=1;
feval(mfilename, frame,  plotOpt);