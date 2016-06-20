function out = maxConsElement(vector, element)
%maxConsElement: Max. number of a given consecutive element in a vector
%	Usage: out = maxConsElement(vector, element)
%
%	For example:
%		vector = [1 2 2 2 3 3 4 4 2 2 2 3 2 2 2 2 2 2 2 3 3 2 2 1 2];
%		element = 2;
%		out = maxConsElement(vector, 2);
%		fprintf('Test vector: ');
%		fprintf('%g ', vector); fprintf('\n');
%		fprintf('Searched element: %g\n', element);
%		fprintf('Max. no. of consecutive %g''s: %g\n', element, out);

%	Roger Jang, 19990822, 20071009

if nargin<1, selfdemo; return, end

index = vector==element;
index = [0 index 0];
tmp = diff(index);
ind1 = find(tmp==1);
ind2 = find(tmp==-1);
out = max(ind2-ind1);

% ========== Subfunction ==========
function selfdemo
vector = [1 2 2 2 3 3 4 4 2 2 2 3 2 2 2 2 2 2 2 3 3 2 2 1 2];
element = 2;
out = feval(mfilename, vector, 2);
fprintf('Test vector: ');
fprintf('%g ', vector); fprintf('\n');
fprintf('Searched element: %g\n', element);
fprintf('Max. no. of consecutive %g''s: %g\n', element, out);