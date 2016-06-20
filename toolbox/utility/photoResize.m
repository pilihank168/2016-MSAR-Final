function photoResize(photoDir, opt)

if nargin<2, opt.size=[400, 600]; end

extName='jpg';
imSet=recursiveFileList(photoDir, extName);
imNum=length(imSet);
fprintf('%d %s are found\n', imNum, extName);
[parentDir, mainName]=fileparts(photoDir);
outputDir=[tempdir, mainName, '_small'];
if ~exist(outputDir, 'dir')
	fprintf('Creating %s...\n', outputDir);
	mkdir(outputDir);
end

for i=1:imNum
	photoPath=imSet(i).path;
	[parentDir, mainName]=fileparts(photoPath);
	im=imread(photoPath);
	im2=imresize(im, opt.size);
	outputFile=[outputDir, filesep, mainName, '.', extName];
	fprintf('%d/%d: file=%s\n', i, imNum, imSet(i).name);
	imwrite(im2, outputFile);
end
