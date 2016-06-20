%% boxIntersect
% Intersection of two bounding boxes
%% Syntax
% * 		boxIntersect(bb, color, width)
%% Description
%
% <html>
% </html>
%% Example
%%
%
bb1=[3 5 8 8]; bb2=[5 4 9 5];
subplot(2,2,1);
output=boxIntersect(bb1, bb2, 1);
axis image; title(sprintf('output=%d\n', output));
bb1=[3 5 8 8]; bb2=[11 10 9 5];
subplot(2,2,2);
output=boxIntersect(bb1, bb2, 1);
axis image; title(sprintf('output=%d\n', output));
bb1=[3 5 8 8]; bb2=[11 13 9 5];
subplot(2,2,3);
output=boxIntersect(bb1, bb2, 1);
axis image; title(sprintf('output=%d\n', output));
bb1=[3 5 8 8]; bb2=[12 14 9 5];
subplot(2,2,4);
output=boxIntersect(bb1, bb2, 1);
axis image; title(sprintf('output=%d\n', output));
