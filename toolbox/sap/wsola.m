function wObj2 = wsola(wObj, opt, plotOpt, animOpt)
% WSOLA: Waveform similiarity overlap and add
%
%	Usage:
%		wObj2 = wsola(wObj)
%		wObj2 = wsola(wObj, opt)
%		wObj2 = wsola(wObj, opt, plotOpt)
%		wObj2 = wsola(wObj, opt, plotOpt, animOpt)
%
%	Description:
%		wObj2=wsola(wObj, opt) return the wave object after duration modification using WSOLA.
%			wObj: Input wave object
%			opt: Options for WSOLA
%			wObj2: Output wave object
%		wsola(wObj, opt, plotOpt) plots the result if plotOpt=1.
%		wsola(wObj, opt, plotOpt, animOpt) shows the steps in WSOLA if animOpt=1.
%
%	Example:
%		% === Example 1: Lengthen the duration by a ratio of 3
%		opt=wsola('defaultOpt');
%		opt.druationRatio=3;			% �]�w�Ԫ����Y�u������
%		wObj=myAudioRead('what_movies_have_you_seen_recently.wav');
%		plotOpt=1;
%		wObj2=wsola(wObj, opt, plotOpt);
%		% === Example 2: Perform the animation to show steps in WSOLA
%		opt=wsola('defaultOpt');
%		wObj=myAudioRead('what_movies_have_you_seen_recently.wav');
%		wObj.signal=wObj.signal(0.17*wObj.fs:0.32*wObj.fs);	% Use only a short part for animation
%		plotOpt=1;
%		animOpt=1;
%		wObj2=wsola(wObj, opt, plotOpt, animOpt);
%
%	See also pitchShift.

%	Cheng-Yuan Lin 2005/07/16, modified by Roger Jang, 20120607, 20120910

if nargin<1, selfdemo; return; end
if nargin==1 && ischar(wObj) && strcmpi(wObj, 'defaultOpt')	% Set the default options
	wObj2.durationRatio=2;		% �]�w�Ԫ����Y�u������
	wObj2.frameDuration=0.01;	% �q�`�@��frame��10ms
	wObj2.searchRangeRatio=0.4;	% �]�w�j�M�d��, �q�`�OframeSize �� 0.4��
	wObj2.trim=0;
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, plotOpt=0; end
if nargin<4, animOpt=0; end
if ischar(wObj), wObj=myAudioRead(wObj); end	% wObj is actually the wave file name

y=wObj.signal;
fs=wObj.fs;
frameSize=round(opt.frameDuration*fs);	% Frame size for wsola
durationRatio=opt.durationRatio;
searchRange=round(frameSize*opt.searchRangeRatio);

if animOpt
	maxTime=max(length(y)*durationRatio, length(y))/fs;
	subplot(2,1,1); plot((1:length(y))/fs, y);
	title('Original (red: target frame, magenta: reference candidate frame, green: search zone, black: best candidate frame)');
	axis([0, maxTime, -1, 1]);
	subplot(2,1,2); waveH2=plot(nan, nan); title('Synthesized (black: currnt frame with half frame finished)');
	axis([0, maxTime, -1, 1]);
	xlabel('Time (sec)');
	boxH1=boxOverlay(nan*[1 1 1 1]);
	boxH2=boxOverlay(nan*[1 1 1 1]);
	boxH3=boxOverlay(nan*[1 1 1 1]);
	boxH4=boxOverlay(nan*[1 1 1 1]);
	boxH5=boxOverlay(nan*[1 1 1 1]);
end

% �]�whamming window 
w = hamming(frameSize);
halfFrameSize = round(frameSize/2);
w1 = w(1:halfFrameSize);
w2 = w(halfFrameSize+1 :end);

