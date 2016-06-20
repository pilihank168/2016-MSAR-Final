function files=mFileGrepRecursive(dirName, pattern, extName)
% mFileGrepRecursive: Apply "grep" for files of a specific extension within a directory
%
%	Usage:
%		files=mFileGrepRecursive(dirName, pattern)
%		files=mFileGrepRecursive(dirName, pattern, extName)
%
%	Description:
%		files=mFileGrepRecursive(dirName, pattern) returns the m files within given directory that contains the given pattern.
%
%	Example:
%		files=mFileGrepRecursive('.', 'knnc');
%		dos(['vi ', join(files, ' ')])

%	Category: Utility
%	Roger Jang, 20100829

if nargin<3, extName='m'; end

mFileData=recursiveFileList(dirName, extName);
files={};
for i=1:length(mFileData)
%	fprintf('%d/%d: %s\n', i, length(mFileData), mFileData(i).path);
	output=grep(mFileData(i).path, pattern);
	if ~isempty(output)
		fprintf('%s\n', output);
		files={files{:}, mFileData(i).path};
	end
end
