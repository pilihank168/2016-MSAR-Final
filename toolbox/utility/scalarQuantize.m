function [output, index]=scalarQuantize(input, level)
%scalarQuantize: Scalar quantization
%	Usage:[output, index]=scalarQuantiz(input, level)

%	Roger Jang, 20050121

if nargin<1; selfdemo; return; end

boundary=(level(1:end-1)+level(2:end))/2;
index=quantiz(input, boundary)+1;
output=level(index);

% ====== Selfdemo
function selfdemo
input=10*rand(1, 8);
level=[2 4 8];
[output, index]=feval(mfilename, input, level);
fprintf('input = %s\n', mat2str(input));
fprintf('level = %s\n', mat2str(level));
fprintf('output = %s(input, level) = %s\n', mfilename, mat2str(output));