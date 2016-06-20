function vec=binIntFileRead(fileName)
% binIntFileRead: Read an binary file of 4-byte integers
%	Usage: vec=binIntFileRead(fileName)

%	Roger Jang, 20050923

fid = fopen(fileName, 'rb');
vec=fread(fid, inf, 'int32');
fclose(fid);