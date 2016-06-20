function genThumbNail1(photoDir)
% genThumbNail1: Create thumbnail for .jpg files from a given singel directory�]�A�Ω�1�h�ؿ��^
%	�Ҧp�GgenThumbNail1('C:\Documents and Settings\user\�ୱ\gourami\photo\20040814-�������Y�C')

%	Roger Jang, 20031111

if nargin<1; photoDir='C:\Documents and Settings\user\�ୱ\gourami\photo\20040814-�������Y�C'; end
if photoDir(end)=='\' | photoDir(end)=='/', photoDir(end)=[]; end

jpegRsPath='D:\users\jang\matlab\toolbox\utility\jpegRS.exe';

[junk, parentDir, junk, junk]=fileparts(photoDir);

% ====== Create index.htm for redirecting
fid=fopen([photoDir, '/index.htm'], 'w');
fprintf(fid, '<script>document.location="tn/index.htm";</script>');
fclose(fid);

% ====== Create tn directory
[success, message, messageId]=mkdir(photoDir, 'tn');
if success~=1
	error('Error in creating tn directory!');
end

% ====== Create thumbnail photos
jpgFiles=dir([photoDir, '/*.jpg']);
photoNum=length(jpgFiles);
for i=1:photoNum
	jpgFile=['"', photoDir, '/', jpgFiles(i).name, '"'];
	fprintf('%g/%g ==> %s\n', i, photoNum, jpgFile);
	cmd=[jpegRsPath, ' ', jpgFile];
	[s, w]=dos(cmd);
	items=split(deblank(w), ' ');
	width=eval(items{1});
	height=eval(items{2});
	newHeight=100;
	newWidth=round(newHeight*width/height);
	newJpgFile=['"', photoDir, '/tn/tn_', jpgFiles(i).name, '"'];
	cmd=[jpegRsPath, ' ', jpgFile, ' ', int2str(newWidth), ' ', int2str(newHeight), ' ', newJpgFile];
	dos(cmd);
end

mpg=dir([photoDir, '/*.mpg']);
asf=dir([photoDir, '/*.asf']);
wmv=dir([photoDir, '/*.wmv']);
mpgFiles=[mpg; asf; wmv];
movieNum=length(mpgFiles);

% ====== Create index.htm under tn directory
fid=fopen([photoDir, '/tn/index.htm'], 'w');

fprintf(fid, '<HTML>\n');
fprintf(fid, '<HEAD>\n');
fprintf(fid, ['\t<TITLE>', parentDir, '</TITLE>\n']);
fprintf(fid, '\t<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=big5">\n');
fprintf(fid, '</HEAD>\n');
fprintf(fid, '<body>\n');
fprintf(fid, ['<h2 align=center>', parentDir, '</h2><hr>\n']);

if photoNum>0
	fprintf(fid, ['<h3 align=center>�Ϥ��ɮס]*.jpg�^�G', int2str(length(jpgFiles)), '</h3>\n']);
	fprintf(fid, '<TABLE align=center>\n');
	colNum=7;
	rowNum=ceil(photoNum/colNum);
	k=1;
	for i=1:rowNum
		fprintf(fid, '<TR>\n');
		for j=1:colNum
			if k<=photoNum
				[a, b, c, d]=fileparts(jpgFiles(k).name);
				fprintf(fid, '<TD ALIGN=CENTER VALIGN=BOTTOM><FONT face="Verdana, Arial, Helvetica, Sans-Serif" size="-2">');
				fprintf(fid, ['<A target=_blank href="../', jpgFiles(k).name, '"><IMG SRC="tn_', jpgFiles(k).name, '"></A><br>', b, '</FONT></TD>\n']);
			end
			k=k+1;
		end
		fprintf(fid, '</TR>\n');
	end
	fprintf(fid, '</TABLE>');
end

if movieNum>0
	fprintf(fid, ['<h3 align=center>�v���ɮס]*.mpg�^�G', int2str(length(mpgFiles)), '</h3>\n']);
	fprintf(fid, '<TABLE align=center border=1>\n');
	colNum=7;
	rowNum=ceil(movieNum/colNum);
	k=1;
	for i=1:rowNum
		fprintf(fid, '<TR>\n');
		for j=1:colNum
			if k<=movieNum
				[a, b, c, d]=fileparts(mpgFiles(k).name);
				fprintf(fid, '<TD ALIGN=CENTER VALIGN=BOTTOM><FONT face="Verdana, Arial, Helvetica, Sans-Serif">');
				fprintf(fid, ['<A href="../', mpgFiles(k).name, '">', mpgFiles(k).name, '</A></FONT></TD>\n']);
			end
			k=k+1;
		end
		fprintf(fid, '</TR>\n');
	end
	fprintf(fid, '</TABLE>');
end

fprintf(fid, '</BODY></HTML>\n');
fclose(fid);





function tokenList = split(str, delimiter)
% SPLIT Split a string based on a given delimiter
%	Usage:
%	tokenList = split(str, delimiter)

%	Roger Jang, 20010324

tokenList = {};
remain = str;
i = 1;
while ~isempty(remain),
	[token, remain] = strtok(remain, delimiter);
	tokenList{i} = token;
	i = i+1;
end