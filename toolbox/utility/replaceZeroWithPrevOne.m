function out=replaceZeroWithPrevOne(in);
% replaceZeroWithPrevOne: Replace zero with previous non-zero element

%	Roger Jang, 20051004

if in(1)==0
	error('The first element should not be zero!');
end

out=in;
for i=2:length(out)
	if out(i)==0
		out(i)=out(i-1);
	end
end
