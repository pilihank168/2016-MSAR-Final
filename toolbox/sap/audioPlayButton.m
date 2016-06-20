function buttonH=audioPlayButton(wObj, axesH)
% audioPlayButton: Place a button for playing wave
%
%	Usage:
%		buttonH=audioPlayButton(wObj)
%
%	Example:
%		waveFile='10 little indians.wav';
%		wObj=myAudioRead(waveFile);
%		plot((1:length(wObj.signal))/wObj.fs, wObj.signal);
%		audioPlayButton(wObj);

%	Roger Jang, 20050820

if nargin<1, selfdemo; return; end
if nargin<2, axesH=gca; end

if ischar(wObj), wObj=myAudioRead(wObj); end	% wObj is actually the wave file name

U.wObj=wObj; U.axesH=axesH;
buttonH=uicontrol('string', 'Play Audio');	% ���ͫ��s����
set(buttonH, 'userData', U);			% �N�Ҧ�����æb�����s����
set(buttonH, 'tag', 'audioPlayButton');

axisPos=get(axesH, 'pos');
figPos =get(gcf, 'pos');
width=100;
height=20;
x=figPos(3)*axisPos(1);
y=figPos(4)*axisPos(2)-2*height;
set(buttonH, 'position', [x, y, width, height]);	% �]�w��m�P���e
set(buttonH, 'unit', 'normalized');
%set(buttonH, 'Callback', 'U=get(gco, ''userData''); sound(U.wObj.signal, U.wObj.fs)');	% �]�w callback
set(buttonH, 'Callback', 'U=get(gco, ''userData''); audioPlayWithBar(U.wObj)');		% �]�w callback

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
