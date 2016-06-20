%% localMax
% 
%% Syntax
% * 		index = localMax(x, method, showPlot)
% * 			x: Input vector, or a matrix
% * 			method: a string to specify how to handle the first and last elements
% * 				'keepBoth' to keep the first and last elemetns if they are local max.
% * 				'keepFirst' to keep the first element if it is a local max.
% * 				'keepLast' to keep the last element if it is a local max.
% * 				'keepNone' to keep neither the first nor the last elements (default)
% * 			index: A 0-1 index vector indicating where the local maxima are.
% * 			showPlot: 1 for plotting
%% Description
%
% <html>
% </html>
%% Example
%%
%
t = 0:0.2:2*pi;
x = sin(t)+randn(size(t));
method = 'keepBoth';
index = localMax(x, method, 1);
