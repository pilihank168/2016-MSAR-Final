function theta=lineFit(x, y, showPlot)
% Line fit via lease-squares estimate
%
%	Usage:
%		theta=lineFit(x, y, showPlot)
%
%	Description:
%		theta=lineFit(x, y) returns the line y=theta(1)*x+theta(2) via least-squares estimate.
%
%	Example:
%		x=[1.44  2.27  4.12  3.04  5.13  7.01  7.01 10.15  8.30  9.88];
%		y=[8.20 11.12 14.31 17.78 17.07 21.95 25.11 30.19 30.95 36.05];
%		theta=lineFit(x, y, 1);
%
%	See also totalLeastSqaures.

%	Category: Least squares
%	Roger Jang, 20120106

if nargin<1, selfdemo; return; end
if nargin<3, showPlot=0; end

A=[x(:), x(:).^0];
theta=A\y(:);

if showPlot
	x2=linspace(min(x), max(x));
	y2=theta(1)*x2+theta(2);
	plot(x, y, 'ro', x2, y2, 'b-');
	title('Total least-squares fit');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);