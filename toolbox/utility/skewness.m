function out=skewness(hist, x)
% skewness: Skewness of a histogram
%
%	Usage:
%		out=skewness(hist, x)
%
%	Reference:
%		http://en.wikipedia.org/wiki/Skewness	

%	Roger Jang, 20140330

if nargin<2, x=1:length(hist); end

mu=dot(hist, x)/sum(hist);	% E(X);
ex2=dot(hist, x.^2)/sum(hist);	% E(X^2);
ex3=dot(hist, x.^3)/sum(hist);	% E(X^3);
sigma=sqrt(ex2-mu^2);		% sigma
out=(ex3-3*mu*sigma*sigma-3*mu^3)/(sigma^3);


