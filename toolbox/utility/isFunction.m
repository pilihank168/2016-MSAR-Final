function output = isFunction(filename);
% isFunction: Test is the given M-file is a function
%
%	Usage:
%		output=isFunction(filename)
%
%	Description:
%		Determine if a given m file is a MATLAB function
%
%	Example:
%		fileName='isFunction.m';
%		output=isFunction('isFunction.m');
%		if output
%			fprintf('The given M-file "%s" is a function.\n', fileName);
%		else
%			fprintf('The given M-file "%s" is not a function.\n', fileName);
%		end

%	Category: Utility
%	Roger Jang, 20030712

if nargin<1; selfdemo; return; end

fid=fopen(filename);
line=fgetl(fid);
fclose(fid);

start=regexp(line, '^function');
output=0;
if ~isempty(start)
	output=1;
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
