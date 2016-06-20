function newString = charCutLeadingTrailing(string, theChar);
%charCutLeadingTrailing: Cut leading/trailing chars within a given string
%	Usage: newString = charCutLeadingTrailing(string, theChar)

%	Roger Jang, 20090615

if nargin<1, selfdemo; return; end
if nargin<2, theChar=' '; end

newString=string;
while newString(1)==theChar
	newString(1)=[];
end
while newString(end)==theChar
	newString(end)=[];
end

% ====== Self demo
function selfdemo
string='...And the time comes....';
theChar='.';
output=feval(mfilename, string, theChar);
fprintf('input=%s\n', string);
fprintf('theChar=%s\n', theChar);
fprintf('output=%s\n', output);