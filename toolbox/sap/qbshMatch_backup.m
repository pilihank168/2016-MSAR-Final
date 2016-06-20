function [distVec, scoreVec] = qbshMatch(songData, pitch, mrParam)
%qbshMatch: Match a given pitch vector for QBSH [��@�ӨϥΪ̿�J�������V�q�i�� QBSH]
%	Usage: [distVec, scoreVec] = qbshMatch(songData, pitch, mrParam)
%		songData: song collection
%		pitch: input pitch vector
%		mrParam: MR parameters
%
%	The comparison results are written back into songData's field "score".

pitch=pitch(:)';				% Change to a row vector [�אּ�C�V�q]
pitch=pvRestHandle(pitch, mrParam.useRest);		% Handle rests [�B�z����]
pitch=pitch-mean(pitch);			% Shift the pitch to have zero mean [�����쥭���Ȭ��s]
pitchLen = length(pitch);			% Length of the pitch vector [�����V�q���ס]�I�ơ^]
maxSongLen = round(mrParam.lengthRatio*pitchLen);	% The song length is equal to mrParam.lengthRatio times the pitch length [�зǺq�����׳̦h�u����J�����V�q���ת� mrParam.lengthRatio ��]
pitch=pitch(1:mrParam.pvrr:end);			% Down-sample to reduce computation [���I�H��C�B��q]
songNum=length(songData);
distVec=zeros(1, songNum);

switch mrParam.method
	case 'dtw1'
		for i=1:length(songData),
%			fprintf('%d/%d\n', i, length(songData));
			song=songData(i).pv;
			% ====== Take a reference song of an appropriate length [�^���q���A�����]
			song=song(1:min(maxSongLen, length(song)));
			songLen = length(song);
			% ====== Shift song to have zero mean [�����q���A�ɶq�Ϩ�M��J�����V�q���ۦP����ǡ]�b���������ܥ����Ȭ��s�^]
			songMean=mean(song(1:min(pitchLen, songLen)));	% Get mean of the song with the same length as the pitch vector [��X�q���������ȡ]������שM��J�����V�q�ۦP�^]
			song=song-songMean;				% Shift to mean [�����쥭����]
			% ====== Down-sample to reduce computation [���I�H��C�B��q]
			song=song(1:mrParam.pvrr:end);
			% ====== Set DTW parameters [�]�w DTW �Ѽ�]
			beginCorner=mrParam.beginCorner;	% 1: anchored beginning [�Y�T�w]
			endCorner=mrParam.endCorner;		% 0: free end [���B��]
			% ====== Compute DTW [�p�� DTW]
			distVec(i)=dtw4qbsh(pitch, song, mrParam);
			% ====== Compute DTW [�p�� DTW]
		%	distVec(i) = dtw2mex(pitch, song, beginCorner, endCorner);
		end
	case 'dtw2'
		for i=1:length(songData),
%			fprintf('%d/%d\n', i, length(songData));
			song=songData(i).pv;
			% ====== Take a reference song of an appropriate length [�^���q���A�����]
			song=song(1:min(maxSongLen, length(song)));
			songLen = length(song);
			% ====== Shift song to have zero mean [�����q���A�ɶq�Ϩ�M��J�����V�q���ۦP����ǡ]�b���������ܥ����Ȭ��s�^]
			songMean=mean(song(1:min(pitchLen, songLen)));	% Get mean of the song with the same length as the pitch vector [��X�q���������ȡ]������שM��J�����V�q�ۦP�^]
			song=song-songMean;				% Shift to mean [�����쥭����]
			% ====== Down-sample to reduce computation [���I�H��C�B��q]
			song=song(1:mrParam.pvrr:end);
			% ====== Set up DTW parameters [�]�w DTW �Ѽ�]
			beginCorner=mrParam.beginCorner;	% 1: anchored beginning [�Y�T�w]
			endCorner=mrParam.endCorner;		% 0: free end [���B��]
			% ====== Compute DTW (�p�� DTW)
			distVec(i) = dtw2mex(pitch, song, beginCorner, endCorner);
		end
	case 'dtw1fixedPoint'
		for i=1:length(songData),
%			fprintf('%d/%d\n', i, length(songData));
			song=songData(i).pv;
			% ====== Take a reference song of an appropriate length [�^���q���A�����]
			song=song(1:min(maxSongLen, length(song)));
			song=song(1:mrParam.pvrr:end);	% Down-sample to reduce computation [���I�H��C�B��q]
			% ====== Set up parameters for dtwFixedPoint
			param.dtwFunc='dtw1mex';
			param.anchorBeginning=mrParam.beginCorner;	% 1: anchored beginning [�Y�T�w]
			param.anchorEnd=mrParam.endCorner;		% 0: free end [���B��]
			param.maxIterationNum=mrParam.dtwCount;
			[minDist, allDist, allPitchShift]=dtwFixedPoint(pitch, song, param);
			distVec(i)=minDist;
		end
	case 'dtw2fixedPoint'
		for i=1:length(songData),
