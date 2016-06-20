function tbMexCompileAll

currDir=pwd;

toolbox={'utility', 'sap', 'machineLearning', 'melodyRecognition'};

for i=1:length(toolbox)
	dirName=sprintf('/users/jang/matlab/toolbox/%s/mex', toolbox{i});
	if strcmp(mexext, 'mexglx'), dirName=strrep(dirName, '/users/jang', '/mnt/hgfs/users/jang'); end
	if strcmp(mexext, 'mexmaci'), dirName=strrep(dirName, '/users/jang', '/Volumes/d$/users/jang'); end
	if strcmp(mexext, 'mexmaci64'), dirName=strrep(dirName, '/users/jang', '/Volumes/d$/users/jang'); end
	cd(dirName); fprintf('PWD=%s\n', dirName');
	tbMexCompile;
end

cd(currDir);

return

currDir=pwd;

dirName='/users/jang/matlab/toolbox/utility/mex';
if strcmp(mexext, 'mexglx'), dirName=strrep(dirName, '/users/jang', '/mnt/hgfs/users/jang'); end
if strcmp(mexext, 'mexmaci'), dirName=strrep(dirName, '/users/jang', '/Volumes/d$/users/jang'); end
cd(dirName); fprintf('PWD=%s\n', dirName');
goMexCompile;

dirName='/users/jang/matlab/toolbox/sap/mex';
if strcmp(mexext, 'mexglx'), dirName=strrep(dirName, '/users/jang', '/mnt/hgfs/users/jang'); end
if strcmp(mexext, 'mexmaci'), dirName=strrep(dirName, '/users/jang', '/Volumes/d$/users/jang'); end
cd(dirName); fprintf('PWD=%s\n', dirName');
goMexCompile;

dirName='/users/jang/matlab/toolbox/machineLearning/mex';
if strcmp(mexext, 'mexglx'), dirName=strrep(dirName, '/users/jang', '/mnt/hgfs/users/jang'); end
if strcmp(mexext, 'mexmaci'), dirName=strrep(dirName, '/users/jang', '/Volumes/d$/users/jang'); end
cd(dirName); fprintf('PWD=%s\n', dirName');
goMexCompile;

dirName='/users/jang/matlab/toolbox/melodyRecognition/mex';
if strcmp(mexext, 'mexglx'), dirName=strrep(dirName, '/users/jang', '/mnt/hgfs/users/jang'); end
if strcmp(mexext, 'mexmaci'), dirName=strrep(dirName, '/users/jang', '/Volumes/d$/users/jang'); end
cd(dirName); fprintf('PWD=%s\n', dirName');
goMexCompile;

cd(currDir);
