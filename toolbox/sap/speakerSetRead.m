function speakerSet=speakerSetRead(dirName, maxUtterNumPerSpeaker, maxSpeakerNum);
% speakerSetRead: Read wave file info for speaker identification from a given directory.
%
%	Usage:
%		speakerSet=speakerSetRead(dirName, maxUtterNumPerSpeaker, maxSpeakerNum);
%			dirName: root directory that contains subdirectory of each speaker, in which the wave files reside.
%			senenceNumPerSpeaker: How many sentences to read for each speaker
%			speakerSet: the retrieved data structure
%
%	Example:
%		auDir='e:\dataSet\mir-2010-speakerId_label\session01';
%		speakerSet=speakerSetRead(auDir);

%	Roger Jang, 20030509, 20070517

if nargin<1, dirName='D:\dataset\tangPoem\2003-音訊處理與辨識'; end
if nargin<2, maxUtterNumPerSpeaker=inf; end
if nargin<3, maxSpeakerNum=inf; end

if (dirName(end)~='/') | (dirName(end)~='\'); dirName=[dirName, '/']; end

% ====== Collect feature from all wave files
speakerSet = dir(dirName);
if length(speakerSet)<2
	error(sprintf('Cannot find enough speakers/directories under "%s"!\n', dirName));
end
speakerSet(1:2) = [];				% Get rid of '.' and '..'
speakerSet=speakerSet([speakerSet.isdir]);	% Take directories only
speakerNum=min(length(speakerSet), maxSpeakerNum);
speakerSet=speakerSet(1:speakerNum);
for i=1:speakerNum
	speakerSet(i).path=[dirName, speakerSet(i).name];
	waveFiles = dir([speakerSet(i).path, '/*.wav']);
	speakerSet(i).sentenceNum=length(waveFiles);
%	fprintf('%d/%d: Reading %d wave files recorded by %s\n', i, speakerNum, speakerSet(i).sentenceNum, speakerSet(i).name);
	for j=1:speakerSet(i).sentenceNum
		if j>maxUtterNumPerSpeaker, break; end
		speakerSet(i).sentence(j).path = [dirName, speakerSet(i).name, '/', waveFiles(j).name];
%		fprintf('\t%d/%d: Processing %s...\n', j, speakerSet(i).sentenceNum, speakerSet(i).sentence(j).path);
		speakerSet(i).sentence(j).mainName=waveFiles(j).name(1:end-4);
		items=split(speakerSet(i).sentence(j).mainName, '#');
		speakerSet(i).sentence(j).text=items{1};
		speakerSet(i).sentence(j).speaker=speakerSet(i).name;
	end
end
% get rid of unused fields
speakerSet=rmfield(speakerSet, 'isdir');
speakerSet=rmfield(speakerSet, 'bytes');
speakerSet=rmfield(speakerSet, 'date');
speakerSet=rmfield(speakerSet, 'datenum');