function localMinIndex=amdf2ppc(amdf, ppcNum, plotOpt)
% amdf2ppc: AMDF to pitch period candidates (PPC)

%	Roger Jang, 20040524

if nargin<1, selfdemo; return; end
if nargin<2, ppcNum=8; end
if nargin<3, plotOpt=0; end

fs=8000;
origAmdf=amdf;
maxValue=max(amdf);
%amdf(1:7)=maxValue;	% �e 7 �I�����Ҽ{ local minima
%minValue=min(amdf);
%range=maxValue-minValue;

localMinIndex=find(localMax(-amdf));
localMinIndex(1)=[];	% �Ĥ@�I���Ҽ{
if localMinIndex(end)==length(amdf)
	localMinIndex(end)=[];	% �̫�@�I�p�G�O amdf ���̫�@�I�A�]���Ҽ{
end
localMinValue=amdf(localMinIndex);
[junk, index]=sort(localMinValue);
if length(index)>ppcNum
	threshold=localMinValue(index(ppcNum));
	index=find(localMinValue<=threshold);
	localMinValue=localMinValue(index);
	localMinIndex=localMinIndex(index);
end

if plotOpt
	plot(amdf, '.-');
	set(gca, 'xlim', [-inf inf]);
	title('Pitch period candidates from AMDF');
	line(localMinIndex, localMinValue, 'color', 'r', 'marker', 'o', 'linestyle', 'none');
	grid on;
end

% ====== Self demo
function selfdemo
waveFile='../spce4singing/waveData/cweb/frida_faraway/this old man.wav';
%waveFile='waveData/cweb/roger_faraway/the more we get together.wav';
%waveFile='../spce4singing/waveData/cweb/beball/the more we get together.wav';
waveFile='mountain.wav';
[y, fs, nbits]=wavread(waveFile);
y=y*2^nbits/2;
framedY=buffer(y, 256, 0);
frameIndex=100;
frame=framedY(:, frameIndex);
frame2=frameFlip(frame);
frame3=localAverage(frame2);
amdf=frame2amdf(frame3, 128);
plotOpt=1;
ppcNum=5;
feval(mfilename, amdf, ppcNum, plotOpt);
xlabel(sprintf('Frame %d of "%s"', frameIndex, waveFile));