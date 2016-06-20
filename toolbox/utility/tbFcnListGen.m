function tbFcnListGen
% tbFcnListGen: Generate tb_functions_by_cat.m

% ====== Some constants
helpCoreDir='helpCore';
funListMFile=[helpCoreDir, '/tb_functions_by_cat.m'];
tbInfo=toolboxInfo;	% Get the toolbox info

% ====== Create tb_functions_by_cat.m
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
fprintf('Writing %s...\n', funListMFile);
fid=fopen(funListMFile, 'w');
fprintf(fid, '%%%% Functions by Category\n');
fprintf(fid, '%% %s\n', tbInfo.name);
fprintf(fid, '%% Version %s, %s\n', tbInfo.version);
fprintf(fid, '%%\n');
fprintf(fid, '%% Requires MATLAB(R) %s %s\n', version, date);
fprintf(fid, '%%\n');
for i=1:length(uniqueCategory)
%	fprintf('%d/%d: Category=%s\n', i, length(uniqueCategory), uniqueCategory{i});
	if isempty(uniqueCategory{i}), continue; end
	fprintf(fid, '%%%% %s\n', uniqueCategory{i});
	index=find(strcmp(category, uniqueCategory{i}));
	for j=1:length(index)
		mainName=mFileData(index(j)).name(1:end-2);
	%	fprintf('\t%d/%d: mainName=%s\n', j, length(index), mainName);
		fprintf(fid, '%% * <%s_help.html |%s|> - %s\n', mainName, mainName, mFileData(index(j)).doc.purpose);
	end
	fprintf(fid, '%%\n');
end
fclose(fid);
%web(['help/tb_functions_by_cat.html'], '-helpbrowser');