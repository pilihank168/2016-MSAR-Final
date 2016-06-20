opt.x=-1;
opt.y=1;
opPrm.x.range=[-4, 4];
opPrm.x.resolution=201;
opPrm.y.range=[-4, 4];
opPrm.y.resolution=301;
[opt, maxPerf]=coordinateSearch('peaksFcn', opt, opPrm);

return

load insurance.txt
age=insurance(:,1);
male=insurance(:,2);
female=insurance(:,3);
index=find(age==35);
total=0;
for i=1:20
	total=total+female(index+i-1)*(1+3/100/12)^((21-i)*12);
end

fprintf('保費總值：%f萬\n', total/10000);
fprintf('總繳保費：%f萬\n', sum(female(index+1:index+20))/10000);