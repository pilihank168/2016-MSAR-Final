function [pitch, frame2, acf, amdf, nsdf]=frame2pitch4labeling(frame, plotOpt, ptOpt);
% frame2pitch4labeling: Compute pitch from a give frame
%	Usage: pitch=frame2pitch4labeling(frame, plotOpt, ptOpt); 
%		frame: input frame
%		ptOpt: pitch parameters, including fs, nbits, etc.
%		plotOpt: 1 for plotting, 0 for not plotting
%		pitch: Output pitch in semitone

%	Roger Jang, 20021201, 20070217

if nargin<1, selfdemo; return; end
if nargin<2, plotOpt=0; end

userDataGet;

% �D frame ��������
average=mean(frame);
frame=frame-average;

% frame2: �p�G�e�b���ح��q�p���b���ءA�i����g
frame2=frameFlip(frame, plotOpt);

% ====== �p�� ACF/AMDF/NSDF ���u
acf=frame2acfMex(frame2);
amdf=frame2amdfMex(frame2);
nsdf=frame2nsdfMex(frame2);

% ====== Find ROI (region of interest)
beginIndex=ceil(ptOpt.fs/pitch2freq(ptOpt.maxPitch));
endIndex=min(floor(ptOpt.fs/pitch2freq(ptOpt.minPitch)), ptOpt.pfLen);

% ====== Find local minima in ROI
localMinIndex=find(localMin(amdf));		% Avoid using localMinMex for compability across diff MATLAB versions
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
% ====== Used acf instead
localMaxIndex=find(localMin(-acf));		% Avoid using localMinMex for compability across diff MATLAB versions
localMaxCount=length(localMinIndex);
localMaxIndex(localMaxIndex>endIndex)=[];	% Remove out-of-bound local min. 
localMaxIndex(localMaxIndex<beginIndex)=[];	% Remove out-of-bound local min.
if isempty(localMaxIndex)
	pitch=0;
	return;
end
localMaxValue=acf(localMaxIndex);
% ===== Find the min. among all local min.
[maxValue, ind]=max(localMaxValue);
maxIndex=localMaxIndex(ind);

% ===== ROI (region of interest)
roi=amdf(beginIndex:min(endIndex, length(amdf)));	% region of interest
minValue=min(roi);
maxValue=max(roi);

freq=ptOpt.fs/(maxIndex-1);
pitch=freq2pitch(freq);

if frame2volume(frame)<ptOpt.volTh
	if plotOpt, fprintf('���q�Ӥp�A�����]�w�� 0�I\n'); end
	pitch=0;
end
%if localMinCount>=ptOpt.maxAmdfLocalMinCount
%	if plotOpt, fprintf('Local min. count = %d >= %d�A�����]�w�� 0�I\n', localMinCount, ptOpt.maxAmdfLocalMinCount); end
%	pitch=0;
%end

% ====== Plot related information
if plotOpt,
	clf;
	plotNum=4;
	frameAxisH=subplot(plotNum,1,1);
	frameH=plot(1:length(frame), frame, '.-'); axis([1, length(frame), -2^ptOpt.nbits/2, 2^ptOpt.nbits/2]); grid on; title('Frame');
	amdfAxisH=subplot(plotNum,1,2);
	amdfH=plot(1:length(amdf), amdf, '.-'); axis tight; title('AMDF');
	nsdfAxisH=subplot(plotNum,1,3);
	nsdfH=plot(1:length(nsdf), nsdf, '.-'); axis tight; title('NSDF');
	acfAxisH=subplot(plotNum,1,4);
	acfH=plot(1:length(acf), acf, '.-'); axis tight; title('ACF');
	if ~isempty(localMaxIndex)
		localMaxIndexH=line(localMaxIndex, acf(localMaxIndex), 'linestyle', 'none', 'color', 'k', 'marker', 'o');
	end
	if ~isempty(maxIndex)
		maxIndexH=line(maxIndex, acf(maxIndex), 'linestyle', 'none', 'color', 'r', 'marker', 'o');
		manualBarH=line(maxIndex*[1 1], get(acfAxisH, 'ylim'), 'color', 'm', 'erase', 'xor');
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
ptOpt=ptOptSet(fs, nbits);
frameMat=buffer2(y, ptOpt.frameSize, ptOpt.overlap);
frame=frameMat(:, 220);
volume=frame2volume(frameMat);
ptOpt.volTh=getVolTh(volume, ptOpt.frameSize, 4);
plotOpt=1;
feval(mfilename, frame, plotOpt, ptOpt);

return

figure
waveFile='�Ť����_���Ѥ�.wav';
[y, fs, nbits]=wavReadInt(waveFile);
ptOpt=ptOptSet(fs, nbits);
frameMat=buffer2(y, ptOpt.frameSize, ptOpt.overlap);
frame=frameMat(:, 33);
volume=frame2volume(frameMat);
ptOpt.volTh=getVolTh(volume, ptOpt.frameSize, 4);
plotOpt=1;
feval(mfilename, frame, plotOpt, ptOpt);