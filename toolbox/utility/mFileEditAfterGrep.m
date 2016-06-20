function mFileEditAfterGrep(dirName, pattern)
% mFileEditAfterGrep: Edit files of a specific extension within a directory after "grep"
%
%	Usage:
%		mFileEditAfterGrep(dirName, pattern)
%		mFileEditAfterGrep(dirName, pattern, extName)
%
%	Description:
%		mFileGrep(dirName, pattern, extName) edit files of a specific extension
%		within a directory after using "grep" for pattern matching
%
%	Example:
%		mFileEditAfterGrep('.', 'knnc');

%	Category: Utility
%	Roger Jang, 20100829

if nargin<1, selfdemo; return; end

files=mFileGrep(dirName, pattern);
if ~isempty(files)
	dosCmd=['vi ', join(files, ' ')];
	dos(dosCmd);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
