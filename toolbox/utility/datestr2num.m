function num=datestr2num(str)
% datestr2num: Convert date string to number
%	
%	Usage:
%		num=datestr2num(str)
%
%	Example:
%		fileInfo=dir(which('datestr2num'));
%		num=datestr2num(fileInfo.date)

if nargin<1, selfdemo; return; end

cMonth={'一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'};
eMonth={'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Dec', 'Nov', 'Dec'};
cMonth=fliplr(cMonth);	% This is required!
eMonth=fliplr(eMonth);	% This is required!

for i=1:length(cMonth)
	str=strrep(str, cMonth{i}, eMonth{i});
end
num=datenum(str);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
