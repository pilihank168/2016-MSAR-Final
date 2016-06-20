function [minPair, allPairs]=binarySearch4min(objFunction, op, varargin)
% binarySearch4min: Binary-search-like method for 1-d minimization
%	Usage: [minPair, allPairs]=binarySearch4min(objFunction, op, varargin)
%		objFunction: Objective function
%		op: Optimization parameters
%			op.searchRange: Search range
%			op.evalCount: No. of function evaluations
%			op.plotOpt: Option for plotting
%		varargin: Input arguments for objFunction
%		minPair: minPair(1) is the minimizing x, minPair(2) is the corresponding value of objFunction
%		allPairs: All pairs of function evalustions
%
%	For example:
%		objFunction='humps';
%		op.searchRange=[0.0, 1.0];
%		op.evalCount=11;
%		op.plotOpt=1;
%		[minPair, allPairs]=binarySearch4min(objFunction, op);
%		fprintf('minX=%f, minY=%f\n', minPair(1), minPair(2));
%		x=linspace(op.searchRange(1), op.searchRange(2), 101);
%		y=humps(x);
%		line(x, y, 'color', 'r'); grid on
%		set(gca, 'ylim', [min(y), max(y)]);
%
%	See also narySearch4max.

%	Roger Jang, 20060606

if nargin<1; selfdemo; return; end
if nargin<2;
	op.searchRange=[-2, 2];
	op.evalCount=31;
	op.plotOpt=0;
end

x=mean(op.searchRange);
side=(max(op.searchRange)-x)/2;

y1=feval(objFunction, x, varargin{:});
allPairs=[x; y1];
for j=1:(op.evalCount-1)/2
	y2 = feval(objFunction, x-side, varargin{:});
	y3 = feval(objFunction, x+side, varargin{:});
	allPairs=[allPairs, [x-side; y2], [x+side; y3]];
	y=[y1, y2, y3];
	shift=[0, -side, side];
	[y1, minIndex]=min(y);
	x=x+shift(minIndex);
	side=side/2;
end
minPair=[x, y1]';

if op.plotOpt
	x=allPairs(1,:);
	y=allPairs(2,:);
	[junk, index]=sort(x);
	plot(x(index), y(index));
	line(allPairs(1,:), allPairs(2,:), 'lineStyle', 'none', 'marker', '.', 'color', 'm');
	for i=1:op.evalCount
		text(allPairs(1,i), allPairs(2,i), int2str(i), 'vertical', 'top', 'hori', 'center');
	end
	line(minPair(1), minPair(2), 'lineStyle', 'none', 'marker', 'square', 'color', 'r');
	axis([op.searchRange(1), op.searchRange(2), -inf inf]); box on;
end

% ====== Self demo
function selfdemo
objFunction='humps';
op.searchRange=[0.0, 1.0];
op.evalCount=11;
op.plotOpt=1;
[minPair, allPairs]=feval(mfilename, objFunction, op);
fprintf('minX=%f, minY=%f\n', minPair(1), minPair(2));
x=linspace(op.searchRange(1), op.searchRange(2), 101);
y=humps(x);
line(x, y, 'color', 'r'); grid on
set(gca, 'ylim', [min(y), max(y)]);