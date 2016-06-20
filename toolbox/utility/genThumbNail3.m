function genThumbNail3(diaryDir)
% genThumbNail3: 適用於3層目錄
%	例如：genThumbNail3('H:\users\jang2\image\diary\')

if nargin<1; diaryDir='C:\Documents and Settings\user\xxx\gourami\photo\'; end
if diaryDir(end)=='\' | diaryDir(end)=='/', diaryDir(end)=[]; end

yearDirs=dir(diaryDir);
yearDirs=yearDirs([yearDirs.isdir]);
yearDirs(1:2)=[];

for i=1:length(yearDirs)
	thisYear=[diaryDir, '\', yearDirs(i).name];
	fprintf('%d/%d ================> %s\n', i, length(yearDirs), thisYear);
	genThumbNail2(thisYear);
end