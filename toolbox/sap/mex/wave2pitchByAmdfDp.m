function [pitch, volume, volTh, amdfMat, A]=wave2pitchByAmdfDp(y, fs, nbits, PP, plotOpt)
% wave2pitchByDp: �Q�� DP ����k�ӧ�X�̨Ϊ��������u
%	Usage: [pitch, amdfMat, A]=wave2pitchByDp(y, fs, nbits, PP, plotOpt)
%
%	�o�O�@��²�ƪ������A���]�e�i�Ӫ�y���O���n���������]���������^�A�ĪG�|����n
%	�p�G�e�i�Ӫ� wave �䤤�����@�ӭ��بS�������Aamdf �i�ण�X�{ local min.�A����ƱN�|���q�i�� DP�C
%	���~�A����ƪ����G�|�ھ� PP.indexDiffWeight �Ӧ����P�����G�A�̦n���g�j�q���աA���o���Ѽƪ��̨έȡC

%	Roger Jang, 20050228, 20051019

if nargin<1, selfdemo; return; end
if nargin<2, fs=8000; end
if nargin<3, nbits=8; end
if nargin<4, PP=ptOptSet(fs, nbits); end
if nargin<5, plotOpt=0; end

frameMat=buffer2(y, PP.frameSize, PP.overlap);
volume=frame2volume(frameMat);
volTh=max(volume)/10;
amdfMat=frameMat2amdfMat(frameMat, PP.frameSize/2, 3);
[amdfLen, frameNum]=size(amdfMat);
if frameNum==1, error('Error: Need at least two frames!'); end

% ���� A ���c�A�O���C�@�ӭ��ت� PPC
for i=1:frameNum
	% ====== �p��C�@�ӭ��ت� PPC (Pitch Period Candidate)
	[ppcIndex, ppcValue] = amdf2ppc(amdfMat(:,i), fs, nbits, PP);		% ppcValue �M amdf(ppcIndex) �i�ण�P�A�]���i��g�L���W�ഫ���ק�
	% ====== �x�s��Ʃ� A ���c
	A(i).ppcLen=length(ppcIndex);
	for j = 1:length(ppcIndex)
		A(i).ppc(j).index = ppcIndex(j);
		A(i).ppc(j).amdfValue = ppcValue(j);
		A(i).ppc(j).totalDist=0;
		A(i).ppc(j).from=-1;
		A(i).pp=0;
	end
end

% ���i����q�A�A��C�q�ϥ� DP �i�歵���l��
headPos = 1;
pitch = zeros(1, frameNum);
while headPos < frameNum
	while A(headPos).ppcLen == 0
		headPos = headPos + 1;
		if headPos == frameNum
			break;
		end
	end
	
	tailPos = headPos;
	while A(tailPos).ppcLen ~= 0
		tailPos = tailPos + 1;
		if tailPos == frameNum + 1
			break;
		end
	end
	
	range=headPos:tailPos-1;
	if length(range)>0
		[pitch(range), A(range)]=A2pitchByDp(A(range), fs, PP);
	end
	
	headPos = tailPos;
end

% �N A �g�J�ɮ�
%fid=fopen('a2.txt', 'w');
%for i=1:frameNum
%	fprintf(fid, 'A[%d].ppcLen=%d\n', i, A(i).ppcLen);
%	for j=1:A(i).ppcLen
%		fprintf(fid, '\tppc[%d]: amdfValue=%d, totalDist=%d, from=%d, index=%d\n', j, A(i).ppc(j).amdfValue, A(i).ppc(j).totalDist, A(i).ppc(j).from, A(i).ppc(j).index);
%	end	
%end
%fclose(fid);

pitch2=pitch;
if PP.useEpd
	pitch(volume<volTh)=0;		% �u�O�d�����q������
end

if plotOpt
	plotNum=4;
	frameTime=frame2sampleIndex(1:frameNum, PP.frameSize, PP.overlap)/fs;
	% ====== Plot wave
	waveAxisH=subplot(plotNum,1,1);
	time=(1:length(y))/fs;
	waveH=plot(time, y-mean(y));
	set(gca, 'xlim', [min(time), max(time)]);
	ylabel('Waveform');
	lFrameH=line(nan*[1 1], get(waveAxisH, 'ylim'), 'erase', 'xor', 'color', 'r');
	rFrameH=line(nan*[1 1], get(waveAxisH, 'ylim'), 'erase', 'xor', 'color', 'r');
	% ====== Plot volume
	subplot(plotNum,1,2);
	plot(frameTime, volume, '.-'); ylabel('Volume'); grid on;
	set(gca, 'xlim', [min(frameTime), max(frameTime)]); set(gca, 'ylim', [-inf inf]);
	line([min(frameTime), max(frameTime)], volTh*[1 1], 'color', 'r');
	% ====== Plot AMDF map
	subplot(plotNum,1,3);
	amdfPlot(amdfMat, frameTime, A); ylabel('AMDF matrix');
	barH(3)=line(nan*[1 1], get(gca, 'ylim'), 'erase', 'xor', 'color', 'r');
	% ====== Plot the final pitch
	subplot(plotNum,1,4);
	temp=pitch; temp(temp==0)=nan;
	temp2=pitch2; temp2(temp2==0)=nan;
	plot(frameTime, temp2, '.-', frameTime, temp, 'ro'); ylabel('Final pitch'); grid on;
	set(gca, 'xlim', [min(frameTime), max(frameTime)]); set(gca, 'ylim', [-inf inf]);
	barH(5)=line(nan*[1 1], get(gca, 'ylim'), 'erase', 'xor', 'color', 'r');
	% ====== Buttons for playback
	waveObj.signal=y-mean(y); waveObj.fs=fs; waveObj.nbits=nbits;
	pitchObj.signal=pitch; pitchObj.frameRate=fs/(PP.frameSize-PP.overlap);
	buttonH=audioPitchPlayButton(waveObj, pitchObj);
	% ====== For displaying frame2ppc
%	userDataSet;
%	set(gcf, 'WindowButtonDownFcn', 'DpWindowButtonDownFcn');
end

% ====== Selfdemo
function selfdemo
waveFile='lately2.wav';		% 16 kHz, 16 bits
waveFile='�����s�����N�b.wav';
[y, fs, nbits]=wavReadInt(waveFile);
PP=ptOptSet(fs, nbits);
PP.useEpd=1;
PP.indexDiffWeight=10000;
%frameRange=[97, 134];		% Voiced range
%sampleRange=frame2sampleRange(frameRange, 512, 512-160);
%y=y(sampleRange(1):sampleRange(2));	% Voiced part
[pitch, amdfMat, A]=feval(mfilename, y, fs, nbits, PP, 1);
%save pitch pitch PP