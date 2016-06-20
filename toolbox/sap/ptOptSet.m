function ptOpt=ptOptSet(fs, nbits, pfType)
% ptOptSet: Set PT (pitch tracking) parameters
%
%	Usage:
%		ptOpt=ptOptSet(fs, nbits, pfType)
%
%	Description:
%		ptOpt=ptOptSet(fs, nbits, pfType) returns the parameters for pitch tracking.
%			fs: sample rate
%			nbits: bit resolution
%			pfType: 0 for AMDF, 1 for ACF.
%		By default, this function will give a frameSize and overlap that lead to a frameDuration of 32 ms and frameRate of 31.25.
%		You can modify the output as necessary for pitch tracking.
%		If any field names are changed, you also need to update ptByDpOverPfMex.cpp.
%
%	Example:
%		ptOpt=ptOptSet(8000, 8, 1)

if nargin<1, fs=8000; end
if nargin<2, nbits=8; end
if nargin<3, pfType=1; end		% ACF by default, for better performance

%% ====== �T�w�ѼơA�Фŭק�
ptOpt.frameDuration=32;		% Duration (in ms) of a frame
ptOpt.hopDuration=32;		% Duration (in ms) of a frame hop
ptOpt.fs=fs;			% �����W�v
ptOpt.nbits=nbits;		% �줸�ѪR��
ptOpt.pfType=pfType;		% pitch function type, 0 for AMDF, 1 for ACF
ptOpt.alpha=1;		% This is used for pfWeight, used in frame2pitch. Only for ACF and method=1.
					% alpha=0 corresponds exactly to normalized ACF, which is likely to have half-pitch error
					% alpha=1 corresponds roghtly to tapering ACF, which is likely to have double-pitch error
					% The best value of alpha is obtained via exhaustive search
ptOpt.minPitch=30;								% �̧C����
ptOpt.maxPitch=86;								% �̰�����
ptOpt.usePitchSmooth=1;
ptOpt.resampleRatio=1;		% Resample the waveform. 2 for taking the odd-index samples, etc.
%% ====== Derived quantities
ptOpt.frameSize=round(ptOpt.frameDuration*ptOpt.fs/1000);
%if mod(ptOpt.frameSize, 2)==1, ptOpt.frameSize=ptOpt.frameSize+1; end	% Keep frameSize even
ptOpt.overlap=round((ptOpt.frameDuration-ptOpt.hopDuration)*fs/1000);
ptOpt.frameRate=ptOpt.fs/(ptOpt.frameSize-ptOpt.overlap);
ptOpt.freqRange=pitch2freq([ptOpt.minPitch, ptOpt.maxPitch]);	% Used in frame2pitch
if pfType==0, ptOpt.pdf='amdf'; end		% Used in frame2pitch
if pfType==1, ptOpt.pdf='acf'; end		% Used in frame2pitch
%% ====== Options for frame2pitch
ptOpt.method=1;						% For 'acf', 'amdf'
ptOpt.maxShift=ptOpt.frameSize;		% For 'acf', 'amdf'
ptOpt.zeroPaddedFactor=16;			% For 'hps', 'ceps'
ptOpt.useParabolicFit=0;			% 1 for useing parabolic fit
%% ====== ���ت��פά۾F���ح��|�I��
switch(ptOpt.fs)
	case 8000
	%	ptOpt.frameSize=256; ptOpt.overlap=128;	% frame rate = 62.50
	%	ptOpt.frameSize=256; ptOpt.overlap=0;	% frame rate = 31.25
	case 16000
	%	ptOpt.frameSize=640; ptOpt.overlap=640-160;	% frameSize �O HTK ���⭿�Aframe rate=100, �f�t�y�����Ѩϥ�
	%	ptOpt.frameSize=512; ptOpt.overlap=0;	% frame rate = 31.25
	otherwise	% Take care of other fs, assuming frame rate=31.25
%		ptOpt.frameSize=round(ptOpt.frameDuration*ptOpt.fs/1000);
%		ptOpt.overlap=ptOpt.frameSize-round(ptOpt.fs/frameRate);
%		if mod(ptOpt.frameSize,2)~=0
%			ptOpt.frameSize=ptOpt.frameSize+1;		% Keep this even for setting pfLen
%		end
end

