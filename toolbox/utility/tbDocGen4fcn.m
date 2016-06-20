function tbDocGen4fcn(mode)
%tbDocGen4fcn: Generate HTML help file of each function in a toolbox.
%
%	Usage:
%		tbDocGen4fcn
%		tbDocGen4fcn('incremental')
%		tbDocGen4fcn('all')
%
%	Description:
%		Keep this as a function to avoid variable conflict due to m-file publishing.

if nargin<1, mode='all'; end

outputDir='help';
errorLogFile='helpErrorFile.log';
%if exist(errorLogFile, 'file'), delete(errorLogFile); end	% This will find other errorLogFile in the search path
if ~isempty(dir(errorLogFile)), delette(errorLogFile); end
tbInfo=toolboxInfo;	% Get the toolbox info

% ====== Check if the doc folder exists
if outputDir(end)=='/' | outputDir(end)=='\', outputDir(end)=[]; end	% Get rid of the trailing "/" or "\"
if exist(outputDir, 'dir')~=7
	fprintf('Output folder "%s" does not exist. Please create it before using this function.\n', outputDir);
	return;
end

% ====== Generate html file for each m file
mFileData=dir('*.m');
isFun=logical(zeros(1, length(mFileData)));
for i=1:length(mFileData)
	isFun(i)=isFunction(mFileData(i).name);
end
mFileData=mFileData(isFun);
fprintf('Collect %d functions for generating help file.\n', length(mFileData));

%mFileData=mFileData(1:5);
for i=1:length(mFileData)
	mFile=mFileData(i).name;
	fprintf('%d/%d: mFile=%s\n', i, length(mFileData), mFile);
	mFileData(i).doc=mFileParse(mFile);		% Used in generating index.htm
	[parentDir, mainName, extName]=fileparts(mFile);
	tempMFile=[outputDir, '/', mainName, '_help.m'];
	htmlFile=[outputDir, '/', mainName, '_help.html'];
	if strcmp(mode, 'incremental') & exist(htmlFile, 'file')
		fileInfo1=dir(mFile);    dateNum1=datestr2num(fileInfo1.date);
		fileInfo2=dir(htmlFile); dateNum2=datestr2num(fileInfo2.date);
		if dateNum1<dateNum2, fprintf('\tSkip!\n'); continue; end
	end
	try
		close all;
		htmlFile=mFile2mFile2html(mFile, outputDir);	% Create HTML file
		% ====== Add JS code into HTML for hot keys
		if i==1
			prevHtml='#';
			nextM=mFileData(i+1).name;
			nextHtml=[mFileData(i+1).name(1:end-2), '_help.html'];
			extraContents=sprintf('<hr><a href="index.html">Top page</a>&nbsp;&nbsp;&nbsp;Next: <a href="%s">%s</a>', nextHtml, nextM);
		elseif i==length(mFileData);
			prevM=mFileData(i-1).name;
			prevHtml=[mFileData(i-1).name(1:end-2), '_help.html'];
			nextHtml='#';
			extraContents=sprintf('<hr><a href="index.html">Top page</a>&nbsp;&nbsp;&nbsp;Prev: <a href="%s">%s</a>', prevHtml, prevM);
		else
			prevM=mFileData(i-1).name;
			prevHtml=[mFileData(i-1).name(1:end-2), '_help.html'];
			nextM=mFileData(i+1).name;
			nextHtml=[mFileData(i+1).name(1:end-2), '_help.html'];
			extraContents=sprintf('<hr><a href="index.html">Top page</a>&nbsp;&nbsp;&nbsp;Next: <a href="%s">%s</a>&nbsp;&nbsp;&nbsp;Prev:<a href="%s">%s</a>', prevHtml, prevM, nextHtml, nextM);
		end
		% ====== Create JS code for using arrors
		jsCode='';
		aLine='<script>'; jsCode=sprintf('\n%s%s\n', jsCode, aLine);
		aLine='function keyFunction(){'; jsCode=sprintf('%s%s\n', jsCode, aLine);
		aLine=sprintf('if (event.keyCode==37) document.location="%s";', prevHtml); jsCode=sprintf('%s%s\n', jsCode, aLine);
