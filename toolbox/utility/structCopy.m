function C=structCopy(A, B)
%structCopy: Copy all fields of a structure to another
%
%	Usage:
%		A2=structCopy(A, B);
%
%	Example:
%		a.name='alex';
%		a.age=25;
%		b.gender='male';
%		b.age=20;
%		c=structCopy(a, b)

if nargin<1, selfdemo; return; end

fieldName=fieldnames(B);
C=A;
for i=1:length(fieldName)
	C.(fieldName{i})=B.(fieldName{i});
end

% ====== Vectorized version
% Reference page: http://stackoverflow.com/questions/38645/what-are-some-efficient-ways-to-combine-two-structures-in-matlab
%M = [fieldnames(A)' fieldnames(B)'; struct2cell(A)' struct2cell(B)'];
%[tmp, rows] = unique(M(1,:), 'last');
%M=M(:, rows);
%C=struct(M{:});

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);