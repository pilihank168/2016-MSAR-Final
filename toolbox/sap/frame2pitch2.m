function [pitch, clarity, pitchIndex, pdf]=frame2pitch(frame, opt, showPlot)
% frame2pitch: Frame to pitch conversion using PDF
%	Usage: [pitch, clarity, pitchIndex]=frame2pitch(frame, opt, showPlot)
%
%	Usage:
%		out=frame2pdf(frame, opt, showPlot);
%			frame: Given frame
%			opt: Options for PDF computation
%				opt.pdf: PDF function to be used
%					'acf' for ACF
%					'amdf' for AMDF
%					'nsdf' for NSDF
%					'acfOverAmdf' for ACF divided by AMDF
%					'hps' for harmonics product sum
%					'ceps' for cepstrum
%				opt.maxShift: no. of shift operations, which is equal to the length of the output vector
%				opt.method: 1 for using the whole frame for shifting
%					2 for using the whole frame for shifting, but normalize the sum by it's overlap area
%					3 for using frame(1:frameSize-maxShift) for shifting
%				opt.siftOrder: order of SIFT (0 for not using SIFT)
%			showPlot: 0 for no plot, 1 for plotting the frame and ACF output
%			out: the returned PDF vector
%
%	Example:
%		waveFile='soo.wav';
%		au=myAudioRead(waveFile);
%		frameSize=256;
%		frameMat=enframe(au.signal, frameSize);
%		frame=frameMat(:, 292);
%		opt=frame2pitch('defaultOpt');
%		opt.fs=au.fs;
%		pitch=frame2pitch(frame, opt, 1);
%
%	See also frame2acf, frame2amdf, frame2nsdf.

%	Roger Jang 20070209, 20100617

if nargin<1, selfdemo; return; end
if nargin<3, showPlot=0; end

%% Preprocessing
frame=frameZeroMean(frame, opt.zeroMeanPolyOrder);

frameEstimated=[];
excitation=[];
if opt.siftOrder>0
	[frameEstimated, excitation, coef]=sift(frame, opt.siftOrder);	% Simple inverse filtering tracking
	frame=excitation;
end
frameSize=length(frame);
switch (opt.pfType)
	case 0	% AMDF
		method=2;
		pdf=frame2amdfMex(frame, frameSize, method);
	%	pdf=pdf.*(0:length(pdf)-1)';
		[pitch, clarity, pitchIndex]=pf2pitch(pdf, opt);
	case 1	% ACF
		method=2;
		pdf=frame2acfMex(frame, frameSize, method);
		if method==1
			pdfWeight=1+linspace(0, opt.alpha, length(pdf))';
			pdf=pdf.*pdfWeight;	% To avoid double pitch error (esp for violin). 20110416
		end
		if method==2
			pdfWeight=1-linspace(0, opt.alpha, length(pdf))';	% alpha is less than 1.
			pdf=pdf.*pdfWeight;	% To avoid double pitch error (esp for violin). 20110416
		end
		[pitch, clarity, pitchIndex]=pf2pitch(pdf, opt);
	case 2	% NSDF
		method=1;
		pdf=frame2nsdfMex(frame, frameSize, method);
		[pitch, clarity, pitchIndex]=pf2pitch(pf, opt);
	case 3	% HPS
		zeroPaddedFrameSize=16*length(frameSize);
		[pdf, freq]=frame2hps(frame, opt.fs, zeroPaddedFrameSize);
		[maxValue, maxIndex]=max(pdf);
		pitch=freq2pitch(freq(maxIndex));
		clarity=0.8;
		pitchIndex=nan;
	otherwise
		error('Unknown pfType!');
end

if showPlot
	subplot(2,1,1); plot(frame); axis tight; title('Frame');
	subplot(2,1,2); [pitch, clarity, ppcIndex]=pf2pitch(pdf, opt, showPlot); title(sprintf('PF (pfType=%d)', opt.pfType));
end

% ====== Self demo
function selfdemo
waveFile='greenOil.wav';
[y, fs, nbits]=wavReadInt(waveFile);
frameMat=buffer2(y, 256, 0);
frame=frameMat(:, 250);
pfType=2;
opt=ptOptSet(fs, nbits, pfType);
showPlot=1;
[pitch, clarity, pitchIndex]=frame2pitch(frame, opt, showPlot);
