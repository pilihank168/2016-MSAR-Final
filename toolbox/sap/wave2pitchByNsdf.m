function [pitch, clarity]=wave2pitchByNsdf(y, ptOpt, plotOpt)
% wave2pitchByNsdf: �Q�� NSDF ����k�ӧ�X�������u
%	Usage: [pitch, clarity]=wave2pitchByNsdf(y, ptOpt, plotOpt)

%	Roger Jang, 20070210

if nargin<1, selfdemo; return; end
if nargin<3, plotOpt=0; end

if ischar(y)	% y is a wave file
	[y, fs, nbits]=wavReadInt(y);
	if fs~=ptOpt.fs | nbits~=ptOpt.nbits
		error('ptOpt is not conformed to the give wave file!');
	end
end

frameMat=buffer2(y, ptOpt.frameSize, ptOpt.overlap);
frameNum=size(frameMat, 2);
pitch=zeros(frameNum, 1);
clarity=zeros(frameNum, 1);
for i=1:frameNum
	frame=frameMat(:, i);
	[pitch(i), clarity(i)]=frame2pitchByNsdf(frame, ptOpt);
end

volume=frame2volume(frameMat);
volTh=max(volume)/10;
pitch2=pitch;
if ptOpt.useEpd
	pitch(volume<volTh)=0;		% �u�O�d�����q������
end
pitch(clarity<ptOpt.clarityTh)=0;

if plotOpt
	subplot(4,1,1);
	time=(1:length(y))/ptOpt.fs;
	plot(time, y); axis tight; title('Waveform');
	subplot(4,1,2);
	frameTime=frame2sampleIndex(1:length(pitch), ptOpt.frameSize, ptOpt.overlap)/ptOpt.fs;
	plot(frameTime, volume, '.-b'); title('Volume');
	line([min(frameTime), max(frameTime)], volTh*[1 1], 'color', 'r');
	subplot(4,1,3);
	plot(frameTime, clarity, '.-'); axis([-inf inf -inf inf]); grid on
	line([min(frameTime), max(frameTime)], ptOpt.clarityTh*[1 1], 'color', 'r'); title('Clarity');
	subplot(4,1,4);
	tempPitch1=pitch; tempPitch1(pitch==0)=nan;
	tempPitch2=pitch2; tempPitch2(pitch2==0)=nan; 
	plot(frameTime, tempPitch2, 'o-g', frameTime, tempPitch1, '.-k'); axis([-inf inf -inf inf]); grid on; title('Pitch');
end

% ====== Selfdemo
function selfdemo
waveFile='soo.wav';
waveFile='comeOn.wav';
waveFile='�Ⱖ�Ѫ�.wav';
waveFile='twinkle_twinkle_little_star.wav';
waveFile='�p���j.wav';
[y, fs, nbits]=wavReadInt(waveFile);
ptOpt=ptOptSet(fs, nbits);
ptOpt.useEpd=1;
plotOpt=1;
tic
[pitch, clarity]=wave2pitchByNsdf(y, ptOpt, plotOpt);
fprintf('Time = %g sec\n', toc);