function out=isUpper(string)

list='ABCDEFGHIJKLMNOPQRSTUVWXYZ';

out=zeros(1,length(string));
for i=1:length(string)
	out(i)=any(string(i)==list);
end