function tbHelpTocPageGen
% tbHelpTocPageGen: Generate helptoc.xml from helptoc_template.xml

% ====== Some constants
helpCoreDir='helpCore';
funListMFile=[helpCoreDir, '/tb_functions_by_cat.m'];
tbInfo=toolboxInfo;	% Get the toolbox info

% ====== Read all *.m files
mFileData=dir('*.m');
fprintf('Processing %d m-files for creating %s...\n', length(mFileData), funListMFile);
for i=1:length(mFileData)
	fileName=mFileData(i).name;
%	fprintf('%d/%d: file=%s, ', i, length(mFileData), fileName);
	if strcmp(fileName, 'Contents.m'), continue; end
	mFileData(i).doc=mFileParse(fileName);
%	fprintf('category=%s\n', mFileData(i).doc.category);
end
index=find(strcmp('Contents.m', {mFileData.name}));
mFileData(index)=[];	% Skip contents.m
docs=[mFileData.doc];
category={docs.category};
uniqueCategory=unique(category);

% ====== Create helptoc.xml
% === Create list of functions for helptoc.xml
out=sprintf('%s\n', '<!-- Insert Function List Here! -->');
for i=1:length(uniqueCategory)
%	fprintf('%d/%d: Category=%s\n', i, length(uniqueCategory), uniqueCategory{i});
	if isempty(uniqueCategory{i}), continue; end
	out=sprintf('%s\t\t<tocitem target="tb_functions_by_cat.html#%d">%s\n', out, i, uniqueCategory{i});
	index=find(strcmp(category, uniqueCategory{i}));
	for j=1:length(index)
		mainName=mFileData(index(j)).name(1:end-2);
	%	fprintf('\t%d/%d: mainName=%s\n', j, length(index), mainName);
		out=sprintf('%s\t\t\t<tocitem target="%s_help.html">%s</tocitem>\n', out, mainName, mainName);
	end
	out=sprintf('%s\t\t</tocitem>\n', out);
end
% === Insert the list and create helptoc.xml
templateFile=[helpCoreDir, '/helptoc_template.xml'];
tocFile='help/helptoc.xml';
fprintf('Reading %s...\n', templateFile);
contents=fileread(templateFile);
contents=strrep(contents, '<!-- Insert Function List Here! -->', out);
fprintf('Writing %s (put each function''s doc)...\n', tocFile);
fid=fopen(tocFile, 'w'); fprintf(fid, '%s', contents); fclose(fid);

% === Create list of topics for user guide.
userGuideData=dir('helpCore/userGuide*.m');
for i=1:length(userGuideData)
	[parentDir, mainName, extName]=fileparts(userGuideData(i).name);
	contents= textread(['helpCore/', userGuideData(i).name],'%s','delimiter','\n','whitespace','');
	items=split(mainName, '_');
	category=items{2};
	index=find(isUpper(category));
	index(end+1)=length(category)+1;
	token={};
	for j=1:length(index)-1
		token{j}=category(index(j):index(j+1)-1);
	end
	userGuideData(i).category=join(token, ' ');
	firstLine=contents{1};
	userGuideData(i).topic=strrep(firstLine, '%% ', '');
	userGuideData(i).mainName=mainName;
end
category={userGuideData.category};
uniqueCategory=unique(category);
out=sprintf('%s\n', '<!-- Insert user guide items Here! -->');
for i=1:length(uniqueCategory)
%	fprintf('%d/%d: Category=%s\n', i, length(uniqueCategory), uniqueCategory{i});
	if isempty(uniqueCategory{i}), continue; end
	theCategory=uniqueCategory{i};
	theCategory=strrep(theCategory, '#', ' ');
	out=sprintf('%s\t\t<tocitem target="xxx.html#%d">%s\n', out, i, theCategory);
	index=find(strcmp(category, uniqueCategory{i}));
	for j=1:length(index)
		mainName=userGuideData(index(j)).mainName;
		topic=userGuideData(index(j)).topic;
	%	fprintf('\t%d/%d: mainName=%s\n', j, length(index), mainName);
		out=sprintf('%s\t\t\t<tocitem target="%s.html">%s</tocitem>\n', out, mainName, topic);
	end
	out=sprintf('%s\t\t</tocitem>\n', out);
end
tocFile='help/helptoc.xml';
fprintf('Reading %s...\n', tocFile);
contents=fileread(tocFile);
contents=strrep(contents, '<!-- Insert user guide items Here! -->', out);
fprintf('Writing %s (put user guide)...\n', tocFile);
fid=fopen(tocFile, 'w'); fprintf(fid, '%s', contents); fclose(fid);

% === Create list of topics for demo/app.
demoData=dir('helpCore/application*.m');
for i=1:length(demoData)
	[parentDir, mainName, extName]=fileparts(demoData(i).name);
	contents= textread(['helpCore/', demoData(i).name],'%s','delimiter','\n','whitespace','');
	firstLine=contents{1};
	demoData(i).topic=strrep(firstLine, '%% ', '');
	demoData(i).mainName=mainName;
end
out=sprintf('%s\n', '<!-- Insert Demo List Here! -->');
for i=1:length(demoData)
%	fprintf('%d/%d: Category=%s\n', i, length(uniqueCategory), uniqueCategory{i});
	mainName=demoData(i).mainName;
	topic=demoData(i).topic;
	out=sprintf('%s\t\t<tocitem target="%s.html">%s</tocitem>\n', out, mainName, topic);
end
tocFile='help/helptoc.xml';
fprintf('Reading %s...\n', tocFile);
contents=fileread(tocFile);
contents=strrep(contents, '<!-- Insert Demo List Here! -->', out);
fprintf('Writing %s (put demo/app)...\n', tocFile);
fid=fopen(tocFile, 'w'); fprintf(fid, '%s', contents); fclose(fid);

% ====== Replace TOOLBOX_NAME & TOOLBOX_NAME_ONLY
contents=fileread(tocFile);
items=split(tbInfo.name, ' ');
contents=strrep(contents, 'TOOLBOX_NAME_ONLY', join(items(1:end-1), ' '));
contents=strrep(contents, 'TOOLBOX_NAME', tbInfo.name);
fprintf('Writing %s (replace TOOLBOX_NAME & TOOLBOX_NAME_ONLY)...\n', tocFile);
fid=fopen(tocFile, 'w'); fprintf(fid, '%s', contents); fclose(fid);
