function count=cumHistCount(x, edges, plotOpt)
% cumHistCount: Find the count of x that is smaller than elements in edges
%	Usage: count=cumHistCount(x, edges)

if nargin<1; selfdemo; return; end
if nargin<3, plotOpt=0; end

edges2=[-inf; edges(:)];
count=histc(x, edges2);
count=cumsum(count);
count=count(1:end-1);

if plotOpt
	plot(edges, count, 'o-');
	xlabel('X smaller than');
	ylabel('Counts');
end

% ====== Self demo
function selfdemo
x=rand(1000, 1);
edges=0.1:0.1:1;
plotOpt=1;
count=cumHistCount(x, edges, plotOpt);