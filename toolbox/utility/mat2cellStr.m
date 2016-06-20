function cellStr=mat2cellStr(x)
%
%	Example:
%		x=4:2:10;
%		y=mat2cellStr(x);
%		disp(y)

%	Roger Jang, 20110507

if nargin<1, selfdemo; return; end

y=mat2str(x(:)');
y=strrep(y, '[', '');
y=strrep(y, ']', '');
cellStr=split(y, ' ');

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
