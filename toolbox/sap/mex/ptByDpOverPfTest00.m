clear all; addMyPath;
%fprintf('Compiling ptByDpOverPfMex.cpp...\n');
%mex -I/users/jang/c/lib -I/users/jang/c/lib/audio -I/users/jang/c/lib/utility ptByDpOverPfMex.cpp /users/jang/c/lib/audio/audio.cpp /users/jang/c/lib/utility/utility.cpp
%fprintf('Finish compiling ptByDpOverPfMex.cpp\n');
%dos('copy /y ptByDpOverPfMex.mex* ..');
%addpath ..
fprintf('Test ptByDpOverPfMex...\n');

waveFile='yankee_doodle.wav';
waveFile='twinkle_twinkle_little_star.wav';
waveFile='10LittleIndians.wav';	% Noisy!
waveFile='textbook.wav';		% Error in pitch tracking!
au=myAudioRead(waveFile);
pvFile=[au.file(1:end-3), 'pv']; if exist(pvFile), au.tPitch=asciiRead(pvFile); end
ptOpt=ptOptSet(au.fs, au.nbits);
pitch=pitchTrack(au, ptOpt, 1);
return

if au.amplitudeNormalized
	au.signal=au.signal*2^(au.nbits-1);
	au.amplitudeNormalized=0;
end
[pitch, clarity, pfMat, dpPath]=ptByDpOverPfMex(au.signal, au.fs, au.nbits, ptOpt);