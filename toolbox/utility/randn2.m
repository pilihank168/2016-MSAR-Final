function z = randn2(n)
%RANDN2	2D Gaussian random samples with mean 0 and variance 1
%	Usage: OUT=RANDN2(N)
%		OUT is an N-by-2 matrix of points drawn from a 2D gaussian
%		distribution with mean 0 and variance 1.

if nargin==0, selfdemo; return; end

r = randn(n,1);
phi = rand(n,1)*2*pi;

x = r.*cos(phi);
y = r.*sin(phi);

z = [x, y];

function selfdemo
z = feval(mfilename, 500);
plot(z(:,1), z(:,2), '.');
