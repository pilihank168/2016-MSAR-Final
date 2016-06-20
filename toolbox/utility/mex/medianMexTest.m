fprintf('Compiling medianMex.cpp...\n');
mex -I/users/jang/c/lib/utility medianMex.cpp d:/users/jang/c/lib/utility/utility.cpp

caseNum=100;
for i=1:caseNum
%	fprintf('%d/%d:\n', i, caseNum);
	x=rand(1000, 1);
%	x=randperm(6);
	m1(i)=median(x);
	m2(i)=medianMex(x);
end
fprintf('Difference = %g\n', sum(abs(m1-m2)));

vecSize=5000;
caseNum=1000;
data=rand(vecSize, caseNum);
tic
for i=1:caseNum
	m=median(data(:,i));
end
time1=toc;
fprintf('time for builtin median.m = %g seconds\n', time1);

tic
for i=1:caseNum
	m=medianMex(data(:,i));
end
time2=toc;
fprintf('time for medianMex = %g seconds\n', time2);
fprintf('Time ratio = %g/%g = %g\n', time1, time2, time1/time2);