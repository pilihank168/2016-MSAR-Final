function genThumbNail2(yearDir)
% genThumbNail2: �A�Ω�2�h�ؿ�
%	�Ҧp�GgenThumbNail2('C:\Documents and Settings\user\�ୱ\gourami\photo\2005')

if nargin<1; yearDir='C:\Documents and Settings\user\�ୱ\gourami\photo\'; end
if yearDir(end)=='\' | yearDir(end)=='/', yearDir(end)=[]; end

allDates=dir(yearDir);
allDates=allDates([allDates.isdir]);
allDates(1:2)=[];

for i=1:length(allDates)
	thisDate=[yearDir, '\', allDates(i).name];
	fprintf('%d/%d ===========> %s\n', i, length(allDates), thisDate);
	genThumbNail1(thisDate);
end