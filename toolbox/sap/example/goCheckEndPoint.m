% ��C�� wave �ɮ׶i����I�����A��ܵ��G�A�ñN���G�g�J�S�w�ؿ�

waveDir='D:\users\jang\matlab\toolbox\asr\application\RMC\waveData\ivr���ѭ���-���';
waveDir=strrep(waveDir, '\', '/');
if isempty(which('findcellstr')); addpath('d:/users/jang/matlab/toolbox/utility'); end
plotOpt=0;
waveFiles=dir([waveDir, '/*.wav']);
for i=1:length(waveFiles)
	fileName=[waveDir, '/', waveFiles(i).name];
	answer=file2answer(fileName);
	fprintf('\n%g/%g: Hit return to play %s (%s):', i, length(waveFiles), fileName, answer);
	if plotOpt, pause; end
	[y, fs, nbits]=wavread(fileName);
	output=endPoint2(y, fs, nbits, [], plotOpt);
	startIndex=output(1);
	endIndex=output(2);
	if plotOpt, subplot(3,1,1); title([fileName, ' (', answer, ')']); end
	newY=y(startIndex:endIndex);
	targetFile=[waveDir, '/cleaned/', waveFiles(i).name];
	wavwrite(newY, fs, nbits, targetFile);
end

%return

% ���տ��Ѳv
currDir=pwd;
cd D:\users\jang\matlab\toolbox\asr\phoneRecog
cmd='scoring D:\users\jang\matlab\toolbox\asr\application\RMC\waveData\ivr���ѭ���-���\cleaned';
dos(cmd);
cd(currDir);