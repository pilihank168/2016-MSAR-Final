function mFile2html(mFile, htmlFile)
%mFile2html: Parse an m-file and convert its comments into an HTML page.
%
%	Usage:
%		mFile2html(mFile)
%		mFile2html(mFile, htmlFile)
%
%	Description:
%		mFile2html(mFile, htmlFile) takes the given m-File and convert its comments into an HTML page.
%
%	Example:
%		htmlFile=[tempname, '.html'];
%		mFile='xTickLabelRotate.m';
%		mFile2html(mFile, htmlFile);
%		web(htmlFile);
%
%	See also mFileParse.
%
%	Reference:
%		[1] This is a dummy reference.
%		[2] This is the second dummy reference.

%	Category: Utility
%	Roger Jang, 20100824

if nargin<1, selfdemo; return; end
if nargin<2, htmlFile=[tempname, '.htm']; end

mObj=mFileParse(mFile);
mObj2html(mObj, htmlFile);

if nargin<2
	web(htmlFile);
%	dos(['start ', htmlFile]);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
