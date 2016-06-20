function tbDocGen4userGuide
% tbDocGen4userGuide: Generate user guides, etc, from helpCore/*.m

helpCoreDir='helpCore';
% ====== Publish /help*.m put the generated html file into "help" directory
mFileData=dir('helpCore/*.m');
mFiles=sort({mFileData.name});
%mFiles={'tb_functions_by_cat', 'tb_product_page', 'tb_release_notes', 'tb_features', 'tb_getting_started', 'tb_user_guide', 'tb_system_requirements'};
% === Add the toolbox path
addpath(pwd);
cd(helpCoreDir);
for i=1:length(mFiles)
	fprintf('%d/%d: Publishing %s...\n', i, length(mFiles), mFiles{i});
	publish(mFiles{i}, struct('format', 'html', 'outputDir', '../help'));
end
cd ..

% ====== Copy helpCore/*.gif to "help" folder
temp=dir('helpCore/*.gif');
if ~isempty(temp)
	copyfile('helpCore/*.gif', 'help');
end