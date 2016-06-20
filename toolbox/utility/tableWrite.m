function tableWrite(table, file)
% tableWrite: Write a table with tab-separated fields
%	Usage: table=tableWrite(table, file)
%
%	For example:
%		table=tableRead('table01.txt', 1, {'id', 'word', 'count'});
%		outFile=[tempname, '.txt'];
%		fprintf('Write structure to %s\n', outFile);
%		tableWrite(table, outFile);

%	Roger Jang, 20060806, 20071009

colNames=fieldnames(table);
fid=fopen(file, 'w');
for i=1:length(table)
	for j=1:length(colNames)
		if j==1
			fprintf(fid, '%s', getfield(table, {i}, colNames{j}));
		else
			fprintf(fid, '\t%s', getfield(table, {i}, colNames{j}));
		end
	end
	fprintf(fid, '\r\n');
end
fclose(fid);