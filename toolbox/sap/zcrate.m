function out=zcRate(vec, showPlot)
% zcRate: Zero-crossing rate of a vector
%
%	Usage:
%		out=zcRate(vec)
%
%	Example:
%		vec=randn(100, 1);
%		zcr=zcRate(vec, 1);

%	Roger Jang, 20050729, 20150810

if nargin<1, selfdemo; return; end
if nargin<2, showPlot=0; end

%out=sum(abs(diff(vec>0)));			% 此列容易讓靜音的過零率偏高
out=sum(vec(1:end-1).*vec(2:end)<0);	% 位於零點上的資料點，不算過零！

if showPlot
	plot(vec); grid on
	for i=1:length(vec)-1
		if vec(i)*vec(i+1)<0
			line([i, i+1], [vec(i), vec(i+1)], 'color', 'r');
		end
	end
end

% === Selfdemo
function selfdemo
vec=randn(30, 1);
zcr=zcRate(vec, 1);