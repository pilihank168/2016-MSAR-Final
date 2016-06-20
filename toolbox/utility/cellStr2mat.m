function mat = cellStr2mat(cellStr)
% cellstr: Cell string to string conversion
%
%	For example:
%		x={'12', '34', '-6'};
%		y=cellStr2mat(x)

%	Roger Jang, 20081021

[m, n]=size(cellStr);
mat=zeros(m, n);
for i=1:m
	for j=1:n
		mat(i,j)=eval(cellStr{i,j});
	end
end