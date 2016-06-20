%% diagSum
% Compute the diagonal sum of a matrix
%% Syntax
% * 		total=diagSum(A);
%% Description
%
% <html>
% <p>total=diagSum(A) returns the diagonal sum of a square matrix A.
% <p>If the dimension of A is mxm, the return row vector is of length 2*m-1.
% </html>
%% Example
%%
%
A=magic(3)
diagSum(A)
