function [a, b, c]=gBellParam(d1, s1, d2, s2, plotOpt)
% gBellParam: Compute the parameters of gBellMf

if nargin<1, selfdemo; return; end
if nargin<5, plotOpt=0; end

t1=(1-s1)/s1;
t2=(1-s2)/s2;

c=0;
b=(log(t1/t2)/log(d1/d2))/2;
a=d1*(1/t1)^(1/(2*b));

if plotOpt
	x=max(abs([d1, d2, 2*d1, 2*d2]));
	x=linspace(x, -x);
	y=gbellmf(x, [a, b, c]);
	plot(x, y);
	line(d1, s1, 'marker', '.', 'color', 'r');
	line(d2, s2, 'marker', '.', 'color', 'r');
	text(d1, s1, sprintf('\\leftarrow (%g, %g)', d1, s1));
	text(d2, s2, sprintf('\\leftarrow (%g, %g)', d2, s2));
end

% ====== Selfdemo
function selfdemo
d1=1.53;
s1=0.95;
d2=2.35;
s2=0.3;
[a,b,c]=gBellParam(d1, s1, d2, s2, 1);