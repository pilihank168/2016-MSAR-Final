function [pitch, clarity, pfMat, maxPitchDiff, pitch2]=pitchTrack(au, ptOpt, showPlot)
% pitchTrack: pitch tracking for a given file
%
%	Usage:
%		[pitch, clarity]=pitchTrack(auFile, ptOpt, showPlot)
%
%	Example:
%		% === Example of singing input
%		auFile='yankee_doodle.wav';
%		auFile='twinkle_twinkle_little_star.wav';
%	%	auFile='10LittleIndians.wav';	% Noisy!
%		au=myAudioRead(auFile);
%		ptOpt=ptOptSet(au.fs, au.nbits);
%		pitch=pitchTrack(au, ptOpt, 1);
%		% === Example of speech
%		auFile='what_movies_have_you_seen_recently.wav';
%		au=myAudioRead(auFile);
%		pfType=1;	% 0 for AMDF, 1 for ACF
%		ptOpt=ptOptSet(au.fs, au.nbits, pfType);
%		ptOpt.frameSize=640; ptOpt.overlap=640-160;		% frameSize is twice of that of HTK, with frame rate=100 to match HTK
%		figure; [pitch, clarity, pfMat]=pitchTrack(au, ptOpt, 1);
%		% === Example with mainFun = 'maxPickingOverPf'
%		auFile='twinkle_twinkle_little_star.wav';
%		au=myAudioRead(auFile);
%		pfType=1;	% 0 for AMDF, 1 for ACF
%		ptOpt=ptOptSet(au.fs, au.nbits, pfType);
%		ptOpt.mainFun='maxPickingOverPf';
%		showPlot=1;
%		figure; [pitch, clarity]=pitchTrack(au, ptOpt, showPlot);
%		% === Another example without pitch groundtruth
%		auFile='soo.wav';
%		au=myAudioRead(auFile);
%		pfType=1;		% 0 for AMDF, 1 for ACF
%		ptOpt=ptOptSet(au.fs, au.nbits, pfType);
%		ptOpt.mainFun='maxPickingOverPf';
%		ptOpt.usePitchSmooth=0;
%		showPlot=1;
%		figure; [pitch, clarity]=pitchTrack(au, ptOpt, showPlot);

%	Roger Jang, 20090810, 20121008

if nargin<1, selfdemo; return; end
if ischar(au), au=myAudioRead(au); end	% au is actually the wave file name
if nargin<2 || isempty(ptOpt), ptOpt=ptOptSet(au.fs, au.nbits); end
if nargin<3, showPlot=0; end
if au.fs~=ptOpt.fs || au.nbits~=ptOpt.nbits
	error('au.fs=%d, ptOpt.fs=%d, , au.nbits=%d, ptOpt.nbits=%d, ptOpt is not conformed to the given wave object!', au.fs, ptOpt.fs, au.nbits, ptOpt.nbits);
end

% Make au.signal integer for ptByDpOverPfMex
if au.amplitudeNormalized
	au.signal=au.signal*2^(au.nbits-1);
	au.amplitudeNormalized=0;
end

% Stereo ==> Mono
if size(au.signal, 2)>1, au.signal=mean(au.signal, 2); end

if ptOpt.useWaveEnhancement
	fprintf('\t\t\tPerform speech enhancement...\n');
	au.signal=specSubtractMex(au.signal, au.fs);
end

if ptOpt.useHighPassFilter
	fprintf('\t\t\tPerform high-pass filtering...\n');
	cutOffFreq=100;		% Cutoff frequency
	filterOrder=5;		% Order of filter
	[b, a]=butter(filterOrder, cutOffFreq/(au.fs/2), 'high');
	au.signal=filter(b, a, au.signal);
end

if ptOpt.useLowPassFilter
	fprintf('\t\t\tPerform low-pass filtering...\n');
	cutOffFreq=500;		% Cutoff frequency
	filterOrder=5;		% Order of filter
	[b, a]=butter(filterOrder, cutOffFreq/(au.fs/2), 'low');
	au.signal=filter(b, a, au.signal);
end

