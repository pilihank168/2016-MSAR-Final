function [cPitch, acf, amdf, nsdf]=frame2pitch4labeling(frame, ptOpt, showPlot);
% frame2pitch4labeling: Compute pitch from a given frame
%
%	Usage:
%		cPitch=frame2pitch4labeling(frame, ptOpt, showPlot); 
%			frame: input frame
%			ptOpt: pitch parameters, including fs, nbits, etc.
%			showPlot: 1 for plotting, 0 for not plotting
%			cPitch: Computed pitch in semitone
%
%	Example:
%		waveFile='twinkleTwinkleLittleStar.wav';
%		au=myAudioRead(waveFile);
%		ptOpt=ptOptSet(au.fs, au.nbits);
%		frameMat=enframe(au.signal, ptOpt.frameSize, ptOpt.overlap);
%		frame=frameMat(:, 120);
%		frame2pitch4labeling(frame, ptOpt, 1);

%	Roger Jang, 20021201, 20070217, 20150409

if nargin<1, selfdemo; return; end
if nargin<2 | isempty(ptOpt), ptOpt=ptOptSet; end
if nargin<3, showPlot=0; end

userDataGet;

% ====== Zero mean
%fprintf('Saving frame.mat...\n'); save frame frame
%frame=frame-mean(frame);
frame=frameZeroMean(frame, 6);

% ====== Compute ACF/AMDF/NSDF
opt=frame2pdf('defaultOpt');
opt.maxShift=length(frame);
opt.pdf='acf'; acf=frame2pdf(frame, opt);
opt.pdf='amdf4pt'; amdf=frame2pdf(frame, opt);
%opt.pdf='dtwamdf4pt'; amdf=frame2pdf(frame, opt);
opt.pdf='nsdf'; nsdf=frame2pdf(frame, opt);

% ====== Find IOI (interval of interest)
beginIndex=ceil(ptOpt.fs/pitch2freq(ptOpt.maxPitch));
endIndex=min(floor(ptOpt.fs/pitch2freq(ptOpt.minPitch)), ptOpt.pfLen);

% ====== Find local maxima in IOI of acf
temp=acf;
localMaxPos=localMax(temp);
temp(~localMaxPos)=-inf;	% Non local max is set to -inf
temp(endIndex:end)=-inf;	% Remove out-of-bound local max. 
temp(1:beginIndex)=-inf;	% Remove out-of-bound local max.

if all(isinf(temp))
	cPitch=0;
	maxIndex=[];
else
	[maxValue, maxIndex]=max(temp);
	freq=ptOpt.fs/(maxIndex-1);
	cPitch=freq2pitch(freq);
end

% ====== Plot related information
if showPlot
	% Plot of frame
	clf;
	plotNum=4;
	frameAxisH=subplot(plotNum,1,1);
	frameH=plot(1:length(frame), frame, '.-'); axis([1, length(frame), -1, 1]); grid on; title('Frame');
	% Plot of AMDF
	amdfAxisH=subplot(plotNum,1,2);
	amdfH=plot(1:length(amdf), amdf, '.-'); axis tight; title('AMDF4PT'); grid on
	temp=amdf; temp(endIndex:end)=-inf;	temp(1:beginIndex)=-inf;
	[maxValue, maxIndex]=max(temp);	line(maxIndex, amdf(maxIndex), 'linestyle', 'none', 'color', 'r', 'marker', 'o');
	line(beginIndex*[1 1], get(gca, 'ylim'), 'color', 'r'); line(  endIndex*[1 1], get(gca, 'ylim'), 'color', 'r');
	% Plot of NSDF
	nsdfAxisH=subplot(plotNum,1,3);
	nsdfH=plot(1:length(nsdf), nsdf, '.-'); axis tight; title('NSDF'); grid on
	temp=nsdf; temp(endIndex:end)=-inf;	temp(1:beginIndex)=-inf;
	[maxValue, maxIndex]=max(temp);	line(maxIndex, nsdf(maxIndex), 'linestyle', 'none', 'color', 'r', 'marker', 'o');
	line(beginIndex*[1 1], get(gca, 'ylim'), 'color', 'r'); line(  endIndex*[1 1], get(gca, 'ylim'), 'color', 'r');
	% Plot of ACF
	acfAxisH=subplot(plotNum,1,4);
	acfH=plot(1:length(acf), acf, '.-'); axis tight; title('ACF'); grid on
	if any(localMaxPos)
		localMaxIndexH=line(find(localMaxPos), acf(find(localMaxPos)), 'linestyle', 'none', 'color', 'k', 'marker', 'o');
	end
	if ~isempty(maxIndex)
		maxIndexH=line(maxIndex, acf(maxIndex), 'linestyle', 'none', 'color', 'r', 'marker', 'o');
		manualBarH=line(maxIndex*[1 1], get(acfAxisH, 'ylim'), 'color', 'm');
	end
	line(beginIndex*[1 1], get(gca, 'ylim'), 'color', 'r'); line(  endIndex*[1 1], get(gca, 'ylim'), 'color', 'r');
	
	userDataSet;
	% 設定滑鼠按鈕的反應動作，以便讓使用者修正 pitch
	if gcf~=1, frameWinMouseAction; end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
strEval(mObj.example);