function figure2eps(epsFileName, mode)
% figure2eps: Save figure to eps file
%	Usage: figure2eps(epsFileName, mode)
%		epsFileName: eps file to save
%		mode: 0 for whole figure, 1 for subplot(2,1,1)
%
%	For example:
%		peaks;
%		epsFile=[tempname, '.eps'];
%		figure2eps(epsFile);
%		dos(['start ', epsFile]);

% Roger Jang, 20000101

if nargin<2, mode=0; end

if mode~=0	% Save subplot(2,1,1). (Seems not working!)
	set(gcf, 'paperposition', [0.25, 2.5, 8, 3])
end
cmd = ['print -deps -tiff -r600 ', epsFileName];
fprintf('Write figure to %s\n', epsFileName);
eval(cmd);