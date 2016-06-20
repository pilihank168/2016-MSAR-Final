function output=grep(filename, pattern)

output=[];
fid = fopen(filename, 'r');
lineNum = 0;
while feof(fid) == 0,
	line = fgetl(fid);
	matched = strfind(line, pattern);
	if ~isempty (matched)
		output=strcat(output, sprintf('%s, line %d: %s \n', filename, lineNum, line));
	end
	lineNum = lineNum + 1;
end

fclose(fid);
