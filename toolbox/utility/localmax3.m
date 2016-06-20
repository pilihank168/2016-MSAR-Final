function [index1, index2]=localmax2(x, wing, plotOpt)
%LOCALMAX2 Local maxima which are global maxima within [-wing, +wing]
%	Usage: [index1, index2]=localmax2(x, wing, plotOpt)
%		index1: index of local maxima
%		index2: index of local maxima that are global maxima within [-wing, +wing]
%		x: input vector
%		wing: [-wing, +wing] (inclusive) is the span for determining index2 (unit for wing is sample point)
%		plotOpt: plot option

%	Roger Jang, 20020829

if nargin<1, selfdemo; return; end
if nargin<2, wing=10; end
if nargin<3, plotOpt=0; end

index1=find(localmax(x));

% ====== Keep local maxima that are largest within [-wing, +wing]
index2=[];
for i=1:length(index1),
	from=max(1, index1(i)-wing);
	to=min(length(x), index1(i)+wing);
	if x(index1(i))==max(x(from:to)),
		index2=[index2, index1(i)];
	end
end

% ====== Plotting
if plotOpt,
	time=1:length(x);
	plot(time, x, '.-');
	set(gca, 'xlim', [-inf inf]);
	axisLimit=axis;
	for i=1:length(index1),
		line(time(index1(i))*[1,1], axisLimit(3:4), 'color', 'g');
		line(time(index1(i)), x(index1(i)), 'marker', 'o', 'color', 'g', 'linestyle', 'none');
	end
	for i=1:length(index2),
		line(time(index2(i))*[1,1], axisLimit(3:4), 'color', 'r');
		line(time(index2(i)), x(index2(i)), 'marker', 'square', 'color', 'r', 'linestyle', 'none');
	end
	xlabel('Sample index');
end

% ====== self demo
function selfdemo

x=rand(1,50);
wing=8;
plotOpt=1;
[index1, index2]=feval(mfilename, x, wing, plotOpt);
title(sprintf('Yellow line: local max, Red line: local max which is global within [-%g, +%g] (seconds)', wing, wing)); 