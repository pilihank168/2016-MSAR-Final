function output=axisLimitSame(xRange, figH)
%axisLimitSame: Adjust all subplots in a plot windows to have the same limits
%
%	Example:
%		subplot(211); plot(rand(10));
%		subplot(212); plot(10*rand(3));
%		axisLimitSame(gcf);

if nargin<2, figH=gcf; end

axesH=findobj(figH, 'type', 'axes');
for i=1:length(axesH)
	set(axesH(i), 'xlim', xRange);
end
