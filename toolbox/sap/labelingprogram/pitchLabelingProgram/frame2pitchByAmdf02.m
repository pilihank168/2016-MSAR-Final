function [pitch, frame2, amdf]=frame2pitch4labeling(frame, plotOpt, ptOpt);
% frame2pitch4labeling: �Ѥ@�ӭ��حp��@�I����
%	Usage: pitch=frame2pitch4labeling(frame, ptOpt, plotOpt); 
%		frame: Each element is unsigned integer between 0 and 255 (inclusive).
%		plotOpt: 1 for plotting, 0 for not plotting
%		pitch: Output pitch in semitone

%	Roger Jang, 20021201

if nargin<1, selfdemo; return; end
if nargin<2, plotOpt=0; end
if nargin<3, ptOpt=ptOptSet(8000); end

userDataGet;

% �D frame ��������
average=mean(frame);
frame=frame-average;

% frame2: �p�G�e�b���ح��q�p���b���ءA�i����g
frame2=frameFlip(frame, plotOpt);

% ====== �p�� AMDF ���u
acf=frame2acf(frame2, length(frame2));
%acf=frame2acfMex(frame2);
amdf=frame2amdf(frame2, length(frame2));
%amdf=frame2amdfMex(frame2);

% ====== Find ROI (region of interest)
beginIndex=ceil(ptOpt.fs/ptOpt.maxFreq);
endIndex=min(floor(ptOpt.fs/ptOpt.minFreq), ptOpt.maxShift);

% ====== Find local minima in ROI
localMinIndex=localMinMex(amdf);
localMinCount=length(localMinIndex);
localMinIndex(localMinIndex>endIndex)=[];	% Remove out-of-bound local min. 
localMinIndex(localMinIndex<beginIndex)=[];	% Remove out-of-bound local min.
if isempty(localMinIndex)
	pitch=0;
	return;
end
localMinValue=amdf(localMinIndex);
% ===== Find the min. among all local min.
[minValue, ind]=min(localMinValue);
minIndex=localMinIndex(ind);

% ===== �q minIndex ���^��i��X�{�� 2, 3, 4, 5, 6 ���W
roi=amdf(beginIndex:min(endIndex, length(amdf)));	% region of interest
minValue=min(roi);
maxValue=max(roi);
difthreshold=minValue+(maxValue-minValue)/8;
if ptOpt.checkMultipleFreq
	for i=1:length(localMinIndex)
		if amdf(localMinIndex(i))<=difthreshold
			if abs((minIndex-1)/6-(localMinIndex(i)-1)) <= 6/6
				if plotOpt, fprintf('�N���� 6 ���W�I\n'); end
				minIndex=localMinIndex(i);
				break;
			elseif abs((minIndex-1)/5-(localMinIndex(i)-1)) <= 6/5
				if plotOpt, fprintf('�N���� 5 ���W�I\n'); end
				minIndex=localMinIndex(i);
				break;
			elseif abs((minIndex-1)/4-(localMinIndex(i)-1)) <= 6/4
				if plotOpt, fprintf('�N���� 4 ���W�I\n'); end
				minIndex=localMinIndex(i);
				break;
			elseif abs((minIndex-1)/3-(localMinIndex(i)-1)) <= 6/3
				if plotOpt, fprintf('�N���� 3 ���W�I\n'); end
				minIndex=localMinIndex(i);
				break;
			elseif abs((minIndex-1)/2-(localMinIndex(i)-1)) <= 6/2
				if plotOpt, fprintf('�N���� 2 ���W�I\n'); end
				minIndex=localMinIndex(i);
				break;
			end
		end
	end
end

freq=ptOpt.fs/(minIndex-1);
pitch=freq2pitch(freq);

if frame2volume(frame)<ptOpt.volTh
	if plotOpt, fprintf('���q�Ӥp�A�����]�w�� 0�I\n'); end
	pitch=0;
end
if localMinCount>=ptOpt.maxAmdfLocalMinCount
	if plotOpt, fprintf('Local min. count = %d >= %d�A�����]�w�� 0�I\n', localMinCount, ptOpt.maxAmdfLocalMinCount); end
	pitch=0;
end

% ====== Plot related information
if plotOpt,
	clf;
	plotNum=3;
	frameAxisH=subplot(plotNum,1,1);
	frameH=plot(1:length(frame), frame, '.-'); axis([1, length(frame), -2^ptOpt.nbits/2, 2^ptOpt.nbits/2]); grid on; title('Frame');
	acfAxisH=subplot(plotNum,1,2);
	acfH=plot(1:length(acf), acf, '.-'); axis tight; title('ACF vector');
	amdfAxisH=subplot(plotNum,1,3);
	amdfH=plot(1:length(amdf), amdf, '.-'); axis tight; title('AMDF vector');
	if ~isempty(localMinIndex)
		localMinIndexH=line(localMinIndex, amdf(localMinIndex), 'linestyle', 'none', 'color', 'k', 'marker', 'o');
	end
	if ~isempty(minIndex)
		minIndexH=line(minIndex, amdf(minIndex), 'linestyle', 'none', 'color', 'r', 'marker', 'o');
		manualBarH=line(minIndex*[1 1], get(amdfAxisH, 'ylim'), 'color', 'm');
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
[y, fs, nbits]=wavReadInt(waveFile);
frameMat=buffer2(y, 256, 0);
frame=frameMat(:, 220);
ptOpt=ptOptSet(fs, nbits);
volume=frame2volume(frameMat);
ptOpt.volTh=getVolTh(volume, ptOpt.frameSize, 4);
plotOpt=1;
feval(mfilename, frame, plotOpt, ptOpt);

figure;
waveFile='�Ť����_���Ѥ�.wav';
[y, fs, nbits]=wavReadInt(waveFile);
frameMat=buffer2(y, 512, 0);
frame=frameMat(:, 33);
ptOpt=ptOptSet(fs, nbits);
ptOpt.frameSize=512;
ptOpt.overlap=0;
volume=frame2volume(frameMat);
ptOpt.volTh=getVolTh(volume, ptOpt.frameSize, 4);
plotOpt=1;
feval(mfilename, frame, plotOpt, ptOpt);