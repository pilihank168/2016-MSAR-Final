function funcName=funcExtract(fileName)
% funcExtract: Extract possible function names from a given M file
%	Usage: funcName=funcExtract(fileName)

%	Roger Jang, 20080913

if nargin<1, selfdemo; return; end

contents = textread(fileName,'%s','delimiter','\n','whitespace','', 'bufsize', 20000);
pat='\s*(\w+?)\(';

funcName={};
for i=1:length(contents)
	line=contents{i};
	tokens = regexp(line, pat, 'tokens');
	for j=1:length(tokens);
		for k=1:length(tokens{j})
			funcName{end+1}=tokens{j}{k};
		end
	end
end
funcName=unique(funcName);

% ====== Self demo
function selfdemo
fileName=mfilename;
funcName=funcExtract(fileName)
