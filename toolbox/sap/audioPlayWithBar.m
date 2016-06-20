function h=audioPlayWithBar(au)
%audioPlayWithBar: Audio play with a progressive bar
%
%	Usage:
%		h=audioPlayWithBar(au)
%
%	Example:
%		auFile='song01s5.wav';
%		au=myAudioRead(auFile);
%		time=(1:length(au.signal))/au.fs;
%		subplot(211);
%		plot(time, au.signal); axis([min(time), max(time), -1, 1]);
%		ylabel('Amplitude');
%		subplot(212);
%		frameSize=256;
%		overlap=frameSize/2;
%		[S,F,T]=spectrogram(au.signal, frameSize, overlap, 4*frameSize, au.fs);
%		imagesc(T, F, log(abs(S))); axis xy; colormap jet;
%		xlabel('Time (sec)');
%		ylabel('Freq (Hz)');
%		audioPlayButton(au);		% audioPlayWithBar is called within this function!

%	Roger Jang, 20130224

if nargin<1, selfdemo; return; end
if ischar(au), au=myAudioRead(au); end		% au is actually the wave file name

% === Define key-pressed fcn
set(gcf,'KeyPressFcn', @keyPressedFcn);		% Not working yet!
% === Find all axes and create all progressive bars
axesH=findobj(gcf, 'type', 'axes');
for i=1:length(axesH)
	set(gcf, 'currentAxes', axesH(i));
	axisLimit=axis(axesH(i));
	barH(i)=line(nan*[1 1], axisLimit(3:4), 'color', 'r', 'linewidth', 1);
%	barH(i)=line(nan*[1 1], axesH(i).YLim, 'color', 'r', 'linewidth', 1);
end
% === Play audio
if ~au.amplitudeNormalized, au.signal=double(au.signal)/(2^au.nbits/2); end;
p=audioplayer(au.signal, au.fs);
currTime=0;
timerPeriod=0.05;
% === Store everything for display in U
U=get(gco, 'userData'); U.barH=barH; U.currTime=currTime; U.timerPeriod=timerPeriod; U.buttonH=findobj(0, 'tag', 'audioPlayButton'); set(gco, 'userData', U);
set(p, 'TimerFcn', 'U=get(gco, ''userData''); U.currTime=U.currTime+U.timerPeriod; set(U.barH, ''xdata'', U.currTime*[1 1]); set(U.buttonH, ''string'', sprintf(''%.2f sec'', U.currTime)); set(gco, ''userData'', U);');
set(p, 'TimerPeriod', timerPeriod);
set(p, 'stopFcn', 'U=get(gco, ''userData''); delete(U.barH); set(U.buttonH, ''string'', ''Play Audio'')');
playblocking(p);	% You need to use playblocking()!

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