y=au.signal; fs=au.fs; nbits=au.nbits;
% ====== Pitch tracking
switch(ptOpt.mainFun)
	case 'dpOverPfMat'
	%	[pitch, clarity, pfMat]=ptByDpOverPfMex(au, ptOpt);
		[pitch, clarity, pfMat, dpPath]=ptByDpOverPfMex(y, fs, nbits, ptOpt);
		pitch2=pitch;	% Keep pitch2 for plotting
	case 'maxPickingOverPf'
		frameMat=enframe(y, ptOpt.frameSize, ptOpt.overlap);
		frameMat=frameZeroMean(frameMat, ptOpt.zeroMeanPolyOrder);
		frameNum=size(frameMat, 2);
		pitch=zeros(1, frameNum); clarity=zeros(1, frameNum); lMaxCount=zeros(1, frameNum);
		for i=1:frameNum
			frame=frameMat(:, i);
			[pitch(i), clarity(i), pitchIndex, pf]=frame2pitch2(frame, ptOpt);	% This should by changed to frame2pitch()!
			lMaxCount(i)=sum(localMax(pf));
		end
		pitch2=pitch;	% Keep pitch2 for plotting
		% ===== Remove pitch with low volume
		if ptOpt.useVolThreshold
			epdPrm=endPointDetect('defaultOpt');
			epdPrm.frameDuration=ptOpt.frameSize/ptOpt.fs;
			epdPrm.overlapDuration=ptOpt.overlap/ptOpt.fs;	
			epdPrm.method='vol';
			[epInSampleIndex, epInFrameIndex, segment, zeroOneVec, others]=endPointDetect(au, epdPrm);
			volume=others.volume; volTh=others.volTh;
%			[epInSampleIndex, epInFrameIndex, segment, zeroOneVec, volume, volTh]=epdByVol(y, ptOpt.fs, ptOpt.nbits, epdPrm);
			pitch=pitch.*zeroOneVec;
		end
		% ===== Remove pitch with low clarity
		if ptOpt.useClarityThreshold
			clarityTh=ptOpt.clarityRatio*max(clarity);
			pitch(clarity<clarityTh)=0;
		end
		% ====== Remove pitch with high pf local max count
		if ptOpt.localMaxCountThresholding
			lMaxCountTh=ptOpt.localMaxCountRatio*max(lMaxCount);
			pitch(lMaxCount>lMaxCountTh)=0;
		end
		% ====== Smooth pitch
		if ptOpt.usePitchSmooth
			pitch=pitchSmooth(pitch);
		end
	otherwise
		error('Unknown method "%s" in pitchTrack()!', ptOpt.mainFun);
end

