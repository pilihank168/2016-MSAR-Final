function [opt, maxPerf, optHistory]=coordinateSearch(objFunction, initialGuess, opPrm, varargin)
%coordinateSearch: Coordinate-based search for multivariate object functioni
%
%	Usage:
%		[opt, maxPerf]=coordinateSearch(objFunction, initialGuess, opPrm)
%		[opt, maxPerf]=coordinateSearch(objFunction, initialGuess, opPrm, varargin)
%
%	Description:
%		opt=coordinateSearch(objFunction, initialGuess, opPrm) returns the best option (or parameters) for a given objective function.
%
%	Example:
%		guess.x=-1;
%		guess.y=1;
%		opPrm.x.range=[-4, 4];
%		opPrm.x.resolution=101;
%		opPrm.y.range=[-4, 4];
%		opPrm.y.resolution=101;
%		[opt, maxPerf, optHistory]=coordinateSearch('peaksFcn', guess, opPrm);
%		[xx, yy, zz]=peaks(opPrm.x.resolution);
%		pcolor(xx, yy, zz); axis image
%		for i=1:length(optHistory)
%			line(optHistory(i).x, optHistory(i).y, 'marker', 'o', 'color', 'w');
%			text(optHistory(i).x, optHistory(i).y, int2str(i));
%		end
%
%	See also binarySearch4min.

%	Roger Jang, 20120916

if nargin<1; selfdemo; return; end

opt=initialGuess;
opt.perf=feval(objFunction, varargin{:}, opt);
optHistory=opt;
fieldNames=fieldnames(opPrm);
maxIter=10;
for iter=1:maxIter
	fprintf('Iteration=%d/%d\n', iter, maxIter);
	oldOpt=opt;
	for f=1:length(fieldNames)
		theField=fieldNames{f};
		opPrmVec=linspace(opPrm.(theField).range(1), opPrm.(theField).range(2), opPrm.(theField).resolution);
		opPrmLen=length(opPrmVec);
		perf=zeros(1, opPrmLen);
		for i=1:opPrmLen
			opt.(theField)=opPrmVec(i);
			perf(i)=feval(objFunction, varargin{:}, opt);
		end
		[maxPerf, maxIndex]=max(perf);
		opt.(theField)=opPrmVec(maxIndex);
		opt.perf=maxPerf;
		optHistory=[optHistory, opt];
	end
	for f=1:length(fieldNames)
		fprintf('\topt.%s=%f\n', fieldNames{f}, opt.(fieldNames{f}));
	end
	fprintf('\tperf=%f\n', opt.perf);
	if isequal(opt, oldOpt)
		break;
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
