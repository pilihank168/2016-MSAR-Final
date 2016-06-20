function [yEstimated, excitation, coef]=sift(y, lpcOrder, showPlot);
% sift: SIFT
%
%	Usage:
%		[yEstimated, excitation, coef]=sift(y, lpcOrder, showPlot);
%
%	Example:
%		auFile='twinkle_twinkle_little_star.wav';
%		auFile='what_movies_have_you_seen_recently.wav';
%		au=myAudioRead(auFile);
%		frame=au.signal(12000:12000+512-1);
%		y2=sift(frame, 20, 1);

if nargin<1, selfdemo; return; end
if nargin<2, lpcOrder=20; end
if nargin<3, showPlot=1; end

coef = lpc(y, lpcOrder);
yEstimated = filter([0 -coef(2:end)], 1, y);	% Estimated signal
excitation = y - yEstimated;			% Prediction error

if any(isnan(coef))	% Where nan occurs when y is a zero vector?
	coef=zeros(size(coef));
	yEstimated=zeros(size(yEstimated));
	excitation=zeros(size(excitation));
end

if showPlot
	plot(1:length(y), y, 1:length(yEstimated), yEstimated, 1:length(excitation), excitation);
	legend('Original', 'Estimated', 'Excitation');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);