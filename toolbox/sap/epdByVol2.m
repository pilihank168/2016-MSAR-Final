function [endPoint, volume, zcr, soundSegment] = epdByVol2(y, fs, nbits, plotOpt, epdPrm)
% endPointDetect: End point detection based on volume only, where all sound segments are identified.
%	Usage: [endPoint, volume, zcr, soundSegment] = endPointDetect03(y, fs, nbits, plotOpt, epdPrm)

%	Roger Jang, 20041118

if nargin<1, selfdemo; return; end
if nargin<2, fs=8000; end
if nargin<3, nbits=8; end
if nargin<4, plotOpt=0; end
if nargin<5,
	epdPrm.frameSize = round(fs*480/16000);	% fs=16000 ===> frameSize=480;
	epdPrm.overlap = round(epdPrm.frameSize/3*2);
	epdPrm.zcrRatio = 0.25;
	epdPrm.minVolMultiplier1=10;
	epdPrm.minVolMultiplier2=20;
end

frameSize=epdPrm.frameSize;
overlap=epdPrm.overlap;
zcrRatio=epdPrm.zcrRatio;

if max(y)-min(y)<=2
	error('The range of the given y vector is too small! Perhaps it should be converted to integer format...');
end

% ====== Zero adjusted
y = y-round(mean(y));

% ====== Take frames
frameMat  = buffer2(y, frameSize, overlap);
frameNum = size(frameMat, 2);			% Number of frames
frameTime = frame2sampleIndex(1:frameNum, frameSize, overlap)/fs;

% ====== Compute volume/zcr
volume=frame2volume(frameMat);
[minVol, index]=min(volume);
shiftAmount=2*max(abs(frameMat(:,index)));	% �H�̤p���q�����ؤ����T���̤j����Ȫ��⭿�������q�Ӷi��ZCR
shiiftAmount=max(shiftAmount, 2);	
zcr=frame2zcr(frameMat, 1, shiftAmount);

% ====== Compute volume/zcr thresholds
volTh1=epdPrm.minVolMultiplier1*minVol;
volTh2=epdPrm.minVolMultiplier2*minVol;
maxVol=max(volume);
if volTh2>max(volume)/2			% �קK���T�Ӥj�A�ɭP volTh2 �j�󭵶q�̤j�Ȫ����~���p
	fprintf('volTh2 too big!\n');
	volTh1=maxVol/5;
	volTh2=2*volTh1;
end
if maxVol>128*volTh2			% �קK���T�Ӥp
	volTh1=maxVol/128;
	volTh2=2*volTh1;
end
zcrTh = max(zcr)*zcrRatio;

% ====== Identify voiced part that's larger than volTh2
voicedIndex = volume>=volTh2;
soundSegment=segmentFind(voicedIndex);

% ====== Delete short sound clips
%index = [];
%for i=1:length(soundSegment),
%	if (soundSegment(i).end-soundSegment(i).begin)<4
%		index = [index, i];
%	end
%end
%soundSegment(index) = [];

% ====== Expand end points to volume level1 (lower level)
for i=1:length(soundSegment),
	head = soundSegment(i).begin;
	while (head-1)>=1 & volume(head-1)>=volTh1,
		head=head-1;
	end
	soundSegment(i).begin = head;
	tail = soundSegment(i).end;
	while (tail+1)<=length(volume) & volume(tail+1)>=volTh1,
		tail=tail+1;
	end
	soundSegment(i).end = tail;
end

% ====== Delete repeated sound segments
index = [];
for i=1:length(soundSegment)-1,
	if soundSegment(i).begin==soundSegment(i+1).begin & soundSegment(i).end==soundSegment(i+1).end,
		index=[index, i];
	end
end
soundSegment(index) = [];

% ====== Transform sample-point-based index
if length(soundSegment) ~=0,
	for i=1:length(soundSegment),
		soundSegment(i).beginSample = frame2sampleIndex(soundSegment(i).begin, frameSize, overlap);
		soundSegment(i).endSample   = min(length(y), frame2sampleIndex(soundSegment(i).end, frameSize, overlap));
		soundSegment(i).beginFrame = soundSegment(i).begin;
		soundSegment(i).endFrame = soundSegment(i).end;
	end
	endPoint=[soundSegment(1).beginSample, soundSegment(end).endSample];	% ���Y��
else
	endPoint = [];
