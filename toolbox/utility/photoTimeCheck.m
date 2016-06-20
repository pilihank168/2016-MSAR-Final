clear all;

photoDir='D:\users\jang\personal\photo\000\output';
%photoData=[dir('*.jpg'); dir('*.png'); dir('*.mts'); dir('*.mov'); dir('*.mp4'); dir('*.mov')];
photoData=recursiveFileList(photoDir, 'jpg');
photoNum=length(photoData);
fprintf('Collected %d photos.\n', photoNum);
%%
for i=1:photoNum
%	fprintf('%d/%d: %s\n', i, photoNum, photoData(i).path);
%	photoData(i).folder=datestr(datestr2num(c2eMonth(photoData(i).date)), 'yyyymmdd');
	[~, photoData(i).folder]=fileparts(fileparts(photoData(i).path));
	info=imfinfo(photoData(i).path);
	temp=info.DigitalCamera.DateTimeOriginal;
	temp=temp(1:10);
	temp(temp==':')=[];
	photoData(i).dateOriginal=temp;
	photoData(i).timeConsistent=1;
	if ~strcmp(photoData(i).folder, photoData(i).dateOriginal)
		photoData(i).timeConsistent=0;
		fprintf('%d/%d: file=%s, folder=%s, dateOringal=%s\n', i, photoNum, photoData(i).path, photoData(i).folder, photoData(i).dateOriginal);
	end
end
totalCount=sum(~[photoData.timeConsistent]);
fprintf('%d photos are not consistent in time.\n', totalCount);
return



allFolder={photoData.folder};
uniqueFolder=unique(allFolder);

if ~exist(outputDir, 'dir'), fprintf('Creating %s...\n', outputDir); mkdir(outputDir); end
cd(outputDir);

for i=1:length(uniqueFolder)
	theFolder=uniqueFolder{i};
	if ~exist(theFolder, 'dir'), fprintf('Creating %s...\n', theFolder); mkdir(theFolder); end
	index=find(strcmp(theFolder, allFolder));
	for j=1:length(index)
		source=['../', photoData(index(j)).name];
		fprintf('Moving %s to %s...\n', source, theFolder);
		movefile(['../', photoData(index(j)).name], theFolder);
	end
end

cd ..