% ====== SU/V detection via HMM
if ptOpt.useHmm4suvDetection
	fprintf('\t\t\tPerform SU/V detection via HMM...\n');
	load pitchExist/gmmData.mat
	load pitchExist/transProb.mat
	transLogProb=log(transProb);
	gmmSet=gmmData(index);
	suvParam=suvParamSet;
	suv=wave2suv(au, suvParam, gmmSet, transLogProb);
	pitch=pitch.*(suv'-1);
end

if nargout>=4
	segment=segmentFind(pitch);
	segmentNum=length(segment);
	segmentPitchDiff=zeros(1,segmentNum);
	for i=1:segmentNum
		if segment(i).duration>1
			segmentPitchDiff(i)=max(abs(diff(pitch(segment(i).begin:segment(i).end))));
		end
	end
	maxPitchDiff=max(segmentPitchDiff);
end

%{
frameMat=enframe(y, ptOpt.frameSize, ptOpt.overlap);
frameMat=frameZeroMean(frameMat, 2);
frameNum=size(frameMat, 2);
clarity=frame2clarity(frameMat, fs, 'acf', 1);
%}
[maxClarity, maxIndex]=max(clarity);
clarityTh=ptOpt.clarityRatio*maxClarity;
%fprintf('maxClarity=%f, clarityTh=%f\n', max(clarity), clarityTh);
%pitch=pitch.*(clarity>clarityTh);

if showPlot
	plotNum=2;
	if strcmp(ptOpt.mainFun, 'dpOverPfMat'), plotNum=plotNum+1; end
	if ptOpt.useVolThreshold, plotNum=plotNum+1; end
	if ptOpt.useClarityThreshold, plotNum=plotNum+1; end
	if ptOpt.localMaxCountThresholding, plotNum=plotNum+1; end
	plotId=0;
	frameNum=floor((length(y)-ptOpt.overlap)/(ptOpt.frameSize-ptOpt.overlap));
	frameTime=frame2sampleIndex(1:frameNum, ptOpt.frameSize, ptOpt.overlap)/fs;

	plotId=plotId+1; subplot(plotNum, 1, plotId);
	time=(1:length(y))/fs;
	plot(time, y); axis([min(time) max(time) 2^nbits/2*[-1 1]]);
	if ~isempty(au.file), title(strPurify4label(sprintf('Waveform of %s', au.file))); end

	if strcmp(ptOpt.mainFun, 'dpOverPfMat')
		plotId=plotId+1; subplot(plotNum, 1, plotId);
		pfPlot(pfMat, frameTime, dpPath);
		title('PF matrix (white dots: DP path, black dots: Pitch after all kinds of thresholding/smoothing');
		pp=round(fs./pitch2freq(pitch));
		for i=1:frameNum, line(frameTime(i), pp(i), 'color', 'k', 'marker', '.'); end
	end

	plotId=plotId+1; subplot(plotNum, 1, plotId);
	cPitch=pitch; cPitch(cPitch==0)=nan;
	tPitch=nan*cPitch;
	pvFile=[au.file(1:end-3), 'pv'];
	if exist(pvFile, 'file'), au.tPitch=asciiRead(pvFile); end
	if isfield(au, 'tPitch')
		tPitch=au.tPitch;
		tPitch(tPitch==0)=nan;
		plot(frameTime, pitch2, 'g.-', frameTime, tPitch, 'r-o', frameTime, cPitch, 'k.-');	% Do not change the order!
		title('Desired (circle) and computed (dot) pitch');
	%	legend('Computed pitch', 'Desired pitch', 'location', 'northOutside', 'orientation', 'horizontal');
	else
		plot(frameTime, pitch2, 'g.-', frameTime, cPitch, 'k.-');
		title('Computed pitch');
	%	legend('Computed pitch', 'location', 'northOutside', 'orientation', 'horizontal');
	end
	line([min(time), max(time)], ptOpt.minPitch*[1 1], 'color', 'm');
	line([min(time), max(time)], ptOpt.maxPitch*[1 1], 'color', 'm');
	axis([min(time) max(time) ptOpt.minPitch-1 ptOpt.maxPitch+1]);
%	axis([min(frameTime) max(frameTime) -inf inf]);
%	set(gca, 'xlim', [min(time) max(time)]);
	ylabel('Pitch (semitone)'); grid on

	if ptOpt.useVolThreshold
		plotId=plotId+1; subplot(plotNum, 1, plotId);
		frameTime=frame2sampleIndex(1:length(pitch), ptOpt.frameSize, ptOpt.overlap)/ptOpt.fs;
		% EPD, which should have been done in ptByDpOverPfMex!!!
		epdPrm=endPointDetect('defaultOpt');
		epdPrm.frameDuration=ptOpt.frameSize/ptOpt.fs;
		epdPrm.overlapDuration=ptOpt.overlap/ptOpt.fs;	
		epdPrm.method='vol';
		[epInSampleIndex, epInFrameIndex, segment, zeroOneVec, others]=endPointDetect(au, epdPrm);		
		volume=others.volume; volTh=others.volTh;
%		[epInSampleIndex, epInFrameIndex, segment, zeroOneVec, volume, volTh]=epdByVol(y, ptOpt.fs, ptOpt.nbits, epdPrm);
		pitch=pitch.*zeroOneVec;
		plot(frameTime, volume, '.-b', [min(frameTime), max(frameTime)], volTh*[1 1], 'r'); title('Volume');
	%	line([min(frameTime), max(frameTime)], volTh*[1 1], 'color', 'r');
		for i=1:length(segment)
			line(frameTime(segment(i).beginFrame)*[1 1], [0, max(volume)], 'color', 'g');
			line(frameTime(segment(i).endFrame)*[1 1], [0, max(volume)], 'color', 'm');
		end
		set(gca, 'xlim', [min(time) max(time)]);
	end

	if ptOpt.useClarityThreshold
		plotId=plotId+1; subplot(plotNum, 1, plotId);
		plot(frameTime, clarity, '.-');
		line([min(frameTime), max(frameTime)], max(clarity)*ptOpt.clarityRatio*[1 1], 'color', 'r');
		set(gca, 'xlim', [min(time) max(time)]);
		xlabel('Time (sec)'); title('Clarity'); grid on
	end 
	% ====== Buttons for playback
	pitchObj.signal=pitch; pitchObj.frameRate=fs/(ptOpt.frameSize-ptOpt.overlap);
	if isfield(au, 'tPitch')
		pitchObj2.signal=tPitch; pitchObj2.frameRate=fs/(ptOpt.frameSize-ptOpt.overlap);
		buttonH=audioPitchPlayButton(au, pitchObj, pitchObj2);
		set(buttonH(end), 'string', 'Play GT pitch')
	else
		buttonH=audioPitchPlayButton(au, pitchObj);
	end
%	set(gcf, 'name', sprintf('PT using ptByDpOverPfMex, with pfWeight=%d and indexDiffWeight=%d', ptOpt.pfWeight, ptOpt.indexDiffWeight));
	set(gcf, 'name', sprintf('PT using mainFun=%s', ptOpt.mainFun));
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
