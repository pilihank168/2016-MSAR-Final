function pitchPrm = setPP(VCfeatures)

%SETPP Set Pitch Parameters.
%   The program is only for VC related codes.
%
%   Cheng-Yuan Lin, 2003, January, 10.

%These following codes are mainly for ptrackfcn function.
%�ܤ֤@�ӭ��ظ̭n��Ӷg��(�H�̤pfrequency = 50�p��, fs = 8000�I��)
pitchPrm.frameSize = 512;
pitchPrm.overlap = 0;
pitchPrm.maxFreq = 600;
pitchPrm.lowpassOrder = 5;
pitchPrm.clipThred = 0.3;
pitchPrm.maxThred = 0.1;
pitchPrm.ptrakstyle = 0; %1��frame2pitch, 0��ptrackfcn.
pitchPrm.engthred = 0.2;

%These following codes are mainly for tvc function.
if nargin~=0,  
   pitchPrm.frameSize  = VCfeatures.frameSize;
   pitchPrm.overlap    = VCfeatures.overlap;
   pitchPrm.ptrakstyle = 0; %1��frame2pitch, 0��ptrackfcn.
   %�p��engthred���@�w��silence, discard it!
   pitchPrm.engthred = VCfeatures.frameSize*power(0.02,2);
   pitchPrm.zcrthred = VCfeatures.frameSize*(1/20);
   pitchPrm.lowpitch = 60;
   pitchPrm.highpitch = pitchPrm.maxFreq;
end;