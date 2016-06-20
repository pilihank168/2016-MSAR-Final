function binIntFileWrite(vec, fileName)
% binIntFileWrite: Write an binary file of 4-byte integers
%	Usage: binIntFileWrite(vec, fileName)

%	Roger Jang, 20050923

fprintf('Saving "%s"...\n', fileName);
fid = fopen(fileName, 'wb');
fwrite(fid, vec, 'integer*4');
fclose(fid);