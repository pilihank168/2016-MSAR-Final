function [pitch, clarity, pfMat, ptOpt, evalCount, maxPitchDiff]=pitchTrackForcedSmooth(au, ptOpt, showPlot)
%pitchTrackForcedSmooth: Pitch tracking which uses incremental weights to get a smooth pitch curve
%
%	Usage:
%		[pitch, clarity]=pitchTrackForcedSmooth(audioObj, ptOpt, showPlot);
%
%	Example:
%		waveFile='test01.wav';
%		au=myAudioRead(waveFile);
%		ptOpt=ptOptSet(au.fs, au.nbits);
%		ptOpt.pitchDiffTh=6;
%		[pitch, clarity, pfMat, ptOpt, evalCount, maxPitchDiff]=pitchTrackForcedSmooth(au, ptOpt, 1);

if nargin<1, selfdemo; return; end
if nargin<2, showPlot=1; end

if nargin<1, selfdemo; return; end
if ischar(au), au=myAudioRead(au); end	% au is actually the wave file name
if nargin<2 | isempty(ptOpt), ptOpt=ptOptSet(au.fs, au.nbits); end
if nargin<3, showPlot=0; end
if au.fs~=ptOpt.fs | au.nbits~=ptOpt.nbits
	fprintf('au.fs=%d, ptOpt.fs=%d, au.nbits=%d, ptOpt.nbits=%d\n', au.fs, ptOpt.fs, au.nbits, ptOpt.nbits);
	error('ptOpt is not conformed to the given wave object!');
end

% ====== Define parameters
pitchDiffTh=ptOpt.pitchDiffTh;
roundNum=ptOpt.roundNum;
searchMethod=ptOpt.searchMethod;	% 'binarySearch' or 'linearSearch'
leftBound=ptOpt.leftBound; rightBound=ptOpt.rightBound;	% for binary search only
boundRangeTh=ptOpt.boundRangeTh;

maxPitchDiff=inf;
evalCount=0;
switch(searchMethod)
	case 'linearSearch'
		while maxPitchDiff>pitchDiffTh
			ptOpt.indexDiffWeight=ptOpt.indexDiffWeight+100;	% Increment the weight by 100
			[pitch, clarity, pfMat, maxPitchDiff]=pitchTrack(au, ptOpt); evalCount=evalCount+1;
			pitchData(evalCount).indexDiffWeight=ptOpt.indexDiffWeight;
			pitchData(evalCount).pitch=pitch;
			legendStr{evalCount}=num2str(ptOpt.indexDiffWeight);
			fprintf('\tindexDiffWeight=%f, evalCount=%d, maxPitchDiff=%f\n', ptOpt.indexDiffWeight, evalCount, maxPitchDiff);
		end
	case 'binarySearch'
		% ====== Find the first rightBound which make the pitch diff less than a threshold
		fprintf('Initial bounds = [%g, %g], pitchDiffTh = %g\n', leftBound, rightBound, pitchDiffTh);
		ptOpt.indexDiffWeight=leftBound; [pitchLeft, clarity, pfMat, maxPitchDiff]=pitchTrack(au, ptOpt); evalCount=evalCount+1;
		fprintf('Exploring the first leftBound: leftBound=%g, rightBound=%g, maxPitchDiff=%g at %g\n', leftBound, rightBound, maxPitchDiff, leftBound);
		if maxPitchDiff<=pitchDiffTh	% Hit the right one at the first try!
			pitch=pitchLeft;
		else
			while maxPitchDiff>pitchDiffTh
				ptOpt.indexDiffWeight=rightBound;
				[pitchRight, clarity, pfMat, maxPitchDiff]=pitchTrack(au, ptOpt); evalCount=evalCount+1;
				fprintf('Exploring the correct rightBound: leftBound=%g, rightBound=%g, maxPitchDiff=%g at %g\n', leftBound, rightBound, maxPitchDiff, rightBound);
				if maxPitchDiff<pitchDiffTh, break; end
				leftBound=rightBound; pitchLeft=pitchRight;
				rightBound=rightBound*2;	% Double the right bound so we can find a rightBound to decrease maxPitchDiff quickly.
			end
			fprintf('Initial bounds = [%g, %g]\n', leftBound, rightBound);
			% ====== Shorten the bound by binary search
			for i=1:roundNum
				center=(leftBound+rightBound)/2;
				ptOpt.indexDiffWeight=center;
				[pitchCenter, clarity, pfMat, maxPitchDiff]=pitchTrack(au, ptOpt); evalCount=evalCount+1;
				fprintf('Tighten the bound: i=%d, leftBound=%g, rightBound=%g, boundRange=%g, maxPitchDiff=%g at %g\n', i, leftBound, rightBound, rightBound-leftBound, maxPitchDiff, center);
				if maxPitchDiff>pitchDiffTh
					leftBound=center; pitchLeft=pitchCenter;
				else
					rightBound=center; pitchRight=pitchCenter;
				end
				if rightBound-leftBound<boundRangeTh, break; end
			end
			ptOpt.indexDiffWeight=rightBound; pitch=pitchRight;
			fprintf('Final bounds = [%g, %g]\n', leftBound, rightBound);
		end
	otherwise
		error('Unknown method!');
end

if showPlot
	[pitch, clarity, pfMat]=pitchTrack(au, ptOpt, 1);	% Deliver the final plot
	if strcmp(searchMethod, 'linearSearch')
		curveNum=evalCount-1;
		allPitch=cat(1, pitchData.pitch)';
		allPitch(allPitch==0)=nan;
		for i=1:curveNum, allPitch(:,i)=allPitch(:,i)+0.3*(i-1); end
		figure; plot(allPitch);
		legend(legendStr, 'location', 'best');
		title('Pitch curves vs indexDiffWeight (for AMDF)');
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
