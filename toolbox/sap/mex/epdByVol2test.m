% epdByVol2.m �M epdByVol2mex.dll ���P�B����
mex epdByVol2mex.cpp d:/users/jang/c/lib/audio.cpp d:/users/jang/c/lib/utility.cpp

addpath d:\users\jang\matlab\toolbox\audioProcessing
addpath d:\users\jang\matlab\toolbox\utility

% ��@�ɮ״���
%waveFile='D:\users\jang\application\pmpWaveFile\1.wav';
%[y, fs, nbits]=wavReadInt(waveFile);
%[endPoint, volume, zcr, soundSegment] = epdByVol2(y, fs, nbits, 1);
%endPointIndex = epdByVol2mex(y, fs);

% �h���ɮ״���
waveFiles=recursiveFileList('C:\dataSet\�굦�|-���y\pmpWaveFile', 'wav');
waveNum=length(waveFiles);
for i=1:waveNum
	waveFile=waveFiles(i).path;
	fprintf('%d/%d: %s\n', i, waveNum, waveFile);
	[y, fs, nbits]=wavReadInt(waveFile);
	[endPoint, volume, zcr, soundSegment]=epdByVol2(y, fs, nbits, 1);
	temp=[[soundSegment.beginFrame]; [soundSegment.endFrame]];
	epIndex1=temp(:)';
	epIndex2 = epdByVol2mex(y, fs);
	same=isequal(epIndex1, epIndex2);
	if same~=1
		fprintf('Not equal!\n');
	else
		fprintf('Equal!\n');
	end
	fprintf('Press any key to continue...'); pause; fprintf('\n');
end