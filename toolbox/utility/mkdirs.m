function mkdirs(dirPath)
%mkdirs: Make several directories along a given path of all directories
%	Usage: mkdirs(dirPath)

%	Roger Jang, 20090203, 20100204

if nargin<1, selfdemo; return; end

newPath=strrep(dirPath, '\', '/');	% Convert to unix format
terms=split(newPath, '/');

if newPath(1)=='/'	% newPath='/users/jang/batch'
	terms{1}=['/', terms{1}];
end
if ~isempty(strfind(terms{1}, ':'))	% newPath='d:/users/jang/batch'
	terms{1}=[terms{1}, '/', terms{2}];
	terms(2)=[];
end

% Create each dir
for i=1:length(terms)
	dirName=join(terms(1:i), '/');
	if exist(dirName)~=7
		fprintf('Make directory %s\n', dirName);
		mkdir(dirName);
	end
	
end

% ====== Self demo
function selfdemo
dirPath='d:/users/jang/temp/junk/test';
mkdirs(dirPath);
fprintf(['Use "rmdir(''', 'd:/users/jang/temp/junk', ''', ''s'')" to remove junk directory and everything under it.\n']);