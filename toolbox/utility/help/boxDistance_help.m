%% boxDistance
% Distance between two bounding box
%% Syntax
% * 		boxDistance(bb1, bb2, showPlot)
%% Description
% 		boxDistance(bb1, bb2) returns the distance between two BBs, which is defined as the sum of L-1 norm between left-up corners and right-down corners.
%% Example
%%
%
bb1=[3 5 8 8];
bb2=[5 4 9 5];
subplot(2,2,1);
dist=boxDistance(bb1, bb2, 1);
axis image; title(sprintf('distance=%d\n', dist));
bb1=[3 5 8 8];
bb2=[11 10 9 5];
subplot(2,2,2);
dist=boxDistance(bb1, bb2, 1);
axis image; title(sprintf('distance=%d\n', dist));
bb1=[3 5 8 8];
bb2=[11 13 9 5];
subplot(2,2,3);
dist=boxDistance(bb1, bb2, 1);
axis image; title(sprintf('distance=%d\n', dist));
bb1=[3 5 8 8];
bb2=[12 14 9 5];
subplot(2,2,4);
dist=boxDistance(bb1, bb2, 1);
axis image; title(sprintf('distance=%d\n', dist));
