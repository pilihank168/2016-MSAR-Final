function exceptionPrint(exception, errorLogFile)

if nargin==2
	fid=fopen(errorLogFile, 'a');
else
	fid=1;
end

fprintf(fid, '\tidentifier: %s\n', exception.identifier);
fprintf(fid, '\tmessage: %s\n', exception.message);
fprintf(fid, '\tstack:\n');
for i=1:length(exception.stack)
	fprintf(fid, '\t\tstack(%d).file: %s\n', i, exception.stack(i).file);
	fprintf(fid, '\t\tstack(%d).name: %s\n', i, exception.stack(i).name);
	fprintf(fid, '\t\tstack(%d).line: %d\n', i, exception.stack(i).line);
end

if nargin==2
	fclose(fid);
end