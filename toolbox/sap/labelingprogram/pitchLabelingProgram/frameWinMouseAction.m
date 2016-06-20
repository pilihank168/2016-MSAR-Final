function frameWinMouseAction(action)
% This function is used in "frame2pitch4labeling".

if nargin<1, action='start'; end

switch(action)
	case 'start', % ====== �}�ҹϧε���
		% �]�w�ƹ����s�Q���U�ɪ������ʧ@
		set(gcf, 'WindowButtonDownFcn', [mfilename ' down']);
	case 'down', % ====== �ƹ����s�Q���U�ɪ��������O
		% �]�w�ƹ����ʮɪ��������O
		set(gcf, 'WindowButtonMotionFcn', [mfilename, ' move']);
		% �]�w�ƹ����s�Q����ɪ��������O
		set(gcf, 'WindowButtonUpFcn', [mfilename ' up']);
		% �@�Q���U�A�Y���� checkPitch move
		feval(mfilename, 'move');
	case 'move', % ====== �ƹ����ʮɪ��������O
		% ���o�������
		userDataGet;
		acfX=get(acfH, 'xdata');
		acfY=get(acfH, 'ydata');
		% ���o�ƹ��y��
		axes(acfAxisH);
		acfXLim=get(acfAxisH, 'xlim');
		currPt=get(gca, 'CurrentPoint');
		mouseX=currPt(1,1);
		mouseY=currPt(1,2);
		% ��s manualBarH
		if (acfXLim(1)<=mouseX) & (mouseX<=acfXLim(2))
			% ��X�Z���̪��I
		%	[minDist, pitchIndex]=min(abs(mouseX-acfX));
			localMaxIndex=find(localMaxPos);
			if ~isempty(localMaxIndex)
				[minDist, ind]=min(abs(mouseX-localMaxIndex));
				pitchIndex=localMaxIndex(ind);
			end
		else
			pitchIndex=0;
		end
		set(manualBarH, 'xdata', pitchIndex*[1 1]);
		% ��s mainWindow ����
		if pitchIndex==0,
			targetPitch(frameIndex)=0;
		else
			freq=ptOpt.fs/(pitchIndex-1);
			targetPitch(frameIndex)=freq2pitch(freq);
		end
		temp=targetPitch; temp(temp==0)=nan;
		set(targetPitchH, 'ydata', temp);
		userDataSet;
	case 'up', % ====== �ƹ����s�Q����ɪ��������O
		% �M���ƹ����ʮɪ��������O
		set(gcf, 'WindowButtonMotionFcn', '');
		% �M���ƹ����s�Q����ɪ��������O
		set(gcf, 'WindowButtonUpFcn', '');
end