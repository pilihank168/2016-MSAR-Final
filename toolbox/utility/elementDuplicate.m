function out = elementDuplicate(mat, p, q)
%elementDuplicate: Matrix element duplication
%	Usage: out = elementDuplicate(mat, p, q)
%
%	elementDuplicate(mat, p, q) return a big matrix containing p X q elements of mat.
%
%	For example:
%
%		a = [1 2; 3 4];
%		elementDuplicate(a, 5, 2)
%
%		ans =
%
%		     1     1     2     2
%		     1     1     2     2
%		     1     1     2     2
%		     1     1     2     2
%		     1     1     2     2
%		     3     3     4     4
%		     3     3     4     4
%		     3     3     4     4
%		     3     3     4     4
%		     3     3     4     4
%
%	See also matrixDuplicate.

% Roger Jang, 1995

out = mat(ones(p,1)*(1:size(mat,1)), ones(q,1)*(1:size(mat,2)));
