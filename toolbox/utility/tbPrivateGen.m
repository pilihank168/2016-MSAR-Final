function tbPrivateGen
%tbPrivateGen: Generate private folder for a TB and copy related functions from Utility Toolbox
%
%	Usage:
%		tbPrivateGen
%
%	Description:
%		Check functions of Utility Toolbox that are used in a toolbox
%		Copy these functions to the private directory within a toolbox
%		(You must issue this command within the toolbox directory. Of course, you need to add the path ".." in the first place.)

%	Roger Jang, 20090914

% ====== Extract functions used in the current directory
mFiles=recursiveFileList('.', 'm');
fileNum=length(mFiles);

funcName={};
for i=1:fileNum
	fprintf('%d/%d: mFile=%s\n', i, fileNum, mFiles(i).path);
	theFuncName=funcExtract(mFiles(i).path);
	funcName={funcName{:}, theFuncName{:}};
end
funcName=unique(funcName);
fprintf('%d possible functions collected.\n', length(funcName));

% ===== Collect functions in utility toolbox
utilDir='/users/jang/matlab/toolbox/utility';
mFiles=recursiveFileList(utilDir, 'm');
dllFiles=recursiveFileList(utilDir, 'dll');
if ~isempty(dllFiles)
	sourceFiles=[mFiles; dllFiles];
else
	sourceFiles=mFiles;
end
fprintf('%d possible util functions collected.\n', length(sourceFiles));
for i=1:length(funcName)
	for j=1:length(sourceFiles)
		[a, b, c]=fileparts(sourceFiles(j).path);
		if strcmp(funcName{i}, b)
			sourceFiles(j).toBeCopied=1;
		end
	end
end
fprintf('%d functions to be copied from %s:\n', length([sourceFiles.toBeCopied]), utilDir);

% ====== Copy files to the private directory
if exist('private')==7
%	delete('private\*.*');		% Don't do this since all mex files are here too!
else
	mkdir private
end
for i=1:length(sourceFiles)
	if sourceFiles(i).toBeCopied
		fprintf('Copying %s...\n', sourceFiles(i).path);
		[success, message]=copyfile(sourceFiles(i).path, 'private');
		if ~success
			fprintf('%s cannot be copied\n', sourceFiles(i).path);
		end
	end
end