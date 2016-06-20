function outStr=c2emonth(str)
% c2emonth: �N�������ഫ���^����
%
%	Usage:
%		eMonth=c2emonth(cMonth)
%
%	Example:
%		cMonth='�|��';
%		eMonth=c2eMonth(cMonth);
%		fprintf('%s ===> %s\n', cMonth, eMonth);

%	Roger Jang, 20141012

if nargin<1, selfdemo; return; end

%str=xlate(str);
%fprintf('str=%s\n', str);

str=strrep(str, '�Q�@��', 'Nov');	% The order is important!
str=strrep(str, '�Q�G��', 'Dec');	% The order is important!
str=strrep(str, '�@��', 'Jan');
str=strrep(str, '�G��', 'Feb');
str=strrep(str, '�T��', 'Mar');
str=strrep(str, '�|��', 'Apr');
str=strrep(str, '����', 'May');
str=strrep(str, '����', 'Jun');
str=strrep(str, '�C��', 'Jul');
str=strrep(str, '�K��', 'Aug');
str=strrep(str, '�E��', 'Sept');
str=strrep(str, '�Q��', 'Oct');
outStr=str;

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);