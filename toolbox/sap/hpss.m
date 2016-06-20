function [theH,theP]=hpss(y, opt, plotOpt)
%hpss: Harmonic-Percussive Sound Separation
%
%	Usage:
%		[theH,theP]=hpss(y, opt)
%
%	Example:
%		[theH,theP]=HPSS('train06_short.wav',4096,4096/4);

%Chao-Ling Hsu Mar. 26, 2010

if nargin<1, selfdemo; return; end
if nargin<2
	opt.frameSize=4096;
	opt.hop=4096/2;
	opt.iteration=5;
end
if nargin<3, plotOpt=0; end


frameSize=opt.frameSize;
frameMat=buffer2(y, frameSize, frameSize-opt.hop);
frameNum=size(frameMat,2);
%hw=sin(pi*[0:frameSize-1]/(frameSize-1))'*ones(1, frameNum);	%sine window
frameMat=frameMat.*(hamming(frameSize)*ones(1, frameNum));

r=0.5;
theSpectrogram=fft(frameMat, frameSize);
theSpectrogram=theSpectrogram(1:frameSize/2+1,:);
W=abs(theSpectrogram).^(2*r);

H=0.5*W;
P=H;
binNum = size(W,1);
for i=1:opt.iteration
    lamda = sqrt(H(2:binNum-1,1:frameNum-2)) + sqrt(H(2:binNum-1,3:frameNum));
    mu = sqrt(P(1:binNum-2,2:frameNum-1)) + sqrt(P(3:binNum,2:frameNum-1));
    H(2:binNum-1,2:frameNum-1) = ((lamda.^2.*W(2:binNum-1,2:frameNum-1))) ./ (lamda.^2+ mu.^2);
    P(2:binNum-1,2:frameNum-1) = ((mu.^2.*W(2:binNum-1,2:frameNum-1))) ./ (lamda.^2+ mu.^2);
end

theH = istft(H.^(1/(2*r)).*exp(1i*angle(theSpectrogram)), opt.hop)';
theP = istft(P.^(1/(2*r)).*exp(1i*angle(theSpectrogram)), opt.hop)';

if plotOpt
	subplot(3,1,1);
	imagesc(db(W)); axis xy; ylabel('Frequncey bin');
	title('Original');
	subplot(3,1,2);
	imagesc(db(P)); axis xy; ylabel('Frequncey bin');
	title('Percussive');
	subplot(3,1,3);
	imagesc(db(H)); axis xy; ylabel('Frequncey bin');
	title('Harmonic');
	ylabel('Frame index');
end

% ====== Self demo
function selfdemo
demoFile = 'demo.wav';
[y, fs, nbits]=wavread(demoFile);
y=y(:,1);
opt.frameSize=4096;
opt.hop=2048;
opt.iteration=5;
plotOpt=1;
[theH,theP]=hpss(y, opt, plotOpt);
wavwrite(theH,16000,'demo_h.wav');
wavwrite(theP,16000,'demo_p.wav');

function x=istft(fftMat, hopSize)
% X = istft(fftMat, F, W, H)                   Inverse short-time Fourier transform.
%	Performs overlap-add resynthesis from the short-time Fourier transform 
%	data in D.  Each column of D is taken as the result of an F-point 
%	fft; each successive frame was offset by H points. Data is 
%	hann-windowed at W pts.  
%       W = 0 gives a rectangular window; W as a vector uses that as window.

[dim, frameNum]=size(fftMat);
frameSize=(dim-1)*2;
xlen=frameSize+(frameNum-1)*hopSize;
x=zeros(1, xlen);

win=sin(pi*[0:frameSize-1]/(frameSize-1));	% sine window
for i=1:frameNum
	ft = fftMat(:, i).';
	ft=[ft, conj(ft([((frameSize/2)):-1:2]))];
	px=real(ifft(ft));
	index1=(i-1)*hopSize+1;
	index2=index1+frameSize-1;
	x(index1:index2)=x(index1:index2)+px.*win;
end
