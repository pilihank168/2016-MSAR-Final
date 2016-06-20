function show2pitch(waveFile,plotOpt);
% wave2pitch: �� wave ��Ʋ��ͭ����V�q
%	Usage: pitch=wave2pitch(wave, fs, nbits, plotOpt, PP); 
%		wave: Each element is a signed integer.
%		plotOpt: 1 for plotting, 0 for not plotting
%		PP: pitch parameters
%		pitch: �q���p�⤧����

%	Roger Jang, 20021201

[y, fs, nbits]=wavread(waveFile);
wave=y*2^nbits/2;
PP=setPitchPrm(fs, nbits);
PP.frameSize=fs/8000*256;
PP.overlap=0;
PP.maxShift=PP.frameSize;
PP.waveFile=waveFile;
PP.targetPitchFile=[waveFile(1:end-3), 'pv'];
nsdfPitchFile = [waveFile(1:end-3), 'Pnsdf'];

wave=wave-mean(wave);
framedY=buffer2(wave, PP.frameSize, PP.overlap);
frameNum=size(framedY, 2);
pitch=zeros(frameNum, 1);
volume=zeros(frameNum, 1);

% ====== �p�⭵�q
volume=frame2volume(framedY);
% ====== �p�⭵�q���e��
%PP.volTh=getVolTh(volume, PP.frameSize, 4);
PP.volTh=mean(volume)-0.8*var(volume)^0.5;  % modified by felix 20061218
% ====== �p�⭵���]�|�Ψ쭵�q���e�ȡ^
fp = fopen(nsdfPitchFile,'r');
pitch = fscanf(fp,'%g');
fclose(fp);

% ====== �e��
if plotOpt
	% ====== Plot wave form
	frameTime=(1:frameNum)*(PP.frameSize-PP.overlap)/PP.fs;
	plotNum=3;
	waveAxisH=subplot(plotNum,1,1);
	waveH=plot((1:length(wave))/PP.fs, wave);
	if isfield(PP, 'waveFile')
		titleStr=['Wave file = "', PP.waveFile, '"'];
		titleStr=strrep(titleStr, '_', '\_');
		title(titleStr);
	end
	axis([1/fs, length(wave)/fs, -2^PP.nbits/2, 2^PP.nbits/2-1]); grid on
	lFrameH=line(nan*[1 1], get(waveAxisH, 'ylim'), 'erase', 'xor', 'color', 'r');
	rFrameH=line(nan*[1 1], get(waveAxisH, 'ylim'), 'erase', 'xor', 'color', 'r');
	% ====== Plot volume
	volumeAxisH=subplot(plotNum,1,2);
	plot(frameTime, volume, '.-');
	title('Sum of abs. magnitude');
	line([min(frameTime), max(frameTime)], PP.volTh*[1 1], 'color', 'r');
	set(gca, 'xlim', [-inf inf]); grid on
	bar1H=line(nan*[1 1], get(gca, 'ylim'), 'erase', 'xor', 'color', 'r');
	% ====== Plot �q���⪺ pitch & ��ʼХܪ� pitch
	pitchAxisH=subplot(plotNum,1,3);
	temp=pitch; temp(temp==0)=nan;
	pitchH=plot(frameTime, temp, 'o-', 'color', 'g');		% �q���⪺ pitch
	titleStr='�q���p�⤧����';
	targetPitch=pitch;
	if isfield(PP, 'targetPitchFile') & exist(PP.targetPitchFile)	% ���T�����Ҧb���ɮ�
		titleStr='�q���p��]���^�M��ʼХܡ]�¦�^������';
		targetPitch=asciiRead(PP.targetPitchFile);		% �q�����ɮ�Ū�X��ʼХܤ����T����
	end
	if length(targetPitch)>frameNum, targetPitch=targetPitch(1:frameNum); end	% �ѩ� buffer (used before) �M buffer2 (used now) ���P�ҳy�����t��
	temp=targetPitch; temp(temp==0)=nan;
	targetPitchH=line(frameTime, temp, 'color', 'k', 'marker', '.');		% ���T����
	title(titleStr);
	axis tight; grid on
	bar2H=line(nan*[1 1], get(gca, 'ylim'), 'erase', 'xor', 'color', 'r');
	% ====== Place the figure
	screenSize=get(0, 'screensize');
	currPos=get(gcf, 'position');
	set(gcf, 'position', [screenSize(3)-currPos(3), 30, currPos(3:4)]);
	% ====== Record user data
	userDataSet;
	set(gcf, 'WindowButtonDownFcn', 'WindowButtonDownFcn');
	uicontrol('string', 'Play Audio', 'Callback', 'userDataGet; wavplay(wave/(2^PP.nbits/2), PP.fs, ''async'')', 'position', [20, 10, 60, 20]);
	uicontrol('string', 'Play Pitch1', 'Callback', 'userDataGet; pitchPlay(pitch, PP.fs/(PP.frameSize-PP.overlap));', 'position', [100, 10, 60, 20]);
	uicontrol('string', 'Play Pitch2', 'Callback', 'userDataGet; pitchPlay(targetPitch, PP.fs/(PP.frameSize-PP.overlap));', 'position', [180, 10, 60, 20]);
%	uicontrol('string', 'Save Pitch', 'Callback', 'savePitch', 'position', [260, 10, 60, 20]);
end

% ====== self demo
function selfdemo
waveFile='�۴��K�����U��_����_0.wav';
[y, fs, nbits]=wavread(waveFile);
wave=y*2^nbits/2;
PP=setPitchPrm(fs, nbits);
PP.waveFile=waveFile;
PP.targetPitchFile=[waveFile(1:end-3), 'pitch'];
feval(mfilename, wave, fs, nbits, 1, PP);