function [distVec, minIndexVec, scoreVec] = qbshMatch(songDb, pitch, qbshOpt)
%qbshMatch: Match a given pitch vector for QBSH [��@�ӨϥΪ̿�J�������V�q�i�� QBSH]
%
%	Usage:
%		[distVec, minIndexVec, scoreVec] = qbshMatch(songDb, pitch, qbshOpt)
%
%	Description:
%		[distVec, minIndexVec, scoreVec] = qbshMatch(songDb, pitch, qbshOpt)
%			songDb: song collection
%			pitch: input pitch vector
%			qbshOpt: QBSH parameters

%	Roger Jang, 20130122

if any(isnan(pitch)), error('The given pitch cannot contain NaN!'); end
if sum(pitch)==0, error('The given pitch is all zero!'); end

pitch=pitch(:)';					% Change to a row vector [�אּ�C�V�q]
pitch=pvRestHandle(pitch, qbshOpt.useRest);		% Handle rests [�B�z����]
pitch=pitch-mean(pitch);				% Shift the pitch to have zero mean [�����쥭���Ȭ��s]
pitchLen = length(pitch);				% Length of the pitch vector [�����V�q���ס]�I�ơ^]
maxSongLen = round(qbshOpt.lengthRatio*pitchLen);	% The song length is equal to qbshOpt.lengthRatio times the pitch length [�зǺq�����׳̦h�u����J�����V�q���ת� qbshOpt.lengthRatio ��]
pitch=pitch(1:qbshOpt.pvrr:end);			% Down-sample to reduce computation [���I�H��C�B��q]
songNum=length(songDb);
distVec=zeros(1, songNum);
minIndexVec=zeros(1, songNum);

switch qbshOpt.method
	case 'dtw1'
		for i=1:length(songDb),
%			fprintf('%d/%d\n', i, length(songDb));
			song=songDb(i).pv;
			% ====== Take a reference song of an appropriate length [�^���q���A�����]
			song=song(1:min(maxSongLen, length(song)));
			songLen = length(song);
			% ====== Shift song to have zero mean [�����q���A�ɶq�Ϩ�M��J�����V�q���ۦP����ǡ]�b���������ܥ����Ȭ��s�^]
			songMean=mean(song(1:min(pitchLen, songLen)));	% Get mean of the song with the same length as the pitch vector [��X�q���������ȡ]������שM��J�����V�q�ۦP�^]
			song=song-songMean;				% Shift to mean [�����쥭����]
			% ====== Down-sample to reduce computation [���I�H��C�B��q]
			song=song(1:qbshOpt.pvrr:end);
			% ====== Compute DTW [�p�� DTW]
			distVec(i)=dtw4qbsh(pitch, song, qbshOpt);
		end
	case 'dtw2'
		for i=1:length(songDb),
%			fprintf('%d/%d\n', i, length(songDb));
			song=songDb(i).pv;
			% ====== Take a reference song of an appropriate length [�^���q���A�����]
			song=song(1:min(maxSongLen, length(song)));
			songLen = length(song);
			% ====== Shift song to have zero mean [�����q���A�ɶq�Ϩ�M��J�����V�q���ۦP����ǡ]�b���������ܥ����Ȭ��s�^]
			songMean=mean(song(1:min(pitchLen, songLen)));	% Get mean of the song with the same length as the pitch vector [��X�q���������ȡ]������שM��J�����V�q�ۦP�^]
			song=song-songMean;				% Shift to mean [�����쥭����]
			% ====== Down-sample to reduce computation [���I�H��C�B��q]
			song=song(1:qbshOpt.pvrr:end);
			% ====== Compute DTW (�p�� DTW)
			distVec(i)=dtw4qbsh(pitch, song, qbshOpt);
		end
	case 'dtw1fixedPoint'
		for i=1:length(songDb),
%			fprintf('%d/%d\n', i, length(songDb));
			song=songDb(i).pv;
			% ====== Take a reference song of an appropriate length [�^���q���A�����]
			song=song(1:min(maxSongLen, length(song)));
			song=song(1:qbshOpt.pvrr:end);	% Down-sample to reduce computation [���I�H��C�B��q]
			% ====== Set up parameters for dtwFixedPoint
			param.dtwFunc='dtw1mex';
			param.anchorBeginning=qbshOpt.beginCorner;	% 1: anchored beginning [�Y�T�w]
			param.anchorEnd=qbshOpt.endCorner;		% 0: free end [���B��]
			param.maxIterationNum=qbshOpt.dtwCount;
			[minDist, allDist, allPitchShift]=dtwFixedPoint(pitch, song, param);
			distVec(i)=minDist;
		end
	case 'dtw2fixedPoint'
		for i=1:length(songDb),
