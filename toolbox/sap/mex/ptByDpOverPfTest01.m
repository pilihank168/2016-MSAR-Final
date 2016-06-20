clear all; addMyPath;
fprintf('Compiling ptByDpOverPfMex.cpp...\n');
mex -I/users/jang/c/lib -I/users/jang/c/lib/audio -I/users/jang/c/lib/utility ptByDpOverPfMex.cpp /users/jang/c/lib/audio/audio.cpp /users/jang/c/lib/utility/utility.cpp
fprintf('Finish compiling ptByDpOverPfMex.cpp\n');
dos('copy /y ptByDpOverPfMex.mex* ..');
addpath ..
fprintf('Test ptByDpOverPfMex...\n');

waveFile='lately2.wav';		% 16 kHz, 16 bits
waveFile='../������n��.wav';
waveFile='�����s�����N�b.wav';
%waveFile='yi_cuen_xiang_s_yi_cuen_huei.wav';
%waveFile='what_movies_have_you_seen_recently.wav';
%waveFile='what_would_you_like_to_know.wav';
%waveFile='/dataset/tangPoem/2007-���T�B�z�P����/92502067�L�l��/�G����ϭ��W�L.wav';
waveFile='yankee_doodle.wav';		% 8K, 8bit
waveFile='D:\dataSet\dean\201005-mirRecording\Record_Wave\让v_1\��a_�i��_1.wav';
waveFile='D:\dataSet\dean\201005-mirRecording\Record_Wave\让v_1\���u�O�B��_���p�[_2.wav';
waveFile='D:\dataSet\dean\201005-mirRecording\Record_Wave\让v_1\�K�L��V_���p��_1.wav';
waveFile='D:\dataSet\dean\201005-mirRecording\Record_Wave\让v_1\��n���P_����_1.wav';
%waveFile='D:\dataSet\dean\201005-mirRecording\Record_Wave\Demo_0\�n�߱�_����.wav';
%waveFile='D:\dataSet\dean\201005-mirRecording\Record_Wave\Demo_1\�Ⱖ�Ѫ�_����_0_s_2.wav';
%waveFile='D:\dataSet\dean\201005-mirRecording\Record_Wave\renee_0\�@���鱡_�ŤߵD_1.wav';
%waveFile='yankee_doodle.wav';		% 8K, 8bit
waveFile='/dataSet/childSong/2007-���T�B�z�P����/19461108���Τ���/�Q�ӦL�Ħw�H_����_0.wav';
waveFile='D:\dataSet\dean\201005-mirRecording\Record_Wave\让v_1/�B�B_�B�w��_1.wav';
waveFile='D:\dataSet\dean\201005-mirRecording\Record_Wave/�d����_1/��G�S����_�i�t_1_s.wav';
waveFile='D:\dataSet\dean\201005-mirRecording\Record_Wave/������_1/�d�����~_�P�N��.�O�ɲM_1_s.wav';
%waveFile='D:\dataSet\dean\201005-mirRecording\Record_Wave\让v_1\�@��p�B��_�x�a��_5.wav';
waveFile='D:\dataSet\dean\201005-mirRecording\Record_Wave\让v_1/�B�B_�B�w��_1.wav';
wObj=myAudioRead(waveFile);
if wObj.fs==16000
	wObj=wObj2wObj(wObj, 8000, 16, 1);
end

pfType=1;	% 0 for AMDF, 1 for ACF
ptOpt=ptOptSet(wObj.fs, wObj.nbits, pfType);
tic
%[pitch1, clarity, pfMat]=pitchTracking(wObj, ptOpt, 1);
[pitch1, clarity, pfMat]=pitchTracking(wObj, ptOpt, 1);
toc

frameNum=floor((length(wObj.signal)-ptOpt.overlap)/(ptOpt.frameSize-ptOpt.overlap));
frameTime=frame2sampleIndex(1:frameNum, ptOpt.frameSize, ptOpt.overlap)/wObj.fs;

ptOpt.useVolThreshold=0;
pitch2=pitchTracking(wObj, ptOpt);

ptOpt.useClarityThreshold=0;
pitch3=pitchTracking(wObj, ptOpt);

subplot(5,1,3);
h=get(gca, 'child'); delete(h(1));
pitch1(pitch1==0)=nan;
pitch2(pitch2==0)=nan;
pitch3(pitch3==0)=nan;
line(frameTime, pitch3-6, 'marker', '.', 'color', 'r');
line(frameTime, pitch2-3, 'marker', '.', 'color', 'g');
line(frameTime, pitch1,  'marker', '.', 'color', 'b');
title('Unbroken pitch (red), with clarity thresholding (green), with volume & clarity thresholding (blue)');
axis([-inf inf 30 84]);
