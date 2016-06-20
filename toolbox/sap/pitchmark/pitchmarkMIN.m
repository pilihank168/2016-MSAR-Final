function pitchmarks = pitchmarkMIN(y, fs, maxPeriod, minPeriod, SFS_pitchcurve, plotopt)

%PITCHMARKMIN Pitch Mark MIN
%   Usage : pitchmarks = pitchmarkMIN(y, fs, maxPeriod, minPeriod, SFS_pitchcurve, plotopt)
%   Selfdemo : pitchmarkMIN;
%   
%   The follwoing example shows how to use this function.
%
%   a = (1/pitch);
%   b = a*0.5;
%   maxPeriod = a + b;
%   minPeriod = a - b;
%   plotopt = 1;
%   pitchmarks = pitchmarkMIN(y, fs, maxPeriod, minPeriod, plotopt);


if nargin <6, plotopt = 0; end;
if nargin <4, maxPeriod = 0.007; minPeriod = 0.0065; SFS_pitchcurve = 200; plotopt = 1; end;
if nargin==0, selfdemo; return; end;

pitch = 1/((maxPeriod+minPeriod)/2); %�i������pitch

% =====����X�̤p�Ȫ�y
[junk, pitchmarks] = min(y);
%�����N�� pitch marks
while (1),
   currentIndex = pitchmarks(end);
   minIndex = currentIndex+floor(minPeriod*fs);
   maxIndex = currentIndex+ceil(maxPeriod*fs);
   if maxIndex >= length(y) ,
      if (length(y)- pitchmarks(end)) > (fs/pitch), %���p�̫�@��pitch mark�ȤӤp
         begin = pitchmarks(end)+ round((fs/pitch)/2);
         candidateY = y(begin : end);
         [junk, newIndex] = min(candidateY);
         pitchmarks = [pitchmarks, begin+newIndex-1];
      end;
      break;    
   end;
   candidateY = y(minIndex:maxIndex);
   [junk, newIndex] = min(candidateY);
   pitchmarks = [pitchmarks, minIndex+newIndex-1];
end
%���e��M�� pitch marks
while (1)
   currentIndex = pitchmarks(1);
   maxIndex = currentIndex-floor(minPeriod*fs);
   minIndex = currentIndex-ceil(maxPeriod*fs);
   if minIndex <= 0 , %�i���٦��̫�@��pitch mark�b��
      if pitchmarks(1) > (fs/pitch), %���p�ثe�Ĥ@��pitch mark�Ȥj�󦹭�
         tail = pitchmarks(1) - round((fs/pitch)/2);
         candidateY = y(1:tail);
         [junk, newIndex] = min(candidateY);
         pitchmarks = [newIndex, pitchmarks];
      end;
      break;
   end;
   candidateY = y(minIndex:maxIndex);
   [junk, newIndex] = min(candidateY);
   pitchmarks = [minIndex+newIndex-1, pitchmarks];
end

%�ץ�pitch mark���i����~
pitchmarks((diff(pitchmarks)==0)) = [];

if plotopt,   
   plotpitchmarks(y, fs, pitchmarks, SFS_pitchcurve);
end;


% ============================================================== %
% selfdemo
% ============================================================== %
function selfdemo
wavefile = 'C:\Users\tiny\Desktop\tiny\dataset\target\cut\�s�ЧA�n_4temp.wav';
plotopt  = 1;
[y, fs] = wavread(wavefile);

% �p�� pitch
SFS_pitchcurve = wave2pitch_SFS(wavefile);
SFS_pitchcurve((SFS_pitchcurve<50 | SFS_pitchcurve>600)) = [];
if isempty(SFS_pitchcurve), error('Pitch is not available!'); end;

% ���w pitchmarkMIN �Ѽ�
PitchMean = mean(SFS_pitchcurve);
a = (1/PitchMean);
b = a*0.5;
maxPeriod = a + b;
minPeriod = a - b;
pitchmarks = feval(mfilename, y, fs, maxPeriod, minPeriod, SFS_pitchcurve, plotopt);