%			fprintf('%d/%d\n', i, length(songDb));
			song=songDb(i).pv;
			% ====== Take a reference song of an appropriate length [�^���q���A�����]
			song=song(1:min(maxSongLen, length(song)));
			song=song(1:qbshOpt.pvrr:end);	% Down-sample to reduce computation [���I�H��C�B��q]
			% ====== Set up parameters for dtwFixedPoint
			param.dtwFunc='dtw2mex';
			param.anchorBeginning=qbshOpt.beginCorner;	% 1: anchored beginning [�Y�T�w]
			param.anchorEnd=qbshOpt.endCorner;		% 0: free end [���B��]
			param.maxIterationNum=qbshOpt.dtwCount;
			[minDist, allDist, allPitchShift]=dtwFixedPoint(pitch, song, param);
			distVec(i)=minDist;
		end	
	case 'ls'
		% ====== Set up LS parameters [�]�w LS �Ѽ�]
		lowerRatio=qbshOpt.lowerRatio;		% 0.5;
		upperRatio=qbshOpt.upperRatio;		% 2.0;
		resolution=qbshOpt.resolution;		% 11;
		[scaledVecSet, scaledVecLen]=scaledVecCreate(pitch, lowerRatio, upperRatio, resolution);
		for i=1:length(songDb)	% Compare pitch to each song
		%	fprintf('\t%d/%d: songName=%s\n', i, length(songDb), songDb(i).songName);
%			songDb(i).anchorPvIndex=1;
			anchorNum=length(songDb(i).anchorPvIndex);
			distVecInSong=zeros(anchorNum, 1);
			minIndexInSong=zeros(anchorNum, 1);
			for j=1:anchorNum
			%	fprintf('\t\t%d/%d:\n', j, anchorNum); pause;
			%	song=songDb(i).pv(songDb(i).noteStartIndex(j):end);		% A song from the note start index
				song=songDb(i).pv(songDb(i).anchorPvIndex(j):end);		% A song from the anchor index
				% ====== Take a reference song of an appropriate length [�^���q���A�����]
				song=song(1:min(maxSongLen, length(song)));	% Do we need this line???
				songLen = length(song);
				% ====== Down-sample to reduce computation (���I�H��C�B��q)
				song=song(1:qbshOpt.pvrr:end);
			%	% ====== Compute LS (�p�� LS)
			%	distVec(i)=linScalingMex(pitch, song, lowerRatio, upperRatio, resolution, qbshOpt.lsDistanceType);
				% ====== Compute LS (�p�� LS) at each anchor point
				[distVecInSong(j), minIndexInSong(j)]=linScaling2Mex(scaledVecSet, scaledVecLen, song, qbshOpt.lsDistanceType);
			end
			[distVec(i), minIndex]=min(distVecInSong);	% distVec(i): distance to song i. minIndex: anchor index
			minIndexVec(i)=minIndexInSong(minIndex);	% 
		end
	case 'noteLevelDtw2'
		for i=1:length(songDb),
%			fprintf('%d/%d\n', i, length(songDb));
			% ====== Shift song to have zero mean [�����q���A�ɶq�Ϩ�M��J�����V�q���ۦP����ǡ]�b���������ܥ����Ȭ��s�^]
			song=songDb(i).pv;
			songLen = length(song);
			songMean=mean(song(1:min(pitchLen, songLen)));	% Get mean of the song with the same length as the pitch vector [��X�q���������ȡ]������שM��J�����V�q�ۦP�^]
			songNote=songDb(i).track(1:2:end)';		% Use pitch only [�u������]
			songNote=songNote-songMean;		
			% ====== Note segmentation [�i�歵�Ť���]
			pitchTh=0.8;
			minNoteDuration=0.1;
			userNote = noteSegment(pitch, qbshOpt.ptOpt.frameRate, pitchTh, minNoteDuration);
			% ====== Use dtw2 to compute the distance between song and userNote. [�ϥ� DTW2 �ӭp�� song �M userNote �������Z��]
			userNote=userNote(1:2:end);		% Use pitch only [�u������]
			distVec(i) = dtw2mex(userNote, songNote, qbshOpt.beginCorner, qbshOpt.endCorner);
		end
	case 'dtw3'
		for i=1:length(songDb),
%			fprintf('%d/%d\n', i, length(songDb));
			% ====== Shift song to have zero mean [�����q���A�ɶq�Ϩ�M��J�����V�q���ۦP����ǡ]�b���������ܥ����Ȭ��s�^]
			song=songDb(i).pv;
			songLen = length(song);
			songMean=mean(song(1:min(pitchLen, songLen)));	% Get mean of the song with the same length as the pitch vector [��X�q���������ȡ]������שM��J�����V�q�ۦP�^]
			songNote=songDb(i).track(1:2:end)';		% Use pitch only [�u������]
			songNote=songNote-songMean;
			% ====== Down-sample to reduce computation [���I�H��C�B��q]
			song=song(1:qbshOpt.pvrr:end);
			% ====== �p�� DTW
			distVec(i) = dtw3mex(pitch, songNote, qbshOpt.beginCorner, qbshOpt.endCorner);
		end
	otherwise
		error('Unknown method!');
end

% [a, b] = gBellParam(1.27, 0.95, 1.60, 0.5);
a=1.60;
b=6.37;
scoreVec=100./(1+(distVec/a).^(2*b));
