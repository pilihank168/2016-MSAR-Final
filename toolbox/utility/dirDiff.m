function message=dirDif(dir1, dir2, logFile);
%diffDir: Find the difference between two directories
%	Usage: output=dirDiff(dir1, dir2);

if nargin<3, logFile=[tempname, '.log']; end

files1=dir(dir1);
files1=files1(~[files1.isdir]);
names1={files1.name};

files2=dir(dir2);
files2=files2(~[files2.isdir]);
names2={files2.name};

diff1=setdiff(names2, names1);
diff2=setdiff(names1, names2);

fprintf('%d files in "%s" but not in "%s":\n', length(diff1), dir2, dir1);
for i=1:length(diff1)
	fprintf('\t%d/%d: file=%s\n', i, length(diff1), diff1{i});
end

fprintf('%d files in "%s" but not in "%s":\n', length(diff2), dir1, dir2);
for i=1:length(diff2)
	fprintf('\t%d/%d: file=%s\n', i, length(diff2), diff2{i});
end

common=intersect(names1, names2);
fprintf('%d files in common:\n', length(common));

message=[];
for i=1:length(common)
	fprintf('====== file = %s:\n', common{i});
	file1=[dir1, '\', common{i}];
	file2=[dir2, '\', common{i}];
	cmd=['diff "', file1, '" "', file2, '"'];
%	cmd=['fc "', file1, '" "', file2, '"'];
	fprintf('cmd=%s\n', cmd);
	message=sprintf('%s\n%s\n', message, cmd);
	[status, output]=dos(cmd);
	if length(output)~=0
		disp(output);
    end
    message=[message, output];
end
fprintf('Writing %s\n', logFile);
fid=fopen(logFile, 'w');
fprintf(fid, '%s\n', message);
fclose(fid);
dos(['start ', logFile]);
