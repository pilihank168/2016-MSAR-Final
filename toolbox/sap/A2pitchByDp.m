function [pitch, A]=A2pitchByDp(A, fs, ptOpt)
% vowel2pitchByDp: �Q�� DP ����k�ӧ�X�̨Ϊ��������u
%	Usage: [pitch, A]=A2pitchByDp(A, fs, ptOpt)

%	Roger Jang, 20050228

if nargin<2, fs=8000; end
if nargin<3, ptOpt=ptOptSet(fs, nbits); end

% Generate the table from ppcIndex to pitch (which is integer)
% This table is used in DP
index2pitch=round(10*freq2pitch(ptOpt.fs./(1:ptOpt.frameSize/2-1)));		% ���H 10 �H�᪺��ƭ����ȡI
index2pitch=[0, index2pitch];

frameNum=length(A);

% ====== �ھ� A �}�l�i�� dynamic programming
% ====== �Ĥ@�C
ppcNum=length(A(1).ppc);
for j=1:ppcNum
	A(1).ppc(j).totalDist = ptOpt.amdfWeight*A(1).ppc(j).amdfValue;
	A(1).ppc(j).from = -1;
end
% ====== ��L�C	
for i=2:frameNum
%	fprintf('i=%d/%d\n', i, frameNum);
	for j=1:length(A(i).ppc)
		minDist = inf;
		for k=1:length(A(i-1).ppc)
			if ptOpt.dpMethod==1
				indexDiff=abs(A(i-1).ppc(k).index-A(i).ppc(j).index);
				if ptOpt.dpPosDiffOrder==1
					thisDist = A(i-1).ppc(k).totalDist+ptOpt.indexDiffWeight*(indexDiff);
				else
					thisDist = A(i-1).ppc(k).totalDist+ptOpt.indexDiffWeight*(indexDiff*indexDiff);
				end
			else
				pitchDiff=abs(index2pitch(A(i-1).ppc(k).index)-index2pitch(A(i).ppc(j).index));
				if ptOpt.dpPosDiffOrder==1
					thisDist = A(i-1).ppc(k).totalDist+ptOpt.indexDiffWeight*(pitchDiff);
				else
					thisDist = A(i-1).ppc(k).totalDist+ptOpt.indexDiffWeight*(pitchDiff*pitchDiff);
				end
			end
			if thisDist < minDist
				minDist = thisDist;
				A(i).ppc(j).from = k;
			end
		end
		A(i).ppc(j).totalDist = minDist + ptOpt.amdfWeight*A(i).ppc(j).amdfValue;

%		if j==2
%			keyboard
%		end

	end
end
	
% ====== ��X�̫�@�C���̤p��
minDist = inf;
i=frameNum;
for j = 1:length(A(i).ppc)
	if A(i).ppc(j).totalDist<minDist
		minDist = A(i).ppc(j).totalDist;
		minIndex = j;
	end
end
	
% ====== �d�X�̨θ��|�� pitch period
for i=frameNum:-1:1
	A(i).pp = A(i).ppc(minIndex).index;
	minIndex = A(i).ppc(minIndex).from;
end

% ====== �ন semitone
for i = 1:frameNum
	pitch(i) = 69+12*log2(fs/(A(i).pp-1)/440);
end