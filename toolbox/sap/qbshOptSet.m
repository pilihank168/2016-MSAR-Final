function qbshOpt=qbshOptSet(matchType, anchorPos)
% qbshOptSet: Set up parameters for QBSH
%	Usage: qbshOpt=qbshOptSet(matchType, anchorPos)
%		matchType: 'wave2midi' or 'wave2wave'
%		anchorPos: 'songStart', 'sentenceStart', or 'noteStart'

%	Roger Jang, 20090925

if nargin<1, matchType='wave2midi'; end
if nargin<2, anchorPos='songStart'; end
if matchType==1, matchType='wave2midi'; end
if matchType==2, matchType='wave2wave'; end
qbshOpt.anchorPos=anchorPos;	% 'songStart', 'sentenceStart', or 'noteStart' [����m]
qbshOpt.matchType=matchType;	% 'wave2midi' or 'wave2wave'
qbshOpt.matchFun='qbshMatch';
%% Add toolbox paths
addpath /users/jang/matlab/toolbox/utility
addpath /users/jang/matlab/toolbox/machineLearning
addpath /users/jang/matlab/toolbox/sap
addpath /users/jang/matlab/toolbox/miditoolbox
%% ====== Paths to files, etc
qbshOpt.waveDir='\dataset\childSong\2009-���T�B�z�P����';
qbshOpt.waveList='waveYear2007.list';
qbshOpt.songDb='songDb2154.mat';
qbshOpt.outputFile='outputYear2007.txt';
%% ====== List of all params
qbshOpt.useRest=0;		% Use rest (1: extend previous note, 0: delete rest) [�O�_�ϥΥ��š]1�G�ϥΫe�@�ӭ��Ө��N�A0�G�屼���š^]
qbshOpt.lengthRatio=inf;	% Length of the reference songs [�зǵ��׳̵u���ס]�Ҧp�G�O��J�����V�q�� 1.5 ���^]
qbshOpt.method='dtw1';		% Comparison method, see also qbshMatch.m [����k�A�Ш� qbshMatch.m]
qbshOpt.usePv=1;		% Use human-labeled pitch vector instead of doing pitch tracking on wave files
qbshOpt.pvrr=1;			% PVRR=pitch vector reduction ratio [���CPV�I�ƪ����]
qbshOpt.duration=inf;		% Duration of the wave signals in sec [wav�T�������ס]��^]
%% ====== Parameters for LS [LS ���Ѽ�]
qbshOpt.lowerRatio=0.5;
qbshOpt.upperRatio=2.0;
qbshOpt.resolution=51;		% Resolution of LS [�u�ʦ��Y������]
qbshOpt.lsDistanceType=1;
%% ====== Parameters for DTW [DTW ���Ѽ�]
qbshOpt.beginCorner=1;		% Anchored beginning [�Y�T�w]
qbshOpt.endCorner=0;		% Free end [���B��]
qbshOpt.dtwCount=5;		% No of key transposition [�C�����ݶi��X�� DTW]
%% ====== Parameter for pitch tracking
qbshOpt.ptOpt=ptOptSet(8000, 8);
%% ====== Specific parameters for different match types of QBSH
switch matchType
	case 'wave2midi'
		qbshOpt.method='ls';
	%	qbshOpt.method='dtw1';
		qbshOpt.useRest=1;
		qbshOpt.ptOpt.useClarityThreshold=1;
	%	qbshOpt.ptOpt.mainFun='ptByDpOverPfMex';
	case 'wave2wave'
		qbshOpt.method='dtw1';
		qbshOpt.useRest=0;
		qbshOpt.ptOpt.useClarityThreshold=0;
	%	qbshOpt.ptOpt.mainFun='wave2pitchByAcf';
	otherwise
		error('Unknown matchType');
end