% �w���t�m�O����[�ֳt��
synWaveLen = round(length(y)*durationRatio);	% Length of the synthesized wave
synWave = zeros(synWaveLen, 1);

frameInsertPos = 1;	% The starting index for inserting a frame into synWave
tFrameStartId = 1;	% Target frame starts from tFrameStartId
lastFrameRight = y(tFrameStartId+(halfFrameSize+1:frameSize));	% Index of the right half frame
synWave(1:halfFrameSize) = y(1:halfFrameSize);		% Copy half frame from the orignal
if animOpt, set(waveH2, 'xData', (1:length(synWave))/fs, 'ydata', synWave); end

distance = zeros(1, 2*searchRange+1);	% Target �M Candidate Frame �� distance.
while frameInsertPos+frameSize-1<=synWaveLen
	if tFrameStartId+frameSize-1>length(y), tFrameStartId=length(y)-frameSize+1; end;	% If too long, move the start to fit the frame 
	tFrame = y(tFrameStartId:tFrameStartId+frameSize-1);	% Target frame in the original
	
	if animOpt, fprintf('Hit space to see the target frame...'); pause; fprintf('\n'); delete(boxH1); subplot(211); boxH1=boxOverlay([(tFrameStartId-0.5)/fs, -1, frameSize/fs, 2], 'r', 1); end
	
	rcFrameStartId = round(frameInsertPos/durationRatio);	% representative candidate frame start index, �̷Ӥ�Ҩӭp��
	rcFrameEndId=rcFrameStartId+frameSize-1;	% [rcFrameStartId:rcFrameEndId] is index into origWave
	if rcFrameEndId>length(y), break; end

	distance(1:end)=inf;
	for i=-searchRange:searchRange
		if rcFrameStartId+i<1; continue; end
		if rcFrameEndId+i>length(y); continue; end
		candidateFrame = y(rcFrameStartId+i:rcFrameEndId+i);
		distance(i+searchRange+1) = sum(abs(tFrame-candidateFrame));
	end
	[minDistance, idx] = min(distance);
	bestGap = idx-searchRange-1;
	bestFrame = y(rcFrameStartId+bestGap:rcFrameEndId+bestGap);
	synWave(frameInsertPos:frameInsertPos+halfFrameSize-1) = lastFrameRight.*w2+ bestFrame(1:halfFrameSize).*w1;

	if animOpt
		fprintf('Hit space to see the search zone and the best matched frame...'); pause; fprintf('\n');
		delete(boxH2); subplot(211); boxH2=boxOverlay([(rcFrameStartId-0.5)/fs, -0.95, frameSize/fs, 1.9], 'm', 1);
		delete(boxH3); subplot(211); boxH3=boxOverlay([(rcFrameStartId-searchRange-0.5)/fs, -1, (frameSize+2*searchRange)/fs, 2], 'g', 1);
		delete(boxH4); subplot(211); boxH4=boxOverlay([(rcFrameStartId+bestGap-0.5)/fs, -0.9, frameSize/fs, 1.8], 'k', 1);
		set(waveH2, 'xdata', (1:length(synWave))/fs, 'ydata', synWave); 
		delete(boxH5); subplot(212); boxH5=boxOverlay([(frameInsertPos-0.5)/fs, -0.9, frameSize/fs, 1.8], 'k', 1);
	end
	
	frameInsertPos = frameInsertPos+halfFrameSize;
	tFrameStartId = rcFrameStartId+bestGap+halfFrameSize;		% �U�@�� target frame �� tFrameStartId
	lastFrameRight = bestFrame(halfFrameSize+1:end);
%	fprintf('rcFrameStartId=%d, tFrameStartId=%d, frameInsertPos=%d\n', rcFrameStartId, tFrameStartId, frameInsertPos);
end

% �H�U�װŬOoptional ���p�n�����׫ܵu, �ӥB�n�s����L�n�����ɭ�..��ĳ�n��, �_�h�|���ɭ� (This needs to be double checked!!!)
if opt.trim
   LastFramePos = frameInsertPos-halfFrameSize;
   for k = 1 : frameSize, %�Ĥ@����
      if (synWave(k)<0 && synWave(k+1)>0),
         synWave(1:k) = 0;
         break;
      end;
   end;
   for k = LastFramePos : -1 : LastFramePos-frameSize, %�̫᭵��
      if (synWave(k)>0 && synWave(k-1)<0),
         synWave(k:LastFramePos) = 0;
         break;
      end;
   end;
end;

wObj2=wObj; wObj2.signal=synWave;	% Assign to the output

if plotOpt
	maxTime=max(length(wObj.signal)/wObj.fs, length(wObj2.signal)/wObj2.fs);
	subplot(2,1,1); plot((1:length(wObj.signal))/wObj.fs, wObj.signal); title('Original');
	axis([0, maxTime, -1, 1]);
	audioPlayButton(wObj);
	subplot(2,1,2); plot((1:length(wObj2.signal))/wObj2.fs, wObj2.signal); title('Synthesized');
	axis([0, maxTime, -1, 1]);
	xlabel('Time (sec)');
	audioPlayButton(wObj2);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
