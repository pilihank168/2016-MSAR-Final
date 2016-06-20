function out = matrixDuplicate(mat, p, q)
%matrixDuplicate: Matrix duplication
%	Usage: out = matrixDuplicate(mat, p, q)
%
%		matrixDuplicate(mat, p, q) returns a big matrix containing p X q mat.
%
%	For example:
%
%		a = [1 2; 3 4];
%		matrixDuplicate(a, 3, 4)
%
%		ans =
%
%		     1     2     1     2     1     2     1     2
%		     3     4     3     4     3     4     3     4
%		     1     2     1     2     1     2     1     2
%		     3     4     3     4     3     4     3     4
%		     1     2     1     2     1     2     1     2
%		     3     4     3     4     3     4     3     4
%
%	See also elementDuplicate.

% Roger Jang, 1995

out = mat((1:size(mat, 1))'*ones(1,p), (1:size(mat,2))'*ones(1,q));
