function rowIndex=sameValueRow(x)
% sameValueRow: Return the index of same-value row in a matrix
%	Usage: rowIndex=sameValueRow(x)

% Roger Jang, 20060818

if nargin<1, selfdemo; return; end

rowIndex=sum(abs(diff(x')'), 2)==0;

% ====== Self demo
function selfdemo
x=[1 2 3 9 ; 1 5 7 9; 1 8 2 9]';
rowIndex=feval(mfilename, x);
fprintf('x=\n'); disp(x);
fprintf('rowIndex=%s(x) produces\n', mfilename);
fprintf('rowIndex=\n'); disp(rowIndex);