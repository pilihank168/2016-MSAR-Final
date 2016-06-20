clear all

%fprintf('Compiling epdByVolHodMex.cpp...\n');
%mex epdByVolHodMex.cpp d:/users/jang/c/lib/audio.cpp d:/users/jang/c/lib/utility.cpp

addMyPath
waveFile='../��������L����+sil.wav';
waveFile='../�E�L���������.wav';
waveFile='C:\dataSet\�굦�|-���y\pmp-epd\0001_16k.wav';
waveFile='../csNthu_omniMic.wav';
waveFile='../�~��ӫҦ����O.wav';
waveFile='../���Ω]�Ħ��ɱJ.wav';
waveFile='../�P�{�U���.wav';
waveFile='../���m���p�X�A�y.wav';
%waveFile='../�L��N�x���R�k.wav';
%waveFile='../���w���Y�Y�կQ.wav';
%waveFile='../��ǲᬰ����u.wav';
waveFile='../�j���Y��.wav';
waveFile='../�ݧg��Ҥ�.wav';
waveFile='../��������.wav';
waveFile='../���J����t.wav';
waveFile='../��������.wav';
waveFile='../���M�D�@��.wav';
waveFile='../�����d�a�D�ԥ�.wav';
waveFile='../�y�y�Ƶ�Ӯ.wav';
waveFile='../�کm�s�Хs�s�Я¤l.wav';
waveFile='C:\dataSet\�i�굦�|�j�饻�ػy�Ѯv�|�ܿ���\lesson01\student\�ڬO�R���Q�o�j�Ǫ��ǥ�.wav';
waveFile='../file19.wav';
waveFile='../file56.wav';
[wave, fs, nbits]=wavReadInt(waveFile);
epdPrm=epdPrmSet(fs);
plotOpt = 1;
[ep1, epFrameId1, segment, vol, hod, vh] = epdByVolHod(wave, fs, nbits, epdPrm, plotOpt);
[ep2, epFrameId2] = epdByVolHodMex(wave, fs, nbits, epdPrm);
subplot(3,1,1);
line(ep2(1)*[1 1]/fs, [min(wave), max(wave)], 'color', 'r', 'linewidth', 2);
line(ep2(2)*[1 1]/fs, [min(wave), max(wave)], 'color', 'r', 'linewidth', 2);
if isequal(ep1, ep2)
	fprintf('Same endpoints!\n');
else
	fprintf('Different endpoints!\n');
	fprintf('Dev1: %g - %g = %g\n', ep1(1), ep2(1), ep1(1)-ep2(1));
	fprintf('Dev2: %g - %g = %g\n', ep1(2), ep2(2), ep1(2)-ep2(2));
end