%		aLine=sprintf('if (event.keyCode==38) document.location="index.html";'); jsCode=sprintf('%s%s\n', jsCode, aLine);
		aLine=sprintf('if (event.keyCode==39) document.location="%s";', nextHtml); jsCode=sprintf('%s%s\n', jsCode, aLine);
		aLine=sprintf('if (event.keyCode==69) document.location="matlab: edit %s";', mFile); jsCode=sprintf('%s%s\n', jsCode, aLine);
		aLine='}'; jsCode=sprintf('%s%s\n', jsCode, aLine);
		aLine='document.onkeydown=keyFunction;'; jsCode=sprintf('%s%s\n', jsCode, aLine);
		aLine='</script>'; jsCode=sprintf('%s%s\n', jsCode, aLine);
		extraContents=[extraContents, jsCode];
		[parentDir, mainName, extName]=fileparts(mFileData(i).name);
		if outputDir(end)=='/' | outputDir(end)=='\', outputDir(end)=[]; end
		tempMFile=[outputDir, '/', mainName, '_help.m'];
		htmlFile=[outputDir, '/', mainName, '_help.html'];
		% ====== Insert JS code into html
		if exist(htmlFile, 'file')
			contents=fileread(htmlFile);
			pat = '</body></html>';
			newContents=regexprep(contents, pat, extraContents);
			% === Link for editing the m file. This line is to be removed later.
		%	newContents=[newContents, sprintf('<p><a href="matlab: edit %s">Edit %s</a>', mFile, mFile)];
			newContents=[newContents, '</body></html>'];
			fid=fopen(htmlFile, 'w'); fprintf(fid, '%s\n', newContents); fclose(fid);
		else
			fprintf('Cannot find %s!\n', htmlFile);
		end
	catch ME
		fid=fopen(errorLogFile, 'w'); fprintf(fid, '%s\n', mFile); fclose(fid);
		exceptionPrint(ME, errorLogFile);
	end
end
%if exist(errorLogFile, 'file'), dos(['start ', errorLogFile]); end	% This will find other errorLogFile in the search path
if ~isempty(dir(errorLogFile)), system(errorLogFile); end

% ====== Generate index.html
indexFile=sprintf('%s/index.html', outputDir);
allDoc=[mFileData.doc];
category={allDoc.category};
uniqueCategory=unique(category);

fprintf('Writing %s...\n', indexFile);
fid=fopen(indexFile, 'w');
fprintf(fid, '<html><body>\n');
fprintf(fid, '<h1 align=center>%s</h1>\n', tbInfo.name);
fprintf(fid, '<h2 align=center>Version %s, for MATLAB %s</h2>\n', tbInfo.version, version);
fprintf(fid, '<ul>\n');
for i=1:length(uniqueCategory)
	fprintf(fid, '<li>%s\n', uniqueCategory{i});
	index=find(strcmp(category, uniqueCategory{i}));
	temp=mFileData(index);
	fieldWidth=maxStrLen({temp.name})-2;
	fprintf(fid, '\t<ul>\n');
	for j=1:length(index)
		fprintf(fid, '<li><a target=_blank href="%s_help.html">%s</a>: %s\n', mFileData(index(j)).name(1:end-2), mFileData(index(j)).name(1:end-2), mFileData(index(j)).doc.purpose);
	end
	fprintf(fid, '</ul>\n');
end
fprintf(fid, '</ul>\n');
fprintf(fid, '</body></html>\n');
fclose(fid); 
fprintf('Open the index file within help browser...\n');
%system(indexFile);
web(indexFile);		% Open the index file within browser

% ====== List of M-files without example/description
temp=[mFileData.doc];
exampleStr={temp.example};
descriptionStr={temp.description};
if any(isEmpty4cell(exampleStr)) || any(isEmpty4cell(exampleStr))
	errorLogFile=[tempname, '.html'];
	fid=fopen(errorLogFile, 'w');
	fprintf(fid, '<html>\n<body>\n<ul>\n');
	fprintf(fid, '<li>Without example:\n');
	fprintf(fid, '<ol>\n');
	for i=1:length(mFileData)
		if isempty(mFileData(i).doc.example)
			fprintf(fid, '<li><a href="matlab: edit %s">%s</a>\n', mFileData(i).name, mFileData(i).name);
		end
	end
	fprintf(fid, '</ol>\n');
	fprintf(fid, '<li>Without description:\n');
	fprintf(fid, '<ol>\n');
	for i=1:length(mFileData)
		if isempty(mFileData(i).doc.description)
			fprintf(fid, '<li><a href="matlab: edit %s">%s</a>\n', mFileData(i).name, mFileData(i).name);
		end
	end
	fprintf(fid, '</ol>\n');
	fprintf(fid, '</ul>\n');
	fprintf(fid, '</body>\n</html>\n');
	system(errorLogFile);
	%web(errorLogFile);
end
