function colIndex=sameValueCol(x)
% sameValueCol: Return the index of same-value column in a matrix
%	Usage: colIndex=sameValueCol(x)

% Roger Jang, 20060818

if nargin<1, selfdemo; return; end

colIndex=sum(abs(diff(x)))==0;

% ====== Self demo
function selfdemo
x=[1 2 3 9 ; 1 5 7 9; 1 8 2 9];
colIndex=feval(mfilename, x);
fprintf('x=\n'); disp(x);
fprintf('colIndex=%s(x) produces\n', mfilename);
fprintf('colIndex=\n'); disp(colIndex);