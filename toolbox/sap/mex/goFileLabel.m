addpath /users/jang/matlab/toolbox/utility
addpath /users/jang/matlab/toolbox/sap
addpath d:/users/jang/matlab/toolbox/sap/labelingProgram/pitchLabelingProgram

auFile='textbook.wav';
auFile='simplify.wav';
%auFile='pathway.wav';
au=myAudioRead(auFile);
au.signal=mean(au.signal, 2);	% Stereo to mono
% === Down sample to 8000
%targetFs=8000;
%au.signal=resample(au.signal, targetFs, au.fs);		% Resample to targetFs
%au.fs=targetFs;
% === Down sample to 8820
%d=5;
%au.signal=au.signal(1:d:end);
%au.fs=au.fs/d;pitchLabel(au);
pitchLabel(au);
[parentDir, mainName]=fileparts(auFile); items=split(mainName, '-'); targetPitch=str2semitone(items{1});	% Find target pitch
axisLimit=axis; line(axisLimit(1:2), targetPitch*[1 1], 'color', 'r', 'linewidth', 1);	% Plot the target pitch

return

%opt=pitchTrackBasic('defaultOpt');
%showPlot=1;
%pitch=pitchTrackBasic(auFile, opt, showPlot);

pfType=1;	% 0 for AMDF, 1 for ACF
ptOpt=ptOptSet(au.fs, au.nbits, pfType);
ptOpt.mainFun='maxPickingOverPf';
figure; [pitch, clarity]=pitchTrack(au, ptOpt, 1);

return

frameRate=fs/(frameSize-overlap);		% No. of pitch points per sec
pv.fs=16000; pv.nbits=16;				% Specs for saving the synthesized pitch
pv.signal=pv2wave(pitch2, frameRate, pv.fs);		% Convert pitch to wave
pv.amplitudeNormalized=1;
myAudioWrite(pv, 'sooPitchByAcf.wav');	% Save the pv as a wav file