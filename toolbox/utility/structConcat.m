function C=structConcat(A, B)
%structCopy: Cooncatenate two struct arrays of potentially different field names
%
%	Usage:
%		c=structConcat(a, b);
%
%	Example:
%		a.name='alex';
%		a.age=21;
%		a(2).height=180;
%		b.name='timmy';
%		b.gender='male';
%		c=structConcat(a, b)

if nargin<1, selfdemo; return; end

A=A(:); B=B(:);
fieldNameA=fieldnames(A);
fieldNameB=fieldnames(B);
fieldNameNotInA=setdiff(fieldNameB, fieldNameA);
for i=1:length(fieldNameNotInA)
	A(1).(fieldNameNotInA{i})=[];
end
fieldNameNotInB=setdiff(fieldNameA, fieldNameB);
for i=1:length(fieldNameNotInB)
	B(1).(fieldNameNotInB{i})=[];
end
C=[A; B];

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);