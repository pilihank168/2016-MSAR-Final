function [pitch, A, path]=frame2pitchByDp(framedY, fs, plotOpt, PP)
% frame2pitchByDp: �Q�� DP ����k�ӧ�X�̨Ϊ��������u
%	Usage: [pitch, A, path]=frame2pitchByDp(framedY, fs, plotOpt, PP)

%	Roger Jang, 20040524

if nargin<1, selfdemo; return; end
if nargin<2, fs=8000; end
if nargin<3, plotOpt=0; end
if nargin<4, PP=setPitchPrm4dp; end

[frameSize, frameNum]=size(framedY);
ppcNum=PP.ppcNum;
ppcIndexDiffWeight=PP.ppcIndexDiffWeight;

% ====== �p��C�@�ӭ��ت� PPC (Pitch Period Candidate)
for i=1:frameNum
	frame=framedY(:,i);
	frame2=frameFlip(frame);
	frame3=localAverage(frame2);
	amdf=frame2amdf(frame3);
	ppcIndex=amdf2ppc(amdf, ppcNum);
	for j=1:length(ppcIndex)
		A(i).ppc(j).index=ppcIndex(j);
		A(i).ppc(j).amdfValue=amdf(ppcIndex(j));
		A(i).ppc(j).pitch=freq2pitch(fs/(A(i).ppc(j).index-1));
	end
end

% ====== �}�l�i�� dynamic programming
%fprintf('Computing DP table...\n');
% �p��Ĥ@�C
i=1;
for j=1:length(A(i).ppc)
	A(i).ppc(j).totalDist=0;
	A(i).ppc(j).from=[];
end
% �p��䥦�U�C
for i=2:frameNum
	for j=1:length(A(i).ppc)
		minDist=inf;
		for k=1:length(A(i-1).ppc)
			thisDist=A(i-1).ppc(k).totalDist+...
				ppcIndexDiffWeight*abs(A(i-1).ppc(k).index-A(i).ppc(j).index)+...
				A(i).ppc(j).amdfValue;
			if thisDist<minDist
				minDist=thisDist;
				A(i).ppc(j).from=[i-1, k]';
			end
		end
		A(i).ppc(j).totalDist=minDist;
	end
end

% ��X�̫�@�C���̤p��
[minDist, minIndex]=min([A(end).ppc.totalDist]);
% Back tracking �H��X�̨θ��|
i=frameNum;
j=minIndex;
path=[i; j];
while ~isempty(A(i).ppc(j).from)
	from=A(i).ppc(j).from;
	path=[from, path];
	i=from(1);
	j=from(2);
end

% �d�X�̨θ��|�� pitch
pitch=[];
for i=1:size(path,2)
	p=path(1,i);
	q=path(2,i);
	pitch=[pitch, A(p).ppc(q).pitch];
end

if plotOpt, plot(1:length(pitch), pitch, 'o-'); end

% ====== Self demo
function selfdemo
waveFile='mountain.wav';
[y, fs, nbits]=wavread(waveFile);
y=y*2^nbits/2;
frameSize=256;
overlap=0;
framedY=buffer(y, frameSize, overlap);
frameNum=size(framedY, 2);
volume=sum(abs(framedY));
voicedIndex=find(volume>frameSize*3);
startIndex=voicedIndex(1);
endIndex=voicedIndex(end);
framedY2=framedY(:, startIndex:endIndex);
plotOpt=1;
[pitch, A, path]=feval(mfilename, framedY2, fs, plotOpt);
computed=zeros(1, frameNum);
computed(startIndex:endIndex)=pitch;

load mountain.pitch
desired=mountain;
plot(1:frameNum, computed, 'o', 1:frameNum, desired, '.');
legend('Computed pitch', 'Desired pitch');