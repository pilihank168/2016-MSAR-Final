function [pdf, frameEstimated, excitation]=frame2pdf(frame, opt, showPlot)
% frame2acf: PDF (periodicity detection function) of a given frame (primarily for pitch tracking)
%
%	Usage:
%		pdf=frame2pdf(frame, opt, showPlot);
%			frame: Given frame
%			opt: Options for PDF computation
%				opt.pdf: PDF function to be used
%					'acf' for ACF
%					'amdf' for AMDF
%					'dtwamdf' for AMDF based on DTW
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
%			pdf: the returned PDF vector
%
%	Example:
%		waveFile='soo.wav';
%		wObj=myAudioRead(waveFile);
%		frameSize=256;
%		frameMat=enframe(wObj.signal, frameSize);
%		frame=frameMat(:, 292);
%		opt=frame2pdf('defaultOpt');
%		opt.pdf='amdf4pt';
%		subplot(4,1,1); plot(frame, '.-');
%		title('Input frame'); axis tight
%		subplot(4,1,2);
%		opt.method=1; opt.maxShift=length(frame);
%		pdf=frame2pdf(frame, opt);
%		plot(pdf, '.-'); title('method=1'); axis tight
%		subplot(4,1,3);
%		opt.method=2;
%		pdf=frame2pdf(frame, opt);
%		plot(pdf, '.-'); title('method=2'); axis tight
%		subplot(4,1,4);
%		opt.method=3;
%		opt.maxShift=length(frame)/2;
%		pdf=frame2pdf(frame, opt);
%		plot(pdf, '.-'); title('method=3'); axis tight
%
%	See also frame2amdf, frame2nsdf.

%	Roger Jang 20020404, 20041013, 20060313

if nargin<1, selfdemo; return; end
if nargin==1 && ischar(frame) && strcmpi(frame, 'defaultOpt')	% Set default options
	pdf.pdf='acf';
	pdf.maxShift=512;
	pdf.method=1;
	pdf.siftOrder=0;
	pitch.zeroPaddedFactor=15;	% For 'hps' and 'ceps'
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

frameEstimated=[];
excitation=[];
if opt.siftOrder>0
	[frameEstimated, excitation, coef]=sift(frame, opt.siftOrder);	% Simple inverse filtering tracking
	frame=excitation;
end
frameSize=length(frame);
maxShift=min(frameSize, opt.maxShift);
pdf=zeros(maxShift, 1);

switch lower(opt.pdf)
	case 'acf'
	%	pdf=frame2acf(frame, maxShift, opt.method);
		pdf=frame2acfMex(frame, maxShift, opt.method);
	case 'amdf'
	%	pdf=frame2amdf(frame, maxShift, opt.method);
		pdf=frame2amdfMex(frame, maxShift, opt.method);
	case 'dtwamdf'
		pdf=frame2dtwamdf(frame, maxshift, opt.method)
	case 'nsdf'
	%	pdf=frame2nsdf(frame, maxShift, opt.method);
		pdf=frame2nsdfMex(frame, maxShift, opt.method);
	case 'amdf4pt'
		opt.pdf='amdf';
		amdf=feval(mfilename, frame, opt);
		pdf=max(amdf)*(1-linspace(0,1,length(amdf))')-amdf;
	case 'dtwamdf4pt'
		opt.pdf='dtwamdf';
		dtwamdf=frame2dtwamdf(frame, maxShift, opt.method);
		pdf=max(dtwamdf)*(1-linspace(0,1,length(dtwamdf))')-dtwamdf;
	case 'acfoveramdf'
		opt.pdf='acf';
		acf =feval(mfilename, frame, opt);
		opt.pdf='amdf';
		amdf=feval(mfilename, frame, opt);
		pdf=0*acf;
		pdf(2:end)=acf(2:end)./amdf(2:end);
	case 'hps'
		[pdf, freq]=frame2hps(frame, opt.fs, opt.zeroPaddedFactor);
	case 'ceps'
		pdf=frame2ceps(frame, opt.fs, opt.zeroPaddedFactor);
	otherwise
		error('Unknown PDF=%s!', opt.pdf);
end

if showPlot
	subplot(2,1,1);
	plot(frame, '.-');
	set(gca, 'xlim', [-inf inf]);
	title('Input frame');
	subplot(2,1,2);
	plot(pdf, '.-');
	set(gca, 'xlim', [-inf inf]);
	title(sprintf('%s vector (opt.method = %d)', opt.pdf, opt.method));
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
