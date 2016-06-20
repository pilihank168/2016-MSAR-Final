function list=mFileGrep(dirName, pattern, opt)
% mFileGrepRecursive: Apply "grep" for files of a specific extension within a directory
%
%	Usage:
%		list=mFileGrep(dirName, pattern)
%		list=mFileGrep(dirName, pattern, extName)
%
%	Description:
%		list=mFileGrep(dirName, pattern) returns the m files within given directory that contains the given pattern.
%
%	Example:
%		opt=mFileGrep('defaultOpt');
%		list=mFileGrep('.', 'knnc', opt);
%		dos(['vi ', join(list, ' ')])

%	Category: Utility
%	Roger Jang, 20100829, 20111118

if nargin<1, selfdemo; return; end
% ====== Set the default options
if ischar(dirName) && strcmpi(dirName, 'defaultOpt')
	list.extName='m';
	list.maxFileNumInEachDir=inf;
	list.maxDirNum=inf;
	list.mode='recursive';	% 'recursive' or 'nonrecursive'
	return
end
if nargin<3||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end

mFileData=fileList(dirName, opt);
fileCount=length(mFileData);
list={};
%found=logical(zeros(length(mFileData), 1));
for i=1:fileCount
%	fprintf('%d/%d: %s\n', i, fileCount, mFileData(i).path);
	output=grep(mFileData(i).path, pattern);
%	found(i)=~isempty(output);
	if ~isempty(output)
		fprintf('%d/%d: file=%s, output=%s\n', i, fileCount, mFileData(i).path, output);
	%	list={list{:}, mFileData(i).path};
		list=[list, {mFileData(i).path}];
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
