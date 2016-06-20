function output=saturate(x, level)
%saturate: Saturate between two level (bound limiter)
%	Usage:output=saturate(x, level)
%		output: output value
%		x: input value
%		level: level(1)==>lower bound, level(2)==>upper bound
%
%	For example:
%		x=linspace(0, 10);
%		level=[3 5];
%		y=saturate(x, level);
%		plot(x, x, x, y, 'o-');
%		axis image

%	Roger Jang, 20071009


if nargin<1, selfdemo; return; end

output=x;
output(find(output<=level(1)))=level(1);
output(find(output>=level(2)))=level(2);

% ====== selfdemo
function selfdemo
x=linspace(0, 10);
level=[3 5];
y=feval(mfilename, x, level);
plot(x, x, x, y, 'o-');
axis image