%% ====== �����l�ܪ��@��Ѽ�
ptOpt.fs=fs;
ptOpt.nbits=nbits;
ptOpt.pfLen=round(ptOpt.frameSize/2);			% ACF/AMDF �������q
ptOpt.absVolTh=2*ptOpt.frameSize*(2^(ptOpt.nbits-8));				% �R����������e��
ptOpt.checkMultipleFreq=1;							% �O�_�i�歿�W�ഫ
ptOpt.maxAmdfLocalMinCount=20*(ptOpt.frameSize/256)*(ptOpt.fs/8000);		% �Y�W�L���ӼơA�����𭵡]���ƻݭn�t�X fs �� frameSize �վ�^
ptOpt.maxPitchDiff=7*(((ptOpt.frameSize-ptOpt.overlap)/ptOpt.fs)/(256/8000));	% �۾F�����I���̤j�t��
ptOpt.minAmdfRange=5*(2^nbits/2^8);			% Normalized by nbits
ptOpt.frame2pitchFcn='frame2pitch';			% �ѭ��حp�⭵�������
ptOpt.mainFun='dpOverPfMat';				% Main function for pitch tracking
ptOpt.useSmooth=1;					% Smooth the final output pitch
ptOpt.useRepeat=1;					% Repeat PT twice, using the median of the first for limiting the second PT
ptOpt.useEpd=1;
ptOpt.useEpdBeforePt=0;					% Perform EPD before PT via DP. Valid only when useEpd=1
%% ====== acf/nsdf �������Ѽ�
ptOpt.clarityTh=0.5;		% k for nsdf
%% ====== dp �������Ѽ�
ptOpt.dpMethod=1;		% dpMethod=1 ===> �H indexDiff �ӫO�����ƫס]���I�G�ﭵ���O�D�u�ʡ^, dpMethod=2 ===> �H pitchDiff �ӫO�����ƫס]�u�I�G�ﭵ���O�u�ʡA���I�G�p��q���j�^
ptOpt.dpPosDiffOrder=2;		% dpPosDiffOrder=1 ===> abs diff, dpPosDiffOrder=2 ===> squared diff
ptOpt.dpUseLocalOptim=0;	% dpUseLocalOptim=0 ===> use all amdf as ppc, dpUseLocalOptim=1 ===> use only local min of amdf as ppc
ptOpt.ppcNum=10;
ptOpt.pitchRangeMax=24;		% Max range of pitch vector. For singing input
ptOpt.pitchDiffMax=5;		% Max pitch difference between two neighboring frame. For singing input
ptOpt.pfWeight=1;		% Default value, to be modified according to different fs, see below
ptOpt.indexDiffWeight=1;	% Default value, to be modified according to different fs, see below
switch(ptOpt.pfType)
	case 0	% AMDF
		ptOpt.pfWeightedByClarity=1;			% To be verified.
		switch(ptOpt.fs)
			case 8000
				if (ptOpt.frameSize==256) & (ptOpt.overlap==176)
					ptOpt.pfWeight=128;		% 40
					ptOpt.indexDiffWeight=159;	% 540
					ptOpt.dpMethod=1;
					ptOpt.dpPosDiffOrder=1;
					ptOpt.dpUseLocalOptim=0;
				end
				if (ptOpt.frameSize==256) & (ptOpt.overlap==0)	% Obtained from goDpParamOptim.m, frameRate=31.25
					ptOpt.pfWeight=1;
					ptOpt.indexDiffWeight=15;
					ptOpt.dpMethod=1;
					ptOpt.dpPosDiffOrder=1;
					ptOpt.dpUseLocalOptim=0;
				end
				if (ptOpt.frameSize==256) & (ptOpt.overlap==128)	% Obtained from goDpParamOptim.m, frameRate=62.5
					ptOpt.pfWeight=100;
					ptOpt.indexDiffWeight=36;
					ptOpt.dpMethod=1;
					ptOpt.dpPosDiffOrder=2;
					ptOpt.dpUseLocalOptim=0;
				end
			case 16000
				if (ptOpt.frameSize==512) & (ptOpt.overlap==0)
					% ====== Parameters for pitchDiffSquare
					ptOpt.pfWeight=32;
					ptOpt.indexDiffWeight=321;
				end
				if ((ptOpt.frameSize==640) & (ptOpt.overlap==480))
					ptOpt.pfWeight=12800;
					ptOpt.indexDiffWeight=700;	% original: 700
					ptOpt.dpMethod=2;
					ptOpt.dpPosDiffOrder=2;
					ptOpt.dpUseLocalOptim=1;
				end
			otherwise
			%	fprintf('Using default parameters (which might not be complete) for fs=%d\n', ptOpt.fs);
		end
	case 1	% ACF
		ptOpt.pfWeightedByClarity=1;			% based on a limited test
		switch(ptOpt.fs)
			case 8000
				if (ptOpt.frameSize==256) & (ptOpt.overlap==0)
					ptOpt.pfWeight=4;
					ptOpt.indexDiffWeight=388;
					ptOpt.dpMethod=2;
					ptOpt.dpPosDiffOrder=1;
					ptOpt.dpUseLocalOptim=1;
					
					ptOpt.pfWeight=250;
					ptOpt.indexDiffWeight=833;
					ptOpt.dpMethod=2;
					ptOpt.dpPosDiffOrder=2;
					ptOpt.dpUseLocalOptim=0;
				end
				if (ptOpt.frameSize==256) & (ptOpt.overlap==128)	% Obtained from goDpParamOptim.m, frameRate=62.5
					ptOpt.pfWeight=1;
					ptOpt.indexDiffWeight=80;
					ptOpt.dpMethod=2;
					ptOpt.dpPosDiffOrder=1;
					ptOpt.dpUseLocalOptim=1;
				end
				if (ptOpt.frameSize==256) & (ptOpt.overlap==176)
					ptOpt.pfWeight=1;
					ptOpt.indexDiffWeight=345;
					ptOpt.dpMethod=2;
					ptOpt.dpPosDiffOrder=1;
					ptOpt.dpUseLocalOptim=0;
				end
			case 16000
				if (ptOpt.frameSize==640) & (ptOpt.overlap==480)
				%	ptOpt.pfWeight=1;
				%	ptOpt.indexDiffWeight=4;
				%	ptOpt.dpMethod=2;
				%	ptOpt.dpPosDiffOrder=2;
				%	ptOpt.dpUseLocalOptim=1;
					ptOpt.pfWeight=1;
					ptOpt.indexDiffWeight=6;
					ptOpt.dpMethod=1;
					ptOpt.dpPosDiffOrder=2;
					ptOpt.dpUseLocalOptim=0;
				end
			otherwise
			%	fprintf('Using default parameters (which might not be complete) for fs=%d\n', ptOpt.fs);
		end
	case 2	% NSDF
		% Nothing here
	case 3	% SHS
		% Nothing here	
	otherwise
		error(sprintf('Unsupported pfType=%d!', ptOpt.pfType));
