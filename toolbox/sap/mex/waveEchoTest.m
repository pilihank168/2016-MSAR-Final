mex waveEchoMex.cpp

waveFile='�D�H�U���Ȧb��.wav';
waveFile='D:\users\jang\company\���B\�R����\Track03.wav';

[y, fs, nbits]=wavRead(waveFile);

delay=0.3;
gain=0.82;
tic
y2=waveEchoMex(y, fs, delay, gain);
fprintf('Computation time = %f\n', toc);

%fprintf('Hit return to hear the original:'); pause; fprintf('\n');
%wavPlay(y, fs);
%fprintf('Hit return to hear the echoed sound:'); pause; fprintf('\n');
%wavPlay(y2, fs);

tempWaveFile=[tempdir, 'test.wav'];
fprintf('Save echoed wave file to %s\n', tempWaveFile);
wavWrite(y2, fs, nbits, tempWaveFile);
dos(['start ', tempWaveFile]);