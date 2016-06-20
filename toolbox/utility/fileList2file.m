function fileList2file(dirName, extName, outputFile)
% fileList2file: Save list of files in a directory to a file
%	Usage: fileList2file(dirName, extName, outputFile)

%	Roger Jang, 20100412

fprintf('Reading %s...\n', dirName);
fileData=recursiveFileList(dirName, extName);

fprintf('Saving %s\n', outputFile);
fid=fopen(outputFile, 'w');
if fid<0, error('Unable to open %s!\n', outputFile); return; end
for i=1:length(fileData)
	fprintf(fid, '%s\n', fileData(i).path);
end
fclose(fid);
