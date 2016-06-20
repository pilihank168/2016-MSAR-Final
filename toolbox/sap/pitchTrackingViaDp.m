clear all; close all
addpath ../spce4singing

waveFile='../spce4singing/waveData/cweb/frida_faraway/this old man.wav';
waveFile='../spce4singing/waveData/cweb/roger_faraway/the more we get together.wav';
waveFile='../spce4singing/waveData/cweb/beball/the more we get together.wav';
waveFile='../spce4singing/waveData/cweb/frida/the more we get together_ta.wav';
waveFile='../spce4singing/waveData/cweb/roger/the more we get together.wav';
%waveFile='../spce4speech/waveData/frida/Does it make sense to let children play with matches_70.wav';
[PP, CP]=setPrm;
PP.duration=15;
plotOpt=1;
[pitch0, volume, PP] = wave2pitchVolume(waveFile, PP.duration, plotOpt, PP);

[y, fs, nbits]=waveFileRead(waveFile);
framedY=buffer2(y, PP.frameSize, PP.overlap);
frameNum=size(framedY,2);
amdfMat=[];
probMap=[];

% ====== �p�� state probability
for i=1:frameNum
	frame=framedY(:,i);
	volume(i)=frame2volume(frame);
	frame2=frameFlip(frame);
	frame3=localAverage(frame2);
	amdf=frame2amdf(frame3);
	A(i).candidate=amdf2pitchCandidate(amdf);
	amdfMat=[amdfMat, amdf];
	prob=(max(amdf)-amdf)/max(amdf);
	prob(prob==0)=eps;
	prob=log(prob/sum(prob));
	probMap=[probMap, prob];
end
volumeThreshold=getVolumeThreshold(volume);
lowVolIndex=find(volume<volumeThreshold);
%A(lowVolIndex)=[];
%pitch0(lowVolIndex)=[];
%amdfMat(:, lowVolIndex)=[];
%probMap(:, lowVolIndex)=[];

% ====== �p�� transition probability
sigma=5;
fprintf('Computing transition probability...\n');
for i=1:length(A)-1
	for j=1:length(A(i).candidate)
		targetLen=length(A(i+1).candidate);
		indexDiff=zeros(targetLen, 1);
		for k=1:targetLen
			indexDiff(k)=abs(A(i).candidate(j).index-A(i+1).candidate(k).index);
		end
		prob=exp(-(indexDiff/sigma).^2);
		prob=log(prob/sum(prob));
		for k=1:targetLen
			A(i).candidate(j).transProb(k)=prob(k);
		end
	end
end

% ====== �}�l�i�� dynamic programming
fprintf('Computing DP table...\n');
% �p��Ĥ@�C
i=1;
for j=1:length(A(i).candidate)
	A(i).candidate(j).cumProb=A(i).candidate(j).stateProb;
	A(i).candidate(j).from=[];
end
% �p��䥦�U�C
for i=2:frameNum
	for j=1:length(A(i).candidate)
		maxProb=-inf;
		for k=1:length(A(i-1).candidate)
			thisProb=A(i-1).candidate(k).cumProb+A(i-1).candidate(k).transProb(j)+A(i).candidate(j).stateProb;
			if thisProb>maxProb
				maxProb=thisProb;
				A(i).candidate(j).from=[i-1, k]';
			end
%			if i==2 & j==2; keyboard; end
		end
		A(i).candidate(j).cumProb=maxProb;
	end
end

% ��X�̫�@�C���̤j��
[maxProb, maxIndex]=max([A(end).candidate.cumProb]);
% Back tracking �H��X�̨θ��|
i=frameNum;
j=maxIndex;
path=[i; j];
while ~isempty(A(i).candidate(j).from)
	from=A(i).candidate(j).from;
	path=[from, path];
	i=from(1);
	j=from(2);
end

% �d�X�̨θ��|�� pitch
pitch=[];
for i=1:size(path,2)
	p=path(1,i);
	q=path(2,i);
	pitch=[pitch, A(p).candidate(q).pitch];
end
figure; plot(1:length(pitch0), pitch0, '.-', 1:length(pitch), pitch, 'o-');

% ��X�̨θ��|���y��
x=[];
y=[];
for i=1:size(path,2)
	p=path(1,i);
	q=A(i).candidate(path(2,i)).index;
	x=[x, p];
	y=[y, q];
end

% �e�X amdfMat
figure; imagesc(amdfMat); colorbar; axis xy; title('amdfMat');
line(x, y, 'color', 'w', 'marker', 'o');
% �e�X�Ҧ��� local minima
for i=1:length(A)
	for j=1:length(A(i).candidate)
		line(i, A(i).candidate(j).index, 'color', 'k', 'marker', '.', 'linestyle', 'none'); 
	end
end
% �e�X probMap w.r.t. index
figure; imagesc(probMap); colorbar; axis xy; title('probMap w.r.t. index');
line(x, y, 'color', 'w', 'marker', 'o');
% �e�X�Ҧ��� local minima
for i=1:length(A)
	for j=1:length(A(i).candidate)
		line(i, A(i).candidate(j).index, 'color', 'k', 'marker', '.', 'linestyle', 'none'); 
	end
end
% �e�X probMap w.r.t. pitch
pitchIndex=1:size(probMap,1);
frameIndex=1:size(probMap,2);
pitchIndex=freq2semitone(8000./(pitchIndex-1));
figure;
surf(pitchIndex, frameIndex, probMap'); view([-90, 90]); shading flat; title('probMap w.r.t. pitch');
xlabel('Frame index'); ylabel('Pitch');
return
line(x, y, 'color', 'w', 'marker', 'o');
% �e�X�Ҧ��� local minima
for i=1:length(A)
	for j=1:length(A(i).candidate)
		line(i, A(i).candidate(j).index, 'color', 'k', 'marker', '.', 'linestyle', 'none'); 
	end
end