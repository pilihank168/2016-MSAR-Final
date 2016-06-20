function diffPlot(vec1, vec2)
%diffPlot: View the difference of two vectors
%	Usage: diffPlot(vec1, vec2)
%
%	For example:
%		x = randperm(10);
%		y = x.^(1/1000000000).^1000000000;
%		diffPlot(x, y);

%	Roger Jang, 20070706

if nargin<1, selfdemo; return ;end

vec1=vec1(:);
vec2=vec2(:);
name1=inputname(1);
name2=inputname(2);

subplot(2,1,1);
plot(1:length(vec1), vec1, '-', 1:length(vec2), vec2, '-');
grid on
title(sprintf('Curves of %s and %s\n', name1, name2));
legend(name1, name2);
subplot(2,1,2);
minLen=min(length(vec1), length(vec2));
plot(1:minLen, abs(vec1(1:minLen)-vec2(1:minLen)), '-');
maxAbsDiff=max(abs(vec1(1:minLen)-vec2(1:minLen)));
grid on
title(sprintf('Abs. diff. of %s and %s, with maxAbsDiff=%g\n', name1, name2, maxAbsDiff));

% ====== Self demo
function selfdemo
x = randperm(10);
y = x.^(1/1000000000).^1000000000;
diffPlot(x, y);