function PP=setPitchPrm(fs, nbits)
% setParamPrm: �]�w pitch tracking ���Ѽ�

if nargin<1, fs=8000; end
if nargin<2, nbits=8; end

% ====== �T�w�ѼơA�Фŭק�
PP.fs=fs;				% �����W�v
PP.nbits=nbits;				% �줸�ѪR��

% ���ت��פά۾F���ح��|�I��
switch(PP.fs)
	case 8000	% �t�X Micron �ϥ�
		PP.frameSize=256;
		PP.overlap=0;
	case 16000	% frameSize �O HTK ���⭿�A�f�t�y�����Ѩϥ�
		PP.frameSize=640;
		PP.overlap=320;
	otherwise	% Take care of fs=11025, 22050, 44100, etc
		PP.frameSize=round(512*PP.fs/11025);
		PP.overlap=round(340*PP.fs/11025);
end

% ====== �����l�ܪ��i�ܰѼơA�i�H�ק�A�]�i�H�[�J�ۤv�w�q���Ѽ�
PP.fs=fs;
PP.nbits=nbits;
PP.maxShift=PP.frameSize/2;				% ACF/AMDF �������q
PP.minPitch = 30;					% �̧C����
PP.maxPitch = 84;					% �̰�����
PP.absVolTh = 2*PP.frameSize*(2^(PP.nbits-8));		% �R����������e��
PP.checkMultipleFreq=1;					% �O�_�i�歿�W�ഫ
PP.maxAmdfLocalMinCount=20*PP.frameSize/256;		% �Y�W�L���ӼơA�����𭵡]���ƻݭn�t�X fs �� frameSize �վ�^
%PP.frame2pitchFcn='frame2pitch';			% �ѭ��حp�⭵�������
%PP.frame2pitchFcn='frame2pitchByAcf';
PP.frame2pitchFcn='myFrame2pitch';

PP.maxFreq=pitch2freq(PP.maxPitch);
PP.minFreq=pitch2freq(PP.minPitch);

% ====== �H�U�O�۫߿��Ѫ��Ѽ�
CP.useRest = 1;				% �O�_�ϥΥ���
PP.duration = 5;			% ��J���T����