function pv2midiFile(pitchVec, pitchRate, midiFile)
% pv2midiFile: Pitch vector to midi file conversion
%	Usage: pv2midiFile(pitchVec, pitchRate, midiFile)
%		pitchVec: pitch vector
%		pitchRate: number of pitch points per second (which is equal to fs/(frameSize-overlap))
%		midiFile: output midi file
    
noteVec = pv2note(pitchVec);	% Note segmentation. The format of noteVec is [pitch, duration, pitch, duration...]
if noteVec(1)==0
	noteVec = noteVec(3:end);	% Get rid of leading rest
end
if noteVec(end-1) == 0
	noteVec = noteVec(1:end-2);	% Get rid of trailing rest
end
    
for i=1:2:length(noteVec)
	k=(i+1)/2;				% Note index
	pVector(k)=noteVec(i);			% pitch
	durVector(k)=noteVec(i+1)*pitchRate;	% duration
	if k==1
		onVector(k)=0;			% onset begin at 0
	else
		onVector(k)=onVector(k-1)+durVector(k-1);
	end
end

%pVector=noteVec(1:2:end);
%durVector=noteVec(2:2:end);
%onVector=[0, cumsum(durVector)];
    
beatUnit = 2*mean(durVector);	% �����������Ȫ��⭿��@�@��
nmat=[];			% nmat=[beatOn beatDur channel pitch velocity beatOnSec beatDurSec ]
 
for i=1:length(pVector)
	beatOn = onVector(i)/beatUnit;		% OnSet �� beat
	beatDur = durVector(i)/beatUnit;	% ������ beats
	channel = 1;				% �Ĥ@�y
	vel = 110;				% ���q�T�w110
	if pVector(i)~= 0 
		nmat=[nmat; beatOn beatDur channel round(pVector(i)) vel onVector(i) durVector(i)];
	end
end

lastOn = nmat(end,1)+nmat(end,2);	% ���������
lastSec = nmat(end,6)+nmat(end,7);	% �������ɶ�
tempo = floor(lastOn*60/lastSec);	% �p��`��t��
writemidi(nmat, midiFile, 120, tempo);	% �g�J�ɮסA�ϥ�miditoolbox