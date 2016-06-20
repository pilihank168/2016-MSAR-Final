% You need to invoke this program from the directory containing all the m files.

mfileData=dir('*.m');

if exist('tiff')~=7
	fprintf('Creating tiff folder...\n');
	mkdir tiff
end

for i=1:length(mfileData)
	clf;
	mFile=mfileData(i).name;
	cmd=mFile(1:end-2);
	tiffFile=['tiff/', mFile(1:end-2), '.tif'];
	fprintf('%d/%d: %s ===> %s\n', i, length(mfileData), mFile, tiffFile);
	eval(cmd);
	drawnow
	eval(sprintf('print -dtiff %s', tiffFile));
end