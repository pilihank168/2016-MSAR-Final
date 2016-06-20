function [value, index] = elementRandom(mat)
%elementRandom: Select a random element from a matrix
%	Usage: [value, index] = elementRandom(mat)
%
%	Selects a random element from the matrix mat.
%	The returned index is always a scalar.

%	Roger Jang, 19960922

index = ceil(rand*prod(size(mat)));
value = mat(index);
