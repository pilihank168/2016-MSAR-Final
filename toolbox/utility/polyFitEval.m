function [rmse, deviation, predicted, xScaled, meanValue, stdValue]=polyfitEval(x, y, order, showPlot)
% polyfitEval: Polynomial fitting and evaluation, using scaled input
%
%	Usage:
%		[rmse, deviation, predicted, xScaled, meanValue, stdValue]=polyfitEval(x, y, order, showPlot)
%
%	Example:
%		load census.mat
%		order=5;
%		showPlot=1;
%		[rmse, derivation, predicted, xScaled]=polyfitEval(cdate, pop, order, showPlot);

if nargin<1, selfdemo; return; end
if nargin<4, showPlot=0; end

if length(x)<order+1
	rmse=0;
	deviation=0*x;
	predicted=y;
	return
end

% Rescaling to avoid roundoff/truncation error
meanValue=mean(x);
stdValue=std(x);
xScaled=(x-meanValue)/stdValue;
coef=polyfit(xScaled, y, order);
predicted=polyval(coef, xScaled);
deviation=abs(y-predicted);
rmse=sqrt(sum(deviation.^2)/length(deviation));

if showPlot
	plot(x, y, 'ro');
	xNew=linspace(min(xScaled), max(xScaled), 101);
	yDense=polyval(coef, xNew);
	line(xNew*stdValue+meanValue, yDense);
	xlabel('X'); ylabel('Y'); title(sprintf('Polynomial fitting with order=%d, rmse=%f', order, rmse));
	legend('Sample data', sprintf('Order-%d polynomial', order), 'location', 'best');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
