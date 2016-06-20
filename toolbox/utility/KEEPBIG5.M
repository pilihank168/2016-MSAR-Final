function out = keepbig5(str)
% KEEPBIG5 Keep big5 character in a string; gets rid of non-big5 characters
%	Usage: OUT = KEEPBIG5(INPUT)
%		INPUT = false two-byte Chinese big5 string
%			(See the example in the self-demo.)
%		OUT = true two-byte Chinese big5 string
%
%	If the input is a true two-byte Chinese big5 string, you can simply
%	get rid of non-big characters by the one-liner:
%	str(find(str < hex2dec('a440'))) = [];
%
%	Roger Jang, 981107

if nargin == 0,
	str =[186 244 184 244 164 87 44 45 124 170 186 170 218 190 70 56];
	str = char(str);
	fprintf('Original string = %s\n', str);
	fprintf('Original length = %g\n', length(str));
	big5 = keepbig5(str);
	fprintf('New string = %s\n', big5);
	fprintf('New length = %g\n', length(big5));
end

len = length(str);
del_index = [];
i = 1;
while (i < len)
	if mod(i, 100) == 0,
		fprintf('%g/%g\n', i, len);
	end
	double_byte = str(i:i+1);
	if isbig5(double_byte),
		i = i + 2;
	else
		del_index = [del_index, i];
		i = i + 1;
	end
end

out = str;
% Get rid of the non-big5 characters
out(del_index) = [];
% Get rid of the last byte if the length is odd
if mod(length(out), 2) ~= 0,
	out(end) = [];
end

% Recombine to have true double-byte characters
out = char(out(1:2:end)*256+out(2:2:end));
