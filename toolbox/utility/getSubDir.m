function subDirs=getSubDir(givenDir)
% getSubDir: Get sub-directories of a given directory
%
%	For example:
%		subDirs=getSubDir('c:/windows')

% Roger Jang, 20050519, 20071009

subDirs=dir(givenDir);
subDirs(1:2)=[];
subDirs=subDirs([subDirs.isdir]);