end
soundSegment=rmfield(soundSegment, 'begin');
soundSegment=rmfield(soundSegment, 'end');

if plotOpt,
	axes1H=subplot(4,1,1);
	time=(1:length(y))/fs;
	plot(time, y);
	axisLimit=[min(time) max(time) -2^nbits/2, 2^nbits/2];
	if -1<=min(y) & max(y)<=1
		axisLimit=[min(time) max(time) -1, 1];
	end
	axis(axisLimit);
	ylabel('Amplitude'); title('Waveform'); grid on
	% Plot end points
	yBound=axisLimit(3:4);
	for i=1:length(soundSegment),
		line(frame2sampleIndex(soundSegment(i).beginFrame, frameSize, overlap)/fs*[1,1], yBound, 'color', 'g');
		line(frame2sampleIndex(  soundSegment(i).endFrame, frameSize, overlap)/fs*[1,1], yBound, 'color', 'm');
	end

	axes2H=subplot(4,1,2);
	frameTime = frame2sampleIndex(1:frameNum, frameSize, overlap)/fs;
	plot(frameTime, volume, '.-');
	line([min(frameTime), max(frameTime)], volTh1*[1 1], 'color', 'r');
	line([min(frameTime), max(frameTime)], volTh2*[1 1], 'color', 'r');
	axis tight
	ylabel('Volume'); title('Volume'); grid on
	% Plot end points
	yBound = [min(volume) max(volume)];
	for i=1:length(soundSegment),
		line(frame2sampleIndex(soundSegment(i).beginFrame, frameSize, overlap)/fs*[1,1], yBound, 'color', 'g');
		line(frame2sampleIndex(  soundSegment(i).endFrame, frameSize, overlap)/fs*[1,1], yBound, 'color', 'm');
	end

	axes3H=subplot(4,1,3);
	plot(frameTime, zcr, '.-');
	line([min(frameTime), max(frameTime)], zcrTh*[1 1], 'color', 'c');
	axis([min(frameTime), max(frameTime), 0, max(zcr)]);
	ylabel('ZCR'); title('Zero crossing rate'); grid on
	% Plot end points
	yBound = [0 max(zcr)];
	for i=1:length(soundSegment),
		line(frame2sampleIndex(soundSegment(i).beginFrame, frameSize, overlap)/fs*[1,1], yBound, 'color', 'g');
		line(frame2sampleIndex(  soundSegment(i).endFrame, frameSize, overlap)/fs*[1,1], yBound, 'color', 'm');
	end

	axes4H=subplot(4,1,4);
	voicedIndex=endPoint(1):endPoint(2);
	voicedTime=time(voicedIndex);
	voicedY=y(voicedIndex);
	voicedH=plot(voicedTime, voicedY);
	axis([time(endPoint(1)), time(endPoint(2)), -2^nbits/2, 2^nbits/2]);
	ylabel('Amplitude'); title('Voiced waveform'); grid on
	
	U.y=y; U.fs=fs; U.nbits=nbits;
	U.axes1H=axes1H; U.axes2H=axes2H; U.axes3H=axes3H; U.axes4H=axes4H;
	U.voicedIndex=voicedIndex; U.voicedH=voicedH;
	U.voicedY=voicedY; U.voicedTime=voicedTime;
	set(gcf, 'userData', U);
	
	uicontrol('string', 'Play all', 'callback', 'U=get(gcf, ''userData''); sound(U.y/(2^U.nbits/2), U.fs);');
	uicontrol('string', 'Play detected', 'callback', 'U=get(gcf, ''userData''); sound(U.voicedY/(2^U.nbits/2), U.fs);', 'position', [100, 20, 100, 20]);

	% Play the segmented sound
%	head = soundSegment(1).beginFrame*(frameSize-overlap);
%	tail = min(length(y), soundSegment(end).end*(frameSize-overlap));
%	thisY = y(head:tail);
%	fprintf('His return to hear the cutted sound %g:', i);
%	pause;
%	fprintf('\n');
%	sound(thisY, fs);
%	fprintf('\n');
end

% ====== Self demo
function selfdemo
waveFile='�M�ؤj�Ǹ�T�t.wav';
waveFile='yankee doodle_����_0.wav';
waveFile='vowelMandarin.wav';
plotOpt = 1;
[y, fs, nbits] = wavReadInt(waveFile);
endPoint = feval(mfilename, y, fs, nbits, plotOpt);