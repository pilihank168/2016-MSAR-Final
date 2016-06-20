function outStr=c2emonth(str)
% c2emonth: 將中文月份轉換成英文月份
%
%	Usage:
%		eMonth=c2emonth(cMonth)
%
%	Example:
%		cMonth='四月';
%		eMonth=c2eMonth(cMonth);
%		fprintf('%s ===> %s\n', cMonth, eMonth);

%	Roger Jang, 20141012

if nargin<1, selfdemo; return; end

%str=xlate(str);
%fprintf('str=%s\n', str);

str=strrep(str, '十一月', 'Nov');	% The order is important!
str=strrep(str, '十二月', 'Dec');	% The order is important!
str=strrep(str, '一月', 'Jan');
str=strrep(str, '二月', 'Feb');
str=strrep(str, '三月', 'Mar');
str=strrep(str, '四月', 'Apr');
str=strrep(str, '五月', 'May');
str=strrep(str, '六月', 'Jun');
str=strrep(str, '七月', 'Jul');
str=strrep(str, '八月', 'Aug');
str=strrep(str, '九月', 'Sept');
str=strrep(str, '十月', 'Oct');
outStr=str;

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);