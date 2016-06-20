function endPointLabel(action, waveFile)
% endPointLabel: Label endpoints of a given wave file

if nargin<1, action='start'; end
if nargin<2, waveFile='1a_9816_16065.wav'; end

switch(action)
	case 'start', % ====== �}�ҹϧε���
	%	[y, fs, nbits]=wavread(waveFile);
		au=myAudioRead(waveFile); y=au.signal; fs=au.fs; nbits=au.nbits;
		time=(1:length(y))/fs;
		wObj=myAudioRead(waveFile);
		opt=endPointDetect('defaultOpt');
		opt.method='volZcr';
	%	epdPrm=epdPrmSet; epdPrm.method='volZcr';
		epByComputer=endPointDetect(wObj, opt, 1);	% �q���Хܤ����I
		h=findobj(0, 'type', 'uicontrol'); delete(h);	% Delete the UI controls
		userDataGet;
		epByHand=epByComputer;				% �H�u�Хܤ����I

		% �Y���I�w�g�Хܩ��ɦW�A�Хܺ��I��ϧ�
		[parentDir, mainName, extName]=fileparts(waveFile);
		index=find(mainName=='_');
		if length(index)>=2
			epByHand=[eval(mainName(index(end-1)+1:index(end)-1)), eval(mainName(index(end)+1:end))];
			% Update voiced plot
			voicedIndex=epByHand(1):epByHand(2);
			set(voicedH, 'xdata', voicedIndex/fs, 'ydata', y(voicedIndex));
			if length(voicedIndex)>1
				set(axes4H, 'xlim', [min(voicedIndex), max(voicedIndex)]/fs);
			end
		end

		axes(axes1H); limit=axis;
		titleStr=waveFile; titleStr=strrep(titleStr, '\', '/'); titleStr=strrep(titleStr, '_', '\_');
		title(titleStr);
		eraseMode='normal';	% 'xor' doesn't work under mac
		waveBarH(1)=line(epByHand(1)*[1 1]/fs, limit(3:4), 'linewidth', 2, 'color', 'r');
		waveBarH(2)=line(epByHand(2)*[1 1]/fs, limit(3:4), 'linewidth', 2, 'color', 'r');

		axes(axes2H); limit=axis;
		volBarH(1)=line(epByHand(1)*[1 1]/fs, limit(3:4), 'linewidth', 2, 'color', 'r');
		volBarH(2)=line(epByHand(2)*[1 1]/fs, limit(3:4), 'linewidth', 2, 'color', 'r');

		axes(axes3H); limit=axis;
		zcrBarH(1)=line(epByHand(1)*[1 1]/fs, limit(3:4), 'linewidth', 2, 'color', 'r');
		zcrBarH(2)=line(epByHand(2)*[1 1]/fs, limit(3:4), 'linewidth', 2, 'color', 'r');

		userDataSet;	
		% �]�w���s
		uicontrol('string', 'Play all', 'callback', [mfilename, ' playAll'], 'position', [50, 20, 100, 20]);
		uicontrol('string', 'Play detected', 'callback', [mfilename, ' playDetectedVoice'], 'position', [50+1*120, 20, 100, 20]);
		uicontrol('string', 'Save', 'callback', [mfilename, ' renameWaveFile'], 'position', [50+2*120, 20, 100, 20]);
		% �]�w�ƹ����s�Q���U�ɪ������ʧ@���uendPointLabel down�v
		set(gcf, 'WindowButtonDownFcn', [mfilename ' down']);
		set(gcf, 'WindowButtonMotionFcn', [mfilename ' move1']);
	case 'down', % ====== �ƹ����s�Q���U�ɪ��������O
		% �]�w�ƹ����ʮɪ��������O���uendPointLabel move�v
		set(gcf, 'WindowButtonMotionFcn', [mfilename, ' move2']);
		% �]�w�ƹ����s�Q����ɪ��������O���uendPointLabel up�v
		set(gcf, 'WindowButtonUpFcn', [mfilename ' up']);
		% �@�Q���U�A�Y���� endPointLabel move
		feval(mfilename, 'move');
	case 'move1', % ====== �ƹ����ʮɪ��������O�G�u���ܴ�ЧΪ�
		userDataGet;
		currPt=get(axes1H, 'CurrentPoint');
		xPos=currPt(1,1);
		yPos=currPt(1,2);
		limit=axis(axes1H);
		if (limit(1)<xPos & xPos<limit(2) & limit(3)<yPos & yPos<limit(4)) & (min(abs(epByHand/fs-xPos))<0.02)
			set(gcf, 'pointer', 'fleur');
		else
			set(gcf, 'pointer', 'arrow');
		end
	case 'move2', % ====== �ƹ����U�ò��ʮɪ��������O
		userDataGet;
		currPt=get(axes1H, 'CurrentPoint');
		xPos=currPt(1,1);
		yPos=currPt(1,2);
		limit=axis(axes1H);
		if (limit(1)<xPos & xPos<limit(2) & limit(3)<yPos & yPos<limit(4)) & strcmp(get(gcf, 'pointer'), 'fleur')
			[minDist, index]=min(abs(epByHand/fs-xPos));
			if index==1
				set(waveBarH(1), 'xdata', xPos*[1 1]);
				set(volBarH(1), 'xdata', xPos*[1 1]);
				set(zcrBarH(1), 'xdata', xPos*[1 1]);
				epByHand(1)=round(xPos*fs);
			else
				set(waveBarH(2), 'xdata', xPos*[1 1]);
				set(volBarH(2), 'xdata', xPos*[1 1]);
				set(zcrBarH(2), 'xdata', xPos*[1 1]);
				epByHand(2)=round(xPos*fs);
			end
			epByHand=sort(epByHand);
			voicedIndex=epByHand(1):epByHand(2);
			set(voicedH, 'xdata', voicedIndex/fs, 'ydata', y(voicedIndex));
			if length(voicedIndex)>1
				set(axes4H, 'xlim', [min(voicedIndex), max(voicedIndex)]/fs);
			end
			userDataSet;
		end
	case 'up', % ====== �ƹ����s�Q����ɪ��������O
		% �M���ƹ����ʮɪ��������O
		set(gcf, 'WindowButtonMotionFcn', [mfilename, ' move1']);
		% �M���ƹ����s�Q����ɪ��������O
		set(gcf, 'WindowButtonUpFcn', '');
		% Play voiced
		userDataGet;
		sound(y(voicedIndex), fs);
	case 'renameWaveFile',
		userDataGet;
		index=find(waveFile=='_');
		if length(index)>=2
			newWaveFile=sprintf('%s_%d_%d.wav', waveFile(1:index(end-1)-1), epByHand(1), epByHand(2));
		else
			newWaveFile=sprintf('%s_%d_%d.wav', waveFile(1:end-4), epByHand(1), epByHand(2));
		end
		if strcmp(waveFile, newWaveFile)~=1
			movefile(waveFile, newWaveFile);
		end 
		waveFile=newWaveFile;
		userDataSet;
	case 'playAll', % ====== play audio
		userDataGet;
		sound(y, fs);
	case 'playDetectedVoice', % ====== play audio
		userDataGet;
		sound(y(voicedIndex), fs);
end