%			fprintf('%d/%d\n', i, length(songData));
			song=songData(i).pv;
			% ====== Take a reference song of an appropriate length [�^���q���A�����]
			song=song(1:min(maxSongLen, length(song)));
			song=song(1:mrParam.pvrr:end);	% Down-sample to reduce computation [���I�H��C�B��q]
			% ====== Set up parameters for dtwFixedPoint
			param.dtwFunc='dtw2mex';
			param.anchorBeginning=mrParam.beginCorner;	% 1: anchored beginning [�Y�T�w]
			param.anchorEnd=mrParam.endCorner;		% 0: free end [���B��]
			param.maxIterationNum=mrParam.dtwCount;
			[minDist, allDist, allPitchShift]=dtwFixedPoint(pitch, song, param);
			distVec(i)=minDist;
		end	
	case 'ls'
		% ====== Set up LS parameters [�]�w LS �Ѽ�]
		lowerRatio=mrParam.lowerRatio;	% 0.5;
		upperRatio=mrParam.upperRatio;	% 2.0;
		resolution=mrParam.resolution;	% 11;
		distanceType=1;
		[scaledVecSet, scaledVecLen]=scaledVecCreate(pitch, lowerRatio, upperRatio, resolution);
		for i=1:length(songData)
%			fprintf('%d/%d\n', i, length(songData));
			song=songData(i).pv;
			% ====== Take a reference song of an appropriate length [�^���q���A�����]
			song=song(1:min(maxSongLen, length(song)));
			songLen = length(song);
			% ====== Down-sample to reduce computation (���I�H��C�B��q)
			song=song(1:mrParam.pvrr:end);
		%	% ====== Compute LS (�p�� LS)
		%	distVec(i)=linScalingMex(pitch, song, lowerRatio, upperRatio, resolution, distanceType);
			% ====== Compute LS (�p�� LS)
			distVec(i)=linScaling2Mex(scaledVecSet, scaledVecLen, song, distanceType);
		end
	case 'noteLevelDtw2'
		for i=1:length(songData),
%			fprintf('%d/%d\n', i, length(songData));
			% ====== Shift song to have zero mean [�����q���A�ɶq�Ϩ�M��J�����V�q���ۦP����ǡ]�b���������ܥ����Ȭ��s�^]
			song=songData(i).pv;
			songLen = length(song);
			songMean=mean(song(1:min(pitchLen, songLen)));	% Get mean of the song with the same length as the pitch vector [��X�q���������ȡ]������שM��J�����V�q�ۦP�^]
			songNote=songData(i).track(1:2:end)';		% Use pitch only [�u������]
			songNote=songNote-songMean;		
			% ====== Note segmentation [�i�歵�Ť���]
			pitchTh=0.8;
			minNoteDuration=0.1;
			userNote = noteSegment(pitch, mrParam.timeStep, pitchTh, minNoteDuration);
			% ====== Use dtw2 to compute the distance between song and userNote. [�ϥ� DTW2 �ӭp�� song �M userNote �������Z��]
			userNote=userNote(1:2:end);		% Use pitch only [�u������]
			beginCorner=mrParam.beginCorner;		% 1: anchored beginning [�Y�T�w]
			endCorner=mrParam.endCorner;			% 0: free end [���B��]
			distVec(i) = dtw2mex(userNote, songNote, beginCorner, endCorner);
		end
	case 'dtw3'
		for i=1:length(songData),
%			fprintf('%d/%d\n', i, length(songData));
			% ====== Shift song to have zero mean [�����q���A�ɶq�Ϩ�M��J�����V�q���ۦP����ǡ]�b���������ܥ����Ȭ��s�^]
			song=songData(i).pv;
			songLen = length(song);
			songMean=mean(song(1:min(pitchLen, songLen)));	% Get mean of the song with the same length as the pitch vector [��X�q���������ȡ]������שM��J�����V�q�ۦP�^]
			songNote=songData(i).track(1:2:end)';		% Use pitch only [�u������]
			songNote=songNote-songMean;
			% ====== Down-sample to reduce computation [���I�H��C�B��q]
			song=song(1:mrParam.pvrr:end);
			% ====== Set up DTW parametrs [�]�w DTW �Ѽ�]
			beginCorner=mrParam.beginCorner;	% 1: anchored beginning [�Y�T�w]
			endCorner=mrParam.endCorner;		% 0: free end [���B��]
			% ====== �p�� DTW
			distVec(i) = dtw3mex(pitch, songNote, beginCorner, endCorner);
		end
	otherwise
		error('Unknown method!');
end

scoreVec=100./(1+distVec);