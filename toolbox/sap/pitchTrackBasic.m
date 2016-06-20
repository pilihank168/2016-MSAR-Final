function [pitch, pitch0]=pitchTrackBasic(au, opt, showPlot)
% pitchTrackBasic: a simple pitch tracking method
%
%	Usage:
%		pitch=pitchTrackBasic(au)
%		pitch=pitchTrackBasic(au, opt)
%		pitch=pitchTrackBasic(au, opt, showPlot)
%
%	Description:
%		pitch=pitchTrackBaic(au, opt) return the pitch (in semitone) of an audio file by using basic frame-based PDF.
%
%	Example:
%		waveFile='soo.wav';
%		au=myAudioRead(waveFile);
%		au.tPitch=asciiRead('soo.pv');
%		opt=ptOptSet(au.fs, au.nbits, 1);
%		showPlot=1;
%		pitch=pitchTrackBasic(au, opt, showPlot);
%
%	See also pitchTrack.

%	Category: Pitch tracking
%	Roger Jang, 20150408

if nargin<1, selfdemo; return; end
if ischar(au) && strcmpi(au, 'defaultOpt')	% Set the default options
	pitch=ptOptSet;
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

if ischar(au), au=myAudioRead(au); end	% If the give au is a file name
au.signal=mean(au.signal, 2);	% Stereo to mono
y=au.signal; fs=au.fs;
y=y-mean(y);
frameSize=round(opt.frameDuration*fs/1000);
overlap=round((opt.frameDuration-opt.hopDuration)*fs/1000);
frameMat=enframe(y, frameSize, overlap);
frameNum=size(frameMat, 2);
pitch=zeros(1, frameNum);
for i=1:frameNum
	frame=frameMat(:, i);
	pitch(i)=frame2pitch(frame, opt);
end
volume=frame2volume(frameMat);
volumeTh=max(volume)/10;
pitch0=pitch;
%keyboard

if opt.medianFilterOrder>1
	pitch=medianFilter(pitch, opt.medianFilterOrder);
end
if opt.useVolThreshold
	pitch(volume<volumeTh)=nan;	% Volume-thresholded pitch
end

if showPlot
	frameTime=frame2sampleIndex(1:frameNum, frameSize, overlap)/fs;
	subplot(3,1,1);
	plot((1:length(y))/fs, y); set(gca, 'xlim', [-inf inf]);
	title('Waveform');
	subplot(3,1,2);
	plot(frameTime, volume, '.-'); set(gca, 'xlim', [-inf inf]);
	line([0, length(y)/fs], volumeTh*[1, 1], 'color', 'r');
	title('Volume');
	subplot(3,1,3);
	if ~isfield(au, 'tPitch')
		plot(frameTime,	 pitch0, '.-g' , frameTime, pitch, '.-k');
		title('Green: original pitch, black: volume-thresholded pitch');
	elseif isscalar(au.tPitch)
		plot(frameTime,	 pitch0, '.-g' , frameTime, pitch, '.-k');
		axisLimit=axis;
		line(axisLimit(1:2), au.tPitch*[1 1], 'color', 'r');
		title('Green: original pitch, black: volume-thresholded pitch, r: target pitch');
	else
		tPitch=au.tPitch;
		tPitch(tPitch==0)=nan;
		plot(frameTime, tPitch, 'or', frameTime, pitch0, '.-g', frameTime, pitch, '.-k');
		title('Green: original pitch, black: volume-thresholded pitch, r: target pitch');
	end
	axis tight; grid on
	xlabel('Time (second)'); ylabel('Semitone');
	% ====== Buttons for playback
	pitchObj.signal=pitch; pitchObj.frameRate=fs/(frameSize-overlap);
	if isfield(au, 'tPitch')
		tPitch=au.tPitch;
		if isscalar(tPitch)
			tPitch=pitch;
			tPitch(pitch>0)=au.tPitch;
		end
		pitchObj2.signal=tPitch; pitchObj2.frameRate=fs/(frameSize-overlap);
		buttonH=audioPitchPlayButton(au, pitchObj, pitchObj2);
		set(buttonH(end), 'string', 'Play GT pitch')
	else
		buttonH=audioPitchPlayButton(au, pitchObj);
	end
%	keyboard
%	set(gcf, 'name', sprintf('PT using ptByDpOverPfMex, with pfWeight=%d and indexDiffWeight=%d', ptOpt.pfWeight, ptOpt.indexDiffWeight));
%	set(gcf, 'name', sprintf('PT using mainFun=%s', ptOpt.mainFun));
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
