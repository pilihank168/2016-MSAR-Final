% Label pitch of audio files in a given directory

close all; clear all;

% Add necessary toolbox (if you haven't done so)
%addpath d:/users/jang/matlab/toolbox/utility -end
%addpath d:/users/jang/matlab/toolbox/sap -end

% Directory of the audio files
auDir='D:\users\jang\books\audioSignalProcessing\programmingContest\pitchTracking\exampleProgram\waveFile\rogerJang';
if ~exist(auDir, 'dir'), error(sprintf('Error: Cannot find the directory %s!', auDir)); end
auDir=strrep(auDir, '\', '/');
auSet=recursiveFileList(auDir, 'wav');
auNum=length(auSet);
fprintf('Read %d wave files from "%S"\n', auNum, auDir);

for i=1:auNum
	fprintf('%d/%d: Check the pitch of %s...\n', i, auNum, auSet(i).path);
	pitchLabel(auSet(i).path);
	fprintf('\tHit any key to check next wav file...\n'); pause
	pitchSave;
	close all
end