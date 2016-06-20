function [recogRate, waveData]=qbshPerfEval(waveData, songDb, qbshOpt)
% qbshPerfEval: QBSH performance evaluation
%
%	Usage:
%		[recogRate, waveData]=qbshPerfEval(waveData, songDb, qbshOpt)

%	Roger Jang, 20090922, 20130425

songIds={songDb.id};	% For mirex, this is the song's ID
waveNum=length(waveData);
fprintf('Doing melody recognition on %d wave files against %d midi files:\n', length(waveData), length(songDb));
for i=1:waveNum
	waveData(i).success=1;
	try
		myTic=tic;
		pitch=waveData(i).cPitch;
		if qbshOpt.usePv, pitch=waveData(i).tPitch; end
		[waveData(i).dist, waveData(i).minIndex] = qbshMatch(songDb, pitch, qbshOpt);	% �N�@��wave���Ҧ����q
		waveData(i).time = toc(myTic);
		songIndex=find(strcmp(songIds, waveData(i).songId));	% ��X�Ҧ��M�зǵ��צP�W���q��
		if ~isempty(songIndex)		% ���F�@���Φh��
			minDistOfTheSong = min(waveData(i).dist(songIndex));	% �H�̵u�Z�����D
			waveData(i).rank = length(find(minDistOfTheSong>=waveData(i).dist));	
		else	% �䤣��...
		%	fprintf('Cannot find %s in the songDb!\n', waveData(i).songId);
			waveData(i).rank = inf;
		end
		waveData(i).songIndex=songIndex;		% �����зǵ��ת� index
		fprintf('%d/%d: rank=%d, wave="%s", time=%2.3fs\n', i, waveNum, waveData(i).rank, waveData(i).path, waveData(i).time);
	catch exception
		waveData(i).success=0;
		waveData(i).errorMsg=exception.message;
	end
end
recogRate=sum([waveData.rank]==1)/length(waveData);