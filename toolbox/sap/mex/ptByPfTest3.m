addMyPath;
clear all; close all;

%fprintf('Compiling ptByPfMex.cpp...\n');
%mex -Id:/users/jang/c/lib -Id:/users/jang/c/lib/audio -Id:/users/jang/c/lib/utility -Id:/users/jang/c/lib/wave ptByPfMex.cpp d:/users/jang/c/lib/audio/audio.cpp d:/users/jang/c/lib/utility/utility.cpp d:/users/jang/c/lib/wave/waveRead4pda.cpp -output ptByPfMex.dll

waveFile='..\�D�H�U���Ȧb��.wav';
waveFile='..\���a���k�����.wav';
waveFile='..\�����s�����N�b.wav';
waveFile='..\twinkle_twinkle_little_star.wav';
%waveFile='D:\dataSet\childSong\childSong_wav\2007-���T�B�z�P����/932013���R�N/�p�P�P_����_0.wav';
%waveFile='D:\dataSet\childSong\childSong_wav\2007-���T�B�z�P����/932013���R�N/�p���j_����_0.wav';
%waveFile='D:\dataSet\childSong\childSong_wav\2007-���T�B�z�P����/946352���Z��/��o��_����_0.wav';
%waveFile='D:\dataSet\childSong\childSong_wav\2006-���T�B�z�P����/943764�η祭/�C�l�u_����_0.wav';

[y, fs, nbits]=wavReadInt(waveFile);
fprintf('waveFile=%s\n', waveFile);

dataMode=1; pfType=1; ptOpt=ptOptSet(fs, nbits, pfType);
ptOpt.medianFilterOrder=0;

tic
ptOpt.useVolThreshold=0; ptOpt.cutLeadingTrailingZero=0;
[pitch1, clarity1]=ptByPfMex(y, fs, nbits, ptOpt, dataMode);
fprintf('Time for ptByPfMex = %g seconds when pfType=%d and dataMode=%d\n', toc, pfType, dataMode);

tic
ptOpt.useVolThreshold=1; ptOpt.cutLeadingTrailingZero=0;
[pitch2, clarity2]=ptByPfMex(y, fs, nbits, ptOpt, dataMode);
fprintf('Time for ptByPfMex = %g seconds when pfType=%d and dataMode=%d\n', toc, pfType, dataMode);

tic
ptOpt.useVolThreshold=1; ptOpt.cutLeadingTrailingZero=1;
[pitchTemp, clarityTemp]=ptByPfMex(y, fs, nbits, ptOpt, dataMode);
fprintf('Time for ptByPfMex = %g seconds when pfType=%d and dataMode=%d\n', toc, pfType, dataMode);
pitch3=nan*pitch1; pitch3(1:length(pitchTemp))=pitchTemp;
clarity3=nan*clarity1; clarity3(1:length(clarityTemp))=clarityTemp;

subplot(2,2,1); plot([pitch1', pitch2', pitch3'-20000], '.-'); title('Pitch'); legend('pitch1 w/o volume thresholding', 'pitch2 with volume thresholding', 'pitch3 with removal of leading/trailing zeros');
subplot(2,2,2); plot([clarity1', clarity2', clarity3'-200], '.-'); title('Clarity'); legend('clarity1', 'clarity2', 'clarity3');
subplot(2,2,3); plot(abs(pitch1-pitch2), '.-'); title('Difference between pitch1 and pitch2');
subplot(2,2,4); plot(abs(clarity1-clarity2), '.-'); title('Difference between clarity1 and clarity2');

return

for i=1:10000
	fprintf('%d/%d\n', i, 10000);
	ptOpt.useVolThreshold=0;
	[pitch2, clarity2]=ptByPfMex(y, fs, nbits, ptOpt, dataMode);
end