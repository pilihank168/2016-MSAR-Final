function index = localMin(x, plotOpt)
%localMin: Find local minima of a vector (a simplified, vectorized version)
%	Usage: index = localMin(x, plotOpt)
%		index: A 0-1 index vector indicating where the local minima are.
%		x: Input COLUMN vector, or a matrix
%		plotOpt: 1 for plotting
%
%	For example:
%		t = 0:0.2:2*pi;
%		x = sin(t)+randn(size(t));
%		index = localMin(x, 1);

%	Roger Jang, 19990101, 20100617

if nargin<1, selfdemo; return; end
if nargin<2, plotOpt=0; end

b1 = x(2:end-1, :)<=x(1:end-2, :);
b2 = x(2:end-1, :)<x(3:end, :);
index = 0*x;
index(2:end-1, :) = b1 & b2;
% Check the first and the last points
%if x(1)<x(2), index(1)=1; end
%if x(end)<x(end-1), index(end)=1; end

if plotOpt,
	time = 1:length(x);
	plot(time, x, time(logical(index)), x(logical(index)), 'ro');
end

% ====== Self demo
function selfdemo
t = 0:0.2:2*pi;
x = sin(t)+randn(size(t));
x = x(:);
index = feval(mfilename, x, 1);