setNum=10000;
incidenceMat=sparse(rand(setNum, 411)>0.99);
selectedNum=100;

[selectedIndex1, coverRate1] = setCover(incidenceMat, 20);
[selectedIndex2, coverRate2] = setCoverMex(incidenceMat, 20);

isequal(selectedIndex1, selectedIndex2)
max(abs(coverRate1-coverRate2))

plot(1:length(coverRate1), coverRate1, 'r-o', ...
	1:length(coverRate2), coverRate2, 'k-*');
xlabel('No. of selected sets');
ylabel('Coverage rates');
grid on
