%% coordinateSearch
% Coordinate-based search for multivariate object functioni
%% Syntax
% * 		[opt, maxPerf]=coordinateSearch(objFunction, initialGuess, opPrm)
% * 		[opt, maxPerf]=coordinateSearch(objFunction, initialGuess, opPrm, varargin)
%% Description
% 		opt=coordinateSearch(objFunction, initialGuess, opPrm) returns the best option (or parameters) for a given objective function.
%% Example
%%
%
guess.x=-1;
guess.y=1;
opPrm.x.range=[-4, 4];
opPrm.x.resolution=101;
opPrm.y.range=[-4, 4];
opPrm.y.resolution=101;
[opt, maxPerf, optHistory]=coordinateSearch('peaksFcn', guess, opPrm);
[xx, yy, zz]=peaks(opPrm.x.resolution);
pcolor(xx, yy, zz); axis image
for i=1:length(optHistory)
	line(optHistory(i).x, optHistory(i).y, 'marker', 'o', 'color', 'w');
	text(optHistory(i).x, optHistory(i).y, int2str(i));
end
%% See Also
% <binarySearch4min_help.html binarySearch4min>.
