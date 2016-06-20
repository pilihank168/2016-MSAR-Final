function asciiWrite(mat, fileName, format)
% asciiWrite: Write a matrix as an ascii file
%	Usage: asciiWrite(mat, fileName, format)
%		format: format string, such as '%d', '%f', etc.

%	Roger Jang, 20041021

if nargin<1, selfdemo; return; end
if nargin<2, fileName='asciiFile.txt'; end
if nargin<3, format='%g'; end

fid = fopen(fileName, 'w');
for i=1:size(mat,1),
%	fprintf(fid, [format, ' '], mat(i, :));
	str=num2str(mat(i,:), [format, ' ']);
	fprintf(fid, '%s\n', str);
%	fprintf(fid, '\n');
end
fclose(fid);

% ====== Self demo
function selfdemo
x=magic(5);
fileName=tempname;
asciiWrite(x, fileName, '%d');
fprintf('The content of %s is\n', fileName);
type(fileName);