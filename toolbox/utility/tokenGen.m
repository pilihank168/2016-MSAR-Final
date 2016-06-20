function tokens=tokenGen(string, n);
%tokenGen: Generate all possible token sequenes of length n from a given string
%
%	Usage:
%		tokens=tokenGen(string, n);
%

%	Roger Jang, 20110305

if nargin<1, selfdemo; return; end

if n<=1
	tokens{1}=string;
	return
end

tokens={};
for i=1:length(string)-1
	head=string(1:i);
	rest=string(i+1:end);
	restTokens=tokenGen(rest, n-1);
	for j=1:length(restTokens)
		tokens{end+1}=sprintf('%s-%s', head, restTokens{j});
	end
end

% ====== Selfdemo
function selfdemo
string='abcdef';
output=tokenGen(string, 3);
fprintf('string=%s\n', string);
fprintf('output of tokenGen(string, 3):\n');
disp(output);
