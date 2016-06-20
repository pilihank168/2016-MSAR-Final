function [width, height]=jpegResize(jpgFile, ratio, newJpgFile)
% jpegResize: Resize a jpeg photo
%	Usage: function [width, height]=jpegResize(jpgFile, ratio, newJpgFile)

if nargin<1, selfdemo; return; end
if nargin<2, ratio=0.5; end
if nargin<3, newJpgFile=[jpgFile(1:end-4), '_new.jpg']; end

cmd=['d:\users\jang\matlab\toolbox\utility\jpegRS.exe ', jpgFile];
[s, w]=dos(cmd);
items=split(deblank(w), ' ');
width=eval(items{1});
height=eval(items{2});
newHeight=round(height*ratio);
newWidth=round(width*ratio);
cmd=['d:\users\jang\matlab\toolbox\utility\jpegRS.exe ', jpgFile, ' ', int2str(newWidth), ' ', int2str(newHeight), ' ', newJpgFile];
dos(cmd);
fprintf('Resizing %s to %s (ratio=%f)\n', jpgFile, newJpgFile, ratio);

% ====== Self demo
function selfdemo
jpgFile='IMG_8242.jpg';
ratio=0.25;
feval(mfilename, jpgFile, ratio);

% ====== Sub-function
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