function localMinIndex=localMin(vec, plotOpt)
% localMin: Local minima with averaging centers (a for-loop version)
%	Usage: localMinIndex=localMin(vec, plotOpt)

if nargin<1, selfdemo; return; end
if nargin<2, plotOpt=0; end

localMinIndex=[];
inRegion=0;
for i=2:length(vec)
	if vec(i-1)>vec(i)
		start=i;
		inRegion=1;
	end
	if vec(i-1)<vec(i) & inRegion==1
		stop=i;
		inRegion=0;
		localMinIndex=[localMinIndex, floor((start+stop)/2)];
	end
end

if plotOpt
	plot(vec, '.-');
	line(localMinIndex, vec(localMinIndex), 'color', 'm', 'marker', 'o', 'linestyle', 'none');
end

% ====== Self demo
function selfdemo
vec=[1;2;3;3;3;3;4;3;2;4;4;5;5;5;5;5;5;6;6;6;6;3;3;3;3;6;6;6;6;6;6;5;5;5;;5;5;5;5;6;6;6;6;6;6;5;5;5;5;4;5;3;5;5;4];
plotOpt=1;
feval(mfilename, vec, plotOpt);