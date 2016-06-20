function [recogRate, absAveError, auSet]=ptPerfEval(auSet, ptOpt, showPlot)
% ptPerfEval: Performance evaluation for pitch tracking
%
%	Usage:
%		[recogRate, absAveError, auSet]=ptPerfEval(auSet, ptOpt, showPlot)
%
%	Example:
%		auDir='testCorpus4pt';
%		auSet=recursiveFileList(auDir, 'wma');
%		auNum=length(auSet);
%		fprintf('Collected %d wma files.\n', auNum);
%		for i=1:auNum
%			[parentDir, mainName]=fileparts(auSet(i).path);
%			items=split(mainName, '-');
%			auSet(i).tPitch=str2semitone(items{1});	% Find target pitch
%		end
%		au=myAudioRead(auSet(1).path);
%		ptOpt=ptOptSet(au.fs, au.nbits, 1);
%		ptOpt.ptFcn='pitchTrackBasic';
%		ptOpt.evalMethod='rawPitchAccuracy';
%		[recogRate, absAveError, auSet]=ptPerfEval(auSet, ptOpt, 1);

%	Roger Jang, 20060214, 20070216, 20151004

if nargin<1, selfdemo; return; end
if nargin<2 || isempty(ptOpt)
	au=myAudioRead(auSet(1).path);
	ptOpt=ptOptSet(au.fs, au.nbits, 1);
end
if nargin<3, showPlot=0; end

auNum=length(auSet);
if auNum==0, error('Give auSet is empty!'); end
debug=0;
for i=1:auNum
	au=myAudioRead(auSet(i).path);
	au.tPitch=auSet(i).tPitch;
	t0=clock;
	auSet(i).cPitch=feval(ptOpt.ptFcn, au, ptOpt, debug);		% Pitch tracking
	auSet(i).cPitch(isnan(auSet(i).cPitch))=0;	% nan ==> 0
	if isscalar(auSet(i).tPitch)	% A single pitch for a file
		auSet(i).tPitch=auSet(i).tPitch*ones(1, length(auSet(i).cPitch));
		auSet(i).tPitch(auSet(i).cPitch==0)=0;
	end
	auSet(i).time=etime(clock, t0);
	[auSet(i).recogRate, auSet(i).absAveError, auSet(i).correctCount, auSet(i).pitchCount]=pvSimilarity(auSet(i).cPitch, auSet(i).tPitch, ptOpt);
	if debug
		fprintf('\t%d/%d: (%g sec, %.2f%%) %s\n', i, length(auSet), auSet(i).time, auSet(i).recogRate*100, auSet(i).path);
		fprintf('\tPress key to continue...'); pause; fprintf('\n');
	end
end

absAveError=sum([auSet.absAveError].*[auSet.pitchCount])/sum([auSet.pitchCount]);
recogRate=sum([auSet.correctCount])/sum([auSet.pitchCount]);
fprintf('\t\tTotal time = %.2f ¬í\n', sum([auSet.time]));
fprintf('\t\tAverage time = %.2f ¬í\n', sum([auSet.time])/length(auSet));
fprintf('\t\tAverage recog. rate = %.2f%%\n', 100*recogRate);

if showPlot
	[sortedRr, sortIndex]=sort([auSet.recogRate], 'descend');
	plot(sortedRr, '.-');
	title('Sorted RR'); ylabel('Recognition rate'); xlabel('Sorted file index');
	fprintf('Average RR = %g%%\n', recogRate*100);
	fprintf('Average time = %g sec\n', mean([auSet.time]));
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);