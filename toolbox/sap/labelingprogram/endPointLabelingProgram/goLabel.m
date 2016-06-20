% For labeling endpoints of audio files

% ====== Add Utility Toolbox and SAP Toolbox to the search path
%addpath d:/users/jang/matlab/toolbox/utility
%addpath d:/users/jang/matlab/toolbox/sap

% ====== Set up the directory of wave files
auDir='D:\users\jang\books\audioSignalProcessing\voiceRecording\digitLetterRecording\waveFile\111';
if ~exist(auDir, 'dir'), error(sprintf('Error: Cannot find the directory %s!', auDir)); end
auSet=recursiveFileList(auDir, 'wav');
waveNum=length(auSet);
fprintf('There are %d files to be labeled:\n', waveNum);

% ====== Start the labeling of end-points
for i=1:waveNum
	auPath=auSet(i).path;
	endPointLabel('start', auPath);
	set(gcf, 'position', get(0, 'screenSize'));
	fprintf('%d/%d: Press any key to save endpoints of %s ...', i, waveNum, auPath); pause; fprintf('\n');
	% Put endPoint into wave file name
	userDataGet;
	index=find(waveFile=='_');
	if length(index)>=2
		newWaveFile=sprintf('%s_%d_%d.wav', waveFile(1:index(end-1)-1), epByHand(1), epByHand(2));
	else
		newWaveFile=sprintf('%s_%d_%d.wav', waveFile(1:end-4), epByHand(1), epByHand(2));
	end
	if strcmp(waveFile, newWaveFile)~=1
		movefile(waveFile, newWaveFile);
	end
end
close all
fprintf('Congratulations, you have finished endpoint labeling!\n');