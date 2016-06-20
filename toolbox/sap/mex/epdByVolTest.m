% epdByVol2.m �M epdByVol2mex.dll ���P�B����
close all; clear all
addMyPath;
fprintf('Compiling epdByVolMex.cpp...\n');
mex epdByVolMex.cpp \users\jang\c\lib\audio\audio.cpp \users\jang\c\lib\utility\utility.cpp \users\jang\c\lib\wave\waveRead4pda.cpp -I/users/jang/c/lib -I/users/jang/c/lib/audio -I/users/jang/c/lib/utility -I/users/jang/c/lib/wave

% ��@�ɮ״���
waveFile='D:\dataSet\�i�g�M��ޡj�y�̽T�{����/�Ǩغ�#0/�j���Y��#2.wav';
waveFile='D:\dataSet\�i�g�M��ޡj�y�̽T�{����/�ծe��#1/�@�E�C��#29_4418_17770.wav';
waveFile='D:\dataSet\�i�g�M��ޡj�y�̽T�{����/���F��#1/��h�y���b��#8_7680_38510.wav';
%waveFile='D:\dataSet\�i�g�M��ޡj�y�̽T�{����/�S�v��#0/�ګܳ��w�Ѯv#7.wav';
waveFile='D:\users\jang\c\lib\audio\example\pt\���ɦh�����}�B_8k8b.wav';
[y, fs, nbits]=wavReadInt(waveFile);
[ep1, epF1]=epdByVol(y, fs, nbits, [], 1);
[ep2, epF2]=epdByVolMex(y, fs, nbits);
if isequal(ep1, ep2)
	fprintf('Equal!\n');
else
	fprintf('Not equal: ep1=%s, ep2=%s, epF1=%s, epF2=%s\n', mat2str(ep1), mat2str(ep2), mat2str(epF1), mat2str(epF2));
end

% Plot the result by epdByVolMex. Remember to set debug=1 in the C program!
figure;
[y, fs, nbits]=wavread(waveFile);
time=(1:length(y))/fs;
subplot(2,1,1); plot(time, y);
load vol.txt
frameNum=length(vol);
subplot(2,1,2); plot(vol); set(gca, 'xlim', [-inf inf]);
load volMax.txt; line([1 frameNum], volMax*[1 1], 'color', 'r');
load volMin.txt; line([1 frameNum], volMin*[1 1], 'color', 'k');
load volTh.txt;  line([1 frameNum], volTh*[1 1], 'color', 'g');



return

% �h���ɮ״���
waveFiles=recursiveFileList('D:\dataSet\�i�g�M��ޡj�y�̽T�{����', 'wav');
waveNum=length(waveFiles);
for i=1:waveNum
	waveFile=waveFiles(i).path;
	fprintf('%d/%d: %s\n', i, waveNum, waveFile);
	[y, fs, nbits]=wavReadInt(waveFile);
	[ep1, epF1]=epdByVol(y, fs, nbits, [], 1);
	[ep2, epF2]=epdByVolmex(y, fs, nbits);
	if isequal(ep1, ep2)
		fprintf('Equal!\n');
	else
		fprintf('Not equal: ep1=%s, ep2=%s, epF1=%s, epF2=%s\n', mat2str(ep1), mat2str(ep2), mat2str(epF1), mat2str(epF2));
	end
	fprintf('Press any key to continue...'); pause; fprintf('\n');
end