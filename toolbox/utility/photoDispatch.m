clear all;

outputDir='output';
photoData=[dir('*.jpg'); dir('*.png'); dir('*.mts'); dir('*.mov'); dir('*.mp4'); dir('*.mov')];
photoNum=length(photoData);
for i=1:photoNum
	photoData(i).folder=datestr(datestr2num(c2eMonth(photoData(i).date)), 'yyyymmdd');
end

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