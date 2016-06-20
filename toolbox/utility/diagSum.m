function total=diagSum(A)
%diagSum: Compute the diagonal sum of a matrix
%
%	Usage:
%		total=diagSum(A);
%
%	Description:
%		total=diagSum(A) returns the diagonal sum of a square matrix A.
%		If the dimension of A is mxm, the return row vector is of length 2*m-1.
%
%	Example:
%		A=magic(3)
%		diagSum(A)
%
%	Roger Jang, 20110904

if nargin<1, selfdemo; return; end

[m, n]=size(A);
total=zeros(1, m+n-1);

if m<=n
	for i=1:m
		index=m+1-i:m+1:m*n;
		total(i)=sum(A(index(1:i)));
	end
	for i=m+1:n
		index=(i-m)*m+1:m+1:m*n;
		total(i)=sum(A(index(1:m)));
	end
	for i=n+1:m+n-1
		index=(i-m)*m+1:m+1:m*n;
		total(i)=sum(A(index(1:m+n-i)));
	end
else
	total=fliplr(diagSum(A'));
end


% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
