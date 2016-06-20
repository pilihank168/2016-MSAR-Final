function rrPlot(student)
%rrPlot: Plot of recognition rates of each student's algorithm
%
%	Usage:
%		rrPlot(student)
%
%	Description:
%		rrPlot(student) plots the RR (recognition rate) of each student
%			student(i).rr: RR of student i
%			student(i).name: name of student i
%
%	Example:
%		student(1).name='Roger'; student(1).rr=0.9; student(1).time=10;
%		student(2).name='exampleProgram'; student(2).rr=0.75; student(2).time=5;
%		student(3).name='Tom'; student(3).rr=0.72; student(3).time=3;
%		student(4).name='John'; student(4).rr=0.85; student(4).time=6;
%		rrPlot(student);

%	Roger Jang, 20150328

if nargin<1; selfdemo; return; end

% 畫出辨識率排行榜
rr=[student.rr];
[junk, index]=sort(rr);
student=student(index);		% 依辨識率排序
rr=100*[student.rr];
subplot(2,1,1);
stem(1:length(rr), rr);
line(1:length(rr), rr, 'color', 'k');
ylabel('Recog. rate (%)'); title('Ranking of recog. rates'); grid on
set(gca, 'xticklabel', {});
for i=1:length(rr)
	h=text(i, min(rr)-10, strPurify(student(i).name), 'horizon', 'right', 'rotation', 90);
end
axis([1 length(student) min(rr)-10 100]);

index=find(strcmp({student.name}, 'exampleProgram'));
if ~isempty(index)
	axisLimit=axis;
	line(axisLimit(1:2), student(index).rr*[1 1]*100, 'color', 'r');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