end
%% ====== Parameters for removing unreliable pitch (due to silence or unvoiced sounds)
ptOpt.useHmm4suvDetection=0;
ptOpt.useVolThreshold=1;		% volRatio is determine by epdByVol.
ptOpt.useClarityThreshold=1;
ptOpt.clarityRatio=0.5;			% Effective only when useClarityThreshold=1
ptOpt.localMaxCountThresholding=0;
ptOpt.localMaxCountRatio=0.5;		% Effective only when localMaxCountThresholding=1
%% ====== Parameters for pre processing
%% ====== frame normalization
ptOpt.zeroMeanPolyOrder=6;		% Order of polynomial for zero justification
ptOpt.siftOrder=0;				% Order for SIFT (20 to get decent result; 0 for nothing at all)
ptOpt.useWaveEnhancement=0;		% Apply wave enhancement
ptOpt.useLowPassFilter=0;		% Apply low-pass filtering on the input waveform
ptOpt.useHighPassFilter=0;		% Apply high-pass filtering on the input waveform
%% ====== Parameters for post processing
ptOpt.medianFilterOrder=0;		% Use median filter to smooth pitch (Not necessary for pitchTrackingForcedSmooth.m)
ptOpt.useParabolicFit=1;		% Apply parabola for finding the min/max of the pitch function
ptOpt.cutLeadingTrailingZero=0;
%% ====== Parameter for forcing smooth by changing indexDiffWeight (used in pitchTrackingForcedSmooth.m)
ptOpt.pitchDiffTh=8;
ptOpt.roundNum=12;
ptOpt.searchMethod='binarySearch';	% 'binarySearch' or 'linearSearch'
ptOpt.leftBound=0;
ptOpt.rightBound=5000;	% for binary search only
ptOpt.boundRangeTh=10;
%% ====== Parameters for PT performance evaluation
ptOpt.pitchTol=0.5;			% Tolerance for computing pitch accuracy
ptOpt.useSil4perfEval=0;
