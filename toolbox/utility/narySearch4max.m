function [minPair, allPairs]=narySearch4max(objFunction, op, varargin)
% narySearch4max: N-ary-search-like method for 1-d optimization
%	Usage: [minPair, allPairs]=narySearch4max(objFunction, op, varargin)
%		objFunction: Objective function
%		op: Optimization parameters
%			op.searchRange: Search range
%			op.division: No. of division for each depth (a odd number)
%			op.depth: depth for search
%			op.plotOpt: Option for plotting
%		varargin: Input arguments for objFunction
%		minPair: minPair(1) is the minimizing x, minPair(2) is the corresponding value of objFunction
%		allPairs: All pairs of function evalustions
%
%	Number of evaluation counts = op.division+[(op.division-1)*2+1-3]*(op.depth-1).
%	If op.searchRange=[0, 1000], op.division=11, op.depth=3, then the minimum search step is 1.
%
%	For example:
%
%		objFunction='humps';
%		op.searchRange=[0.1, 0.95];
%		op.division=11;
%		op.depth=3;
%		op.plotOpt=1;
%		[minPair, allPairs]=narySearch4max(objFunction, op);
%
%	See also binarySearch4min.

%	Roger Jang, 20070216, 20091124

if nargin<1; selfdemo; return; end
if nargin<2;
	op.searchRange=[-2, 2];
	op.division=11;
	op.depth=3;
	op.plotOpt=0;
end

xStart=op.searchRange(1); xStop=op.searchRange(2);
if (xStart==xStop)
	error('The given search range is an empty set!');
end
x=linspace(xStart, xStop, op.division);
y=zeros(1, op.division);
fprintf('depth=%d/%d, range=%s\n', 1, op.depth, mat2str([xStart, xStop]));
for j=1:length(x)
	t0=clock;
	y(j)=feval(objFunction, x(j), varargin{:});
	fprintf('\tj=%d/%d, x=%g, y=%g, time=%g sec\n', j, op.division, x(j), y(j), etime(clock, t0));
end
if sum(abs(diff(y)))==0
	fprintf('Warning: Obj. function has the same value at the first stage. Perhaps you should change the search range for a better search result.\n');
end
allPairs=[x; y];
[yMax, indexMax]=max(y); xMax=x(indexMax);
for i=2:op.depth
	index1=indexMax-1; if index1<1, index1=1; end
	index2=indexMax+1; if index2>length(x), index2=length(x); end
	xStart=x(index1); xStop=x(index2);
	fprintf('depth=%d/%d, range=%s\n', i, op.depth, mat2str([xStart, xStop]));
	% ====== left side
	if (xStart~=xMax)
		x1=linspace(xStart, xMax, op.division);
		y1=zeros(1, op.division);
		for j=1:length(x1)-1
			t0=clock;
			y1(j)=feval(objFunction, x1(j), varargin{:});
			fprintf('\tj=%d/%d, x=%g, y=%g, time=%g sec\n', j, 2*op.division-1, x1(j), y1(j), etime(clock, t0));
		end
		x1(end)=[]; y1(end)=[];
	else
		x1=[]; y1=[];
	end
	% ====== right side
	if (xMax~=xStop)
		x2=linspace(xMax, xStop, op.division);
		y2=zeros(1, op.division);
		for j=2:length(x2)
			t0=clock;
			y2(j)=feval(objFunction, x2(j), varargin{:});
			fprintf('\tj=%d/%d, x=%g, y=%g, time=%g sec\n', j+op.division-1, 2*op.division-1, x2(j), y2(j), etime(clock, t0));
		end
		x2(1)=[]; y2(1)=[];
	else
		x2=[]; y2=[];
	end
	% ====== Combine both sides
	x=[x1, xMax, x2];
	y=[y1, yMax, y2];
	[yMax, indexMax]=max(y); xMax=x(indexMax);
	allPairs=[allPairs, [[x1, x2]; [y1, y2]]];
end
minPair=[xMax, yMax]';

if op.plotOpt
	x=allPairs(1,:); y=allPairs(2,:);
	[x, index]=sort(x); y=y(index);
	subplot(2,1,1);		% Original plot
	plot(x, y);
	xlabel('x'); ylabel('Obj. function');
	line(allPairs(1,:), allPairs(2,:), 'lineStyle', 'none', 'marker', '.', 'color', 'm');
	for i=1:size(allPairs, 2)
		text(allPairs(1,i), allPairs(2,i), int2str(i), 'vertical', 'top', 'hori', 'center');
	end
	line(minPair(1), minPair(2), 'lineStyle', 'none', 'marker', 'square', 'color', 'r');
	boundary=axis; yMin=boundary(3);
	for i=1:size(allPairs, 2)
		line(allPairs(1,i)*[1 1], [yMin, allPairs(2,i)], 'color', 'r');
	end
	box on; grid on; axis tight
	subplot(2,1,2);
	plot(x, y);		% Closeup plot
	 xlabel('x'); ylabel('Obj. function');
	line(allPairs(1,:), allPairs(2,:), 'lineStyle', 'none', 'marker', '.', 'color', 'm');
	for i=1:size(allPairs, 2)
		text(allPairs(1,i), allPairs(2,i), int2str(i), 'vertical', 'top', 'hori', 'center');
	end
	line(minPair(1), minPair(2), 'lineStyle', 'none', 'marker', 'square', 'color', 'r');
	axis tight; box on; grid on;
	boundary=axis; yMin=boundary(3);
	for i=1:size(allPairs, 2)
		line(allPairs(1,i)*[1 1], [yMin, allPairs(2,i)], 'color', 'r');
	end
	box on; grid on; axis([minPair(1)-range(x)/40, minPair(1)+range(x)/40, -inf inf]);
end

% ====== Self demo
function selfdemo
objFunction='humps';
op.searchRange=[0.1, 0.95];
op.division=11;
op.depth=3;
op.plotOpt=1;
[minPair, allPairs]=feval(mfilename, objFunction, op);
fprintf('minX=%f, minY=%f\n', minPair(1), minPair(2));
x=linspace(op.searchRange(1), op.searchRange(2), 1001);
y=humps(x);
line(x, y, 'color', 'g'); grid on
set(gca, 'ylim', [min(y), max(y)]);