function tbPrepare
%tbPrepare: Toolbox preparation (via document generation)

addpath d:/users/jang/matlab/toolbox/utility
addpath d:/users/jang/matlab/toolbox/machineLearning
close all; more off;

myTicForTbPrepare=tic;

% ====== Recompile all mex files, as follows. (You need to do this on multiple platforms!) 
%{
if exist('mex')==7
	zzz=tic;
	cd mex
	[a,b]=dos('goFileUpdate.bat');
	tbMexCompile('demo');
	cd ..
	fprintf('##### 1/8: tbMexCompile ===> %f sec\n', toc(zzz));
end
%}

% ====== To copy necessary m file from the utility toolbox to "private" directory.
zzz=tic;
tbPrivateGen;
fprintf('##### 2/8: tbPrivateGen ===> %f sec\n', toc(zzz));

% ====== To generate Contents.m.
zzz=tic;
tbContentPageGen;
fprintf('##### 3/8: tbContentPageGen ===> %f sec\n', toc(zzz));

% ====== To generate info.xml from info_template.xml. 
zzz=tic;
tbInfoPageGen;
fprintf('##### 4/8: tbInfoPageGen ===> %f sec\n', toc(zzz));

% ====== Create doc for each function
zzz=tic;
tbDocGen4fcn('all');
fprintf('##### 5/8: tbDocGen4fcn ===> %f sec\n', toc(zzz));

% ====== Create helpCore/tb_functions_by_cat.m 
zzz=tic;
tbFcnListGen
fprintf('##### 6/8: tbFcnListGen ===> %f sec\n', toc(zzz));

% ====== Create helpCore/tb_functions_by_cat.m 
zzz=tic;
tbHelpTocPageGen
fprintf('##### 7/8: tbHelpTocPageGen ===> %f sec\n', toc(zzz));

% ====== Publish helpCore/*.m 
zzz=tic;
tbDocGen4userGuide
fprintf('##### 8/8: tbDocGen4userGuide ===> %f sec\n', toc(zzz));

fprintf('Overall time = %f sec\n', toc(myTicForTbPrepare));
