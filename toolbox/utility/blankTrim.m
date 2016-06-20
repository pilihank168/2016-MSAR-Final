function out=blankTrim(string)
% blankTrim: Delete leading and trailing blanks, and then merge consecutive blanks into one.
%	Usage: out=blankTrim(string)

%	Roger Jang, 20070129

out=string;
out=regexprep(out, '^\s+', '');		% Trim leading blank
out=regexprep(out, '\s+$', '');		% Trim trailing blank
%out=regexprep(out, '^\s+|\s+$', '');		% Trim leading/trailing blank
out=regexprep(out, '\s+', ' ');			% Merge multiple blanks into one
