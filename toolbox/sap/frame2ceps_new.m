function ceps=frame2ceps(frame, fs, zeroPaddedFactor, showPlot)
% frame2hps: Conversion from a frame to cepstrum for pitch tracking
%
%	Usage:
%		out=frame2ceps(frame, zeroPaddedFactor, showPlot)
%
%	Example:
%		waveFile='soo.wav';
%		au=myAudioRead(waveFile);
%		startIndex=15000;
%		frameSize=round(32*au.fs/1000);
%		zeroPaddedFactor=15	% zero padding
%		frame=au.signal(startIndex:startIndex+frameSize-1);
%		ceps=frame2ceps(frame, au.fs, zeroPaddedFactor, 1);

%	Roger Jang, 20080520

if nargin<1; selfdemo; return; end
if nargin<3, zeroPaddedFactor=15; end
if nargin<4; showPlot=0; end

frame2=frame.*hamming(length(frame));	% Hamming windowing
frameSize=length(frame);
frame2=[frame2; zeros(zeroPaddedFactor*frameSize, 1)];		% zero padding
powerSpec=log(abs(fft(frame2)));
%[mag, phase, freq, powerSpec]=fftOneSide(frame2, fs);

% === zero mean via polynomial fitting
spec0=powerSpec;	% Original power spec
polyOrder=10;
m=length(spec0);
xPos=(1:m)'/m;
specTrend=polyval(polyfit(xPos, spec0, polyOrder), xPos);
spec1=spec0-specTrend;	% Power spec after trend removal
powerSpec=spec1;
% === ifft to get cepstrum
ceps=ifft(powerSpec);	% Complex number, but the imag part is almost zero

% ====== Compute pitch point and reconstruct the powerSpec
if showPlot
	freq=linspace(0, fs, length(frame2));
	plotNum=4;
	subplot(plotNum,1,1);
	plot(1:length(frame), frame, '.-'); axis tight;
	title('Frame');
	
	subplot(plotNum,1,2);
	plot(freq, spec0, freq, specTrend);
	set(gca, 'xlim', [-inf inf]);
	title('Power spectrum and its trend');
	
	subplot(plotNum,1,3);
	plot(freq, powerSpec);
	axis tight;
	title('Power spectrum');
	
	subplot(plotNum,1,4);
	plot(1:length(ceps), ceps);
	axis tight;
	axisLimit=axis;
	title('Cepstrum');

	% ====== Compute pitch
	maxFreq=1000;
	minFreq=40;
	n1=round(fs/maxFreq);	% pdf(1:n1) will not be used
	n2=round(fs/minFreq);	% pdf(n2:end) will not be used
	ceps2=real(ceps); ceps2(1:n1)=-inf; ceps2(n2:end)=-inf;
	[maxValue, maxIndex]=max(ceps2);
	pitch=freq2pitch(fs/(maxIndex-1));
	line(n1*[1 1], axisLimit(3:4), 'color', 'r');
	line(n2*[1 1], axisLimit(3:4), 'color', 'r');
	line(maxIndex, ceps(maxIndex), 'marker', 'o', 'color', 'r');
	ceps3=0*ceps;
	ceps3(maxIndex)=ceps(maxIndex);
	ceps3(length(ceps)-maxIndex+2)=ceps(length(ceps)-maxIndex+2);
	spec3=real(fft(ceps3));	% Reconstructed power spec
	
	subplot(plotNum,1,3);
	line('xdata', freq, 'ydata', spec3, 'color', 'r');

end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
