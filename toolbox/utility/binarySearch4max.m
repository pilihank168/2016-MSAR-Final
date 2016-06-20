function [maxPair, allPairs]=binarySearch4max(objFunction, op, varargin)
% binarySearch4max: Binary-search-like method for 1-d maximization
%	Usage: [maxPair, allPairs]=binarySearch4max(objFunction, op, varargin)
%		objFunction: Objective function
%		op: Optimization parameters
%			op.searchRange: Search range
%			op.evalCount: No. of function evaluations
%			op.plotOpt: Option for plotting
%		varargin: Input arguments for objFunction
%		maxPair: maxPair(1) is the maximizing x, maxPair(2) is the corresponding value of objFunction
%		allPairs: All pairs of function evalustions
%
%	For example:
%		objFunction='humps';
%		op.searchRange=[0.0, 1.0];
%		op.evalCount=11;
%		op.plotOpt=1;
%		[maxPair, allPairs]=binarySearch4max(objFunction, op);
%		fprintf('maxX=%f, maxY=%f\n', maxPair(1), maxPair(2));
%		x=linspace(op.searchRange(1), op.searchRange(2), 101);
%		y=humps(x);
%		line(x, y, 'color', 'r'); grid on
%		set(gca, 'ylim', [min(y), max(y)]);
%
%	See also narySearch4max.

%	Roger Jang, 20060606, 20070710

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
	[y1, maxIndex]=max(y);
	x=x+shift(maxIndex);
	side=side/2;
end
maxPair=[x, y1]';

if op.plotOpt
	x=allPairs(1,:);
	y=allPairs(2,:);
	[junk, index]=sort(x);
	plot(x(index), y(index));
	line(allPairs(1,:), allPairs(2,:), 'lineStyle', 'none', 'marker', '.', 'color', 'm');
	for i=1:op.evalCount
		text(allPairs(1,i), allPairs(2,i), int2str(i), 'vertical', 'top', 'hori', 'center');
	end
	line(maxPair(1), maxPair(2), 'lineStyle', 'none', 'marker', 'square', 'color', 'r');
	axis([op.searchRange(1), op.searchRange(2), -inf inf]); box on;
end

% ====== Self demo
function selfdemo
objFunction='humps';
op.searchRange=[0.0, 1.0];
op.evalCount=11;
op.plotOpt=1;
[maxPair, allPairs]=feval(mfilename, objFunction, op);
fprintf('maxX=%f, maxY=%f\n', maxPair(1), maxPair(2));
x=linspace(op.searchRange(1), op.searchRange(2), 101);
y=humps(x);
line(x, y, 'color', 'r'); grid on
set(gca, 'ylim', [min(y), max(y)]);