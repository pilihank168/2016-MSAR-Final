%% lineFit
% 
%% Syntax
% * 		theta=lineFit(x, y, showPlot)
%% Description
% 		theta=lineFit(x, y) returns the line y=theta(1)*x+theta(2) via least-squares estimate.
%% Example
%%
%
x=[1.44  2.27  4.12  3.04  5.13  7.01  7.01 10.15  8.30  9.88];
y=[8.20 11.12 14.31 17.78 17.07 21.95 25.11 30.19 30.95 36.05];
theta=lineFit(x, y, 1);
%% See Also
% <totalLeastSqaures_help.html totalLeastSqaures>.
