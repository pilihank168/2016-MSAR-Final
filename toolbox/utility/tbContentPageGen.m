function tbContentPageGen
% tbContentPageGen: Generate the content page for a toolbox
%
%	Usage:
%		tbContentPageGen

mFileData=dir('*.m');
for i=1:length(mFileData)
	fileName=mFileData(i).name;
	fprintf('%d/%d: file=%s, ', i, length(mFileData), fileName);
%	if strcmp(fileName, 'contents.m'), continue; end
	mFileData(i).doc=mFileParse(fileName);
	fprintf('category=%s\n', mFileData(i).doc.category);
end

docs=[mFileData.doc];
category={docs.category};
uniqueCategory=unique(category);

tbInfo=toolboxInfo;
outputFile='Contents.m';
fprintf('Writing %s...\n', outputFile);
fid=fopen(outputFile, 'w');
fprintf(fid, '%% %s\n', tbInfo.name);
temp=ver;
index=find(strcmp('MATLAB', {temp.Name}));
fprintf(fid, '%% Version %s %s %s\n', tbInfo.version, temp(index).Release, date);

for i=1:length(uniqueCategory)
	if isempty(uniqueCategory{i}), continue; end
	fprintf(fid, '%%\n%% %s\n', uniqueCategory{i});
	index=find(strcmp(category, uniqueCategory{i}));
	temp=mFileData(index);
	fieldWidth=maxStrLen({temp.name})-2;
	for j=1:length(index)
		fprintf(fid, '%%   %-*s - %s\n', fieldWidth, mFileData(index(j)).name(1:end-2), mFileData(index(j)).doc.purpose);
	end
end
fclose(fid); 
edit Contents.m
