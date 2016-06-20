function output=findInRange(range, value)
% findInRange: Find the range of a given value
%	Usage: output=findInRange(range, value);
%		range: a sorted monotonically increasing vector
%		value: value whose range is to be found
%		output: output=0 if value<range[1];
%			output=length(range) if range[end]<=value
%			output=i if range[i]<=value<range[i+1]

%	Roger Jang, 20041229

if nargin<1; selfdemo; return; end

output=0*value;

for i=1:length(value)
	index=find(range-value(i)>0);
	if isempty(index)
		output(i)=length(range);
	else
		output(i)=index(1)-1;
	end
end

% ====== Self demo
function selfdemo
range=[2 4 6 8]; value=1;
output=feval(mfilename, range, value);
fprintf('findInRange(%s, %s) = %s\n', mat2str(range), mat2str(value), mat2str(output));
range=[2 4 6 8]; value=2;
output=feval(mfilename, range, value);
fprintf('findInRange(%s, %s) = %s\n', mat2str(range), mat2str(value), mat2str(output));
range=[2 4 6 8]; value=3;
output=feval(mfilename, range, value);
fprintf('findInRange(%s, %s) = %s\n', mat2str(range), mat2str(value), mat2str(output));
range=[2 4 6 8]; value=9;
output=feval(mfilename, range, value);
fprintf('findInRange(%s, %s) = %s\n', mat2str(range), mat2str(value), mat2str(output));
range=[2 4 6 8]; value=[2 3 9];
output=feval(mfilename, range, value);
fprintf('findInRange(%s, %s) = %s\n', mat2str(range), mat2str(value), mat2str(output));

