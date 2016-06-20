function rrVsTimePlot(student)
%rrVsTimePlot: Plot of recognition rates vs. time

if nargin<1; selfdemo; return; end

for i=1:length(student)
	line(student(i).time, student(i).rr*100, 'color', 'r', 'marker', 'o');
	text(student(i).time, student(i).rr*100, student(i).name, 'vertical', 'top', 'hori', 'center');
end
box on
xlabel('Computing time (sec)'); ylabel('Recog. rate (%)'); grid on

index=find(strcmp({student.name}, 'exampleProgram'));
if ~isempty(index)
	axisLimit=axis;
	line(axisLimit(1:2), student(index).rr*[1 1]*100, 'color', 'r');
end


% ====== Self demo
function selfdemo
student(1).name='Roger'; student(1).rr=0.9; student(1).time=10;
student(2).name='exampleProgram'; student(2).rr=0.75; student(2).time=5;
student(3).name='Tom'; student(3).rr=0.72; student(3).time=3;
student(4).name='John'; student(4).rr=0.85; student(4).time=6;
rrVsTimePlot(student);
