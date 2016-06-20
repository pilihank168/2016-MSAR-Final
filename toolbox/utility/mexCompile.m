function mexCompile(cFileList)
% mexCompile: 對所有的 mex/dll 檔案進行必要的編譯

if nargin<1
	cFiles=dir('*.cpp');
	cFileList = {cFiles.name};
end

if strcmp(class(cFileList), 'char')
	cFileList={cFileList};
end

clear mex

for i=1:length(cFileList),
	cFile = cFileList{i};
	[junk, main, junk]=fileparts(cFileList{i});
	dllFile = [main, '.dll'];
	includedFiles = findInc(cFile);
	includedFiles = {includedFiles{:}, cFile};
	needCompile = 0;
	if isempty(dir(dllFile)),
		needCompile = 1;
	else	% Check dependency
		fileInfo = dir(dllFile);
%		fprintf('dllFile=%s\n', dllFile);
%		fprintf('size=%d\n', length(fileInfo));
%		fprintf('fileInfo.date=%s\n', fileInfo.date);
		dllDate = datenum(c2emonth(fileInfo.date));
		for j=1:length(includedFiles),
			if exist(includedFiles{j}),
				fileInfo = dir(includedFiles{j});
				incDate = datenum(c2emonth(fileInfo.date));
				if incDate>dllDate,
					needCompile=1;
					break;
				end
			end
		end
	end

	if needCompile,
		fprintf('Compiling %s... ===> ', cFile);
		eval(['mex ', cFile]);
		currDir=pwd;				% D:\users\jang\matlab\toolbox\audio_mex
		targetDir=currDir(1:end-4);		% D:\users\jang\matlab\toolbox\audio
		copyfile(dllFile, targetDir);
		fprintf('Copied %s to %s directory.\n', dllFile, targetDir);
	else
		fprintf('No need to recompile "%s"\n', cFile);
	end
end