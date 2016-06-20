function out = encodeXor(in, xorKey);
%encodeXor: data encoding using xor

%	Roger Jang, 20051202

out=in;
xorKey=abs(xorKey);
for i=1:length(out)
	j=mod(i-1, length(xorKey))+1;
	out(i)=bitxor(out(i), xorKey(j));
end