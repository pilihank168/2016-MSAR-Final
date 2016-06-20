function barPlot(data, xTickLabel)
% barPlot: Plot of 1-D data as bars and texts
%	Usage: barPlot(data, xTickLabel)
%
%	For example:
%		data = rand(1, 10);
%		dataNum = length(data);
%		xTickLabel={};
%		for i=1:dataNum
%			xTickLabel={xTickLabel{:}, sprintf('第 %d 筆資料', i)};
%		end
%		barPlot(data, xTickLabel);

%	Roger Jang, 20071009

if nargin<1, selfdemo; return; end

dataNum=length(data);
%subplot(2,1,1);
bar(1:dataNum, data, 'c');
set(gca, 'xticklabel', []);
grid on;

for i=1:dataNum
	text(i, 0, xTickLabel{i});
end
h = findobj(gcf, 'type', 'text');
set(h, 'rot', 90, 'horizontal', 'left');

% ====== Self demo
function selfdemo
data = rand(1, 10);
dataNum = length(data);
xTickLabel={};
for i=1:dataNum
	xTickLabel={xTickLabel{:}, sprintf('第 %d 筆資料', i)};
end
feval(mfilename, data, xTickLabel);