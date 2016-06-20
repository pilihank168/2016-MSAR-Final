function computedPitch=wave2pitch4labeling(au, ptOpt, showPlot)
% wave2pitch4labeling: pitch tracking from a given audio
%
%	Usage:
%		pitch=wave2pitch4labeling(au, ptOpt, showPlot); 
%			au: audio
%			ptOpt: pitch-tracking options (parameters)
%			showPlot: 1 for plotting, 0 for not plotting
%			pitch: computed pitch
%
%	Example:
%		waveFile='twinkleTwinkleLittleStar.wav';
%		au=myAudioRead(waveFile);
%		ptOpt=ptOptSet(au.fs, au.nbits);
%		ptOpt.waveFile=waveFile;
%		ptOpt.targetPitchFile=[waveFile(1:end-3), 'pv'];
%		showPlot=1;
%		wave2pitch4labeling(au, ptOpt, showPlot);

%	Roger Jang, 20021201, 20120409, 20150409

if nargin<1, selfdemo; return; end
if nargin<2 || isempty(ptOpt), ptOpt=ptOptSet(au.fs, au.nbits); end
if nargin<3, showPlot=0; end

if ischar(au), au=myAudioRead(au); end	% If the give au is a file name
y=au.signal; fs=au.fs; nbits=au.nbits;
y=y-mean(y);
frameSize=round(ptOpt.frameDuration*fs/1000);
overlap=round((ptOpt.frameDuration-ptOpt.hopDuration)*fs/1000);
frameMat=enframe(y, frameSize, overlap);
frameNum=size(frameMat, 2);
computedPitch=zeros(frameNum, 1);

% ====== Compute volume & its threshold (�p�⭵�q & ���q���e��)
volume=frame2volume(frameMat);
volMax=max(volume);
volMin=min(volume);
ptOpt.volTh=volMin+0.1*(volMax-volMin);
% ====== Compute pitch �p�⭵���]�|�Ψ쭵�q���e�ȡ^
for i=1:frameNum
	frame=frameMat(:, i);
	[computedPitch(i), acf, amdf, nsdf]=frame2pitch4labeling(frame, ptOpt);
end
if ptOpt.useVolThreshold
	computedPitch(volume<ptOpt.volTh)=0;	% Set pitch to zero if the volume is too low
end

% ====== Plotting (�e��)
if showPlot
	% ====== Plot waveform
	frameTime=(1:frameNum)*(frameSize-overlap)/ptOpt.fs;
	plotNum=3;
	waveAxisH=subplot(plotNum,1,1);
	waveH=plot((1:length(y))/ptOpt.fs, y);
	if isfield(ptOpt, 'waveFile'), title(strPurify(sprintf('Wave file=%s', ptOpt.waveFile))); end
	axis([1/fs, length(y)/fs, -1, 1]); grid on
	lFrameH=line(nan*[1 1], get(waveAxisH, 'ylim'), 'color', 'r');
	rFrameH=line(nan*[1 1], get(waveAxisH, 'ylim'), 'color', 'r');
	% ====== Plot volume
	volumeAxisH=subplot(plotNum,1,2);
	plot(frameTime, volume, '.-');
	title('Sum of abs. magnitude');
	line([min(frameTime), max(frameTime)], ptOpt.volTh*[1 1], 'color', 'r');
	set(gca, 'xlim', [-inf inf]); grid on
	bar1H=line(nan*[1 1], get(gca, 'ylim'), 'color', 'r');
	% ====== Plot �q���⪺ pitch & ��ʼХܪ� pitch
	pitchAxisH=subplot(plotNum,1,3);
	temp=computedPitch; temp(temp==0)=nan;
	pitchH=plot(frameTime, temp, 'o-', 'color', 'g');		% �q���⪺ pitch
	titleStr='Computed pitch';
	targetPitch=computedPitch;
	if isfield(ptOpt, 'targetPitchFile') && exist(ptOpt.targetPitchFile, 'file')	% ���T�����Ҧb���ɮ�
		titleStr='Computed pitch (green) and groundtruth pitch (black)';
		fprintf('\tRead groundtruth pitch from %s\n', ptOpt.targetPitchFile);
		targetPitch=asciiRead(ptOpt.targetPitchFile);		% �q�����ɮ�Ū�X��ʼХܤ����T����
	end
	if length(targetPitch)>frameNum, targetPitch=targetPitch(1:frameNum); end	% �ѩ� buffer (used before) �M buffer2 (used now) ���P�ҳy�����t��
	if length(targetPitch)<frameNum, fprintf('\tIgnore the pitch within %s.\n', ptOpt.targetPitchFile); targetPitch=computedPitch; end		% If the length is not right, ignore the pitch from the PV file.
	temp=targetPitch; temp(temp==0)=nan;
	targetPitchH=line(frameTime, temp, 'color', 'k', 'marker', '.');		% ���T����
	title(titleStr);
	tempPitch=[computedPitch(:); targetPitch(:)]; tempPitch(tempPitch==0)=[];	% For computing pitch range
	axis([min(frameTime), max(frameTime), min(tempPitch)-5, max(tempPitch)+5]);
	xlabel('Time (sec)');
	grid on
	bar2H=line(nan*[1 1], get(gca, 'ylim'), 'color', 'r');
	% ====== Place the figure
	screenSize=get(0, 'screensize');
	screenSize(2)=0.1*screenSize(4);
	screenSize(4)=0.8*screenSize(4);
	set(gcf, 'position', screenSize);
	% ====== Record user data
	pitchRate=ptOpt.fs/(frameSize-overlap);
	userDataSet;
	width=150; separation=20;
	set(gcf, 'WindowButtonDownFcn', 'windowButtonDownFcn');
	uicontrol('string', 'Play wave', 'Callback', 'userDataGet; sound(au.signal, au.fs)', 'position', [separation, 10, width, 20]);
	uicontrol('string', 'Play computed pitch', 'Callback', 'userDataGet; pvPlay(computedPitch, pitchRate); pitch, pitchRate', 'position', [separation+1*(separation+width), 10, width, 20]);
	uicontrol('string', 'Play wave & computed pitch', 'Callback', 'userDataGet; pitchObj.signal=computedPitch; pitchObj.frameRate=pitchRate; audioPitchPlay(au, pitchObj);', 'position', [separation+2*(separation+width), 10, width, 20]);
	uicontrol('string', 'Play labeled pitch', 'Callback', 'userDataGet; pvPlay(targetPitch, pitchRate);', 'position', [separation+3*(separation+width), 10, width, 20]);
	uicontrol('string', 'Play wave & labeled pitch', 'Callback', 'userDataGet; pitchObj.signal=targetPitch; pitchObj.frameRate=pitchRate; audioPitchPlay(au, pitchObj);', 'position', [separation+4*(separation+width), 10, width, 20]);
	uicontrol('string', 'Save pitch', 'Callback', 'pitchSave', 'position', [separation+5*(separation+width), 10, width, 20]);
	% ====== Buttons for playback
%	pitchObj.signal=computedPitch; pitchObj.frameRate=fs/(frameSize-overlap);
%	if isfield(au, 'tPitch')
%		pitchObj2.signal=targetPitch; pitchObj2.frameRate=fs/(frameSize-overlap);
%		buttonH=audioPitchPlayButton(au, pitchObj, pitchObj2);
%		set(buttonH(end), 'string', 'Play GT pitch')
%	else
%		buttonH=audioPitchPlayButton(au, pitchObj);
%	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
strEval(mObj.example);