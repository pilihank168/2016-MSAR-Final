function genThumbNail2(yearDir)
% genThumbNail2: 適用於2層目錄
%	例如：genThumbNail2('C:\Documents and Settings\user\桌面\gourami\photo\2005')

if nargin<1; yearDir='C:\Documents and Settings\user\桌面\gourami\photo\'; end
if yearDir(end)=='\' | yearDir(end)=='/', yearDir(end)=[]; end

allDates=dir(yearDir);
allDates=allDates([allDates.isdir]);
allDates(1:2)=[];

for i=1:length(allDates)
	thisDate=[yearDir, '\', allDates(i).name];
	fprintf('%d/%d ===========> %s\n', i, length(allDates), thisDate);
	genThumbNail1(thisDate);
end