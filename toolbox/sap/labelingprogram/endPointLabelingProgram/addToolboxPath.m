% ====== �����[�J Utility Toolbox �M SAP Toolbox
%addpath d:/users/jang/matlab/toolbox/utility
%addpath d:/users/jang/matlab/toolbox/sap

% ====== �g�ѹ�ܵ��[�J Utility �M SAP Toolbox
if exist('recursiveFileList')==0
	fprintf('�Х��U�� Utility Toolbox�]http://mirlab.org/jang/matlab/toolbox/utility.rar�^�å[�J�j�M���|�I\n');
	dirName=uigetdir('', '���I�� Utility Toolbox ���ؿ�');
	addpath(dirName);
end
if exist('frameFlip')==0
	fprintf('�Х��U�� SAP Toolbox�]http://mirlab.org/jang/matlab/toolbox/sap.rar�^�å[�J�j�M���|�I\n');
	dirName=uigetdir('', '���I�� SAP Toolbox ���ؿ�');
	addpath(dirName);
end

% ====== �ˬd MATLAB ����
%desiredVersion='6.5';
%matlabVersion=version;
%if ~strcmp(matlabVersion(1:3), desiredVersion)
%	fprintf('��ĳ�ϥΪ����G%s\n', desiredVersion);
%end