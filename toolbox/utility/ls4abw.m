function [a, b]=ls4abw(w, h, plotOpt)
% Least-squares solution to a*b^T=w
%	Usage: [a, b]=ls4abw(w, h)
%		This function returns the least-squares solution to a*b^T=w, where
%		a: mxh vector
%		b: nxh vector
%		w: mxn matrix
%
%	This function uses iterative least-squares to solve the problem.

%	Roger Jang, 20100229, 20110512

if nargin<1, selfdemo, return; end
if nargin<2, h=1; end
if nargin<3, plotOpt=0; end

maxIter=100;
tolerance=eps;
[m, n]=size(w);
a=rand(m,h);
b=rand(n,h);
obj=zeros(maxIter, 1);

for i=1:maxIter
	aOld=a;
	bOld=b;
%	a=w*b/(b'*b);
%	b=w'*a/(a'*a);
	a=w/(b.');
	b=(a\w).';
	error=a*b'-w;
	obj(i)=sum(sum(error.^2));
	if norm(a-aOld)<tolerance & norm(b-bOld)<tolerance
		realIterCount=i-1;
		break;
	end
	if plotOpt
		fprintf('%d/%d: obj=%f, a=%s^T, b=%s^T\n', i, maxIter, obj(i), mat2str(a, 4), mat2str(b, 4));
	end
	if obj(i)<tolerance
		realIterCount=i-1;
		break;
	end
	realIterCount=i;
end
obj=obj(1:realIterCount);
if plotOpt
	plot(1:realIterCount, obj, '.-');
end

% ====== Self demo
function selfdemo
h=2;
w=rand(30, 40);
%w=rand(30, h)*rand(h, 40);
plotOpt=1;
[a, b]=feval(mfilename, w, h, plotOpt);
