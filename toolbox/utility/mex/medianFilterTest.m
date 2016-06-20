fprintf('Compiling medianFilterMex.cpp...\n');
mex -I/users/jang/c/lib/utility medianFilterMex.cpp d:/users/jang/c/lib/utility/utility.cpp

caseNum=100;
order=5;
for i=1:caseNum
	fprintf('%d/%d\n', i, caseNum);
	x=rand(1000,1);
	out1=medianFilter(x, order);
	out2=medianFilterMex(x, order);
	difference(i)=max(abs(out1-out2));
	if (difference(i)~=0)
		plot([x, out1, out2]); legend('input', 'out1', 'out2');
		break;
	end
end
fprintf('Max difference = %g\n', max(difference));