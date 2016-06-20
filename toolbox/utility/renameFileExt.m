function renameFileExt(directory, ext1, ext2)
% renameFileExt: Rename the extension name of files recursively under a specific directory recursively
%	Usage: renameFileExt(directory, ext1, ext2)
%		directory: target directory
%		ext1: original extension
%		ext2: newextension

%	Roger Jang, 20060802

files=recursiveFileList(directory, ext1);
fileNum=length(files);

for i=1:fileNum
	path=files(i).path;
	[a, b, c, d]=fileparts(path);
	path2=fullfile(a, [b, ['.', ext2], d]);
	fprintf('%d/%d: %s ===> %s\n', i, fileNum, path, path2);
	[status, message, messageId]=movefile(path, path2, 'f');
	if status~=1
		fprintf('Cannot rename file!\n');
	end
end