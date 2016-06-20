%% boxSetDistance
% Distance between two bounding box
%% Syntax
% * 		distMat=boxSetDistance(objSet1, objSet2, plotOpt)
%% Description
%
% <html>
% </html>
%% Example
%%
%
objSet1(1).BoundingBox=[3 5 6 4];
objSet1(2).BoundingBox=[5 4 9 3];
objSet2(1).BoundingBox=[10 10 4 5];
objSet2(2).BoundingBox=[8 13 5 4];
objSet2(3).BoundingBox=[12 14 9 5];
distMat=boxSetDistance(objSet1, objSet2, 1);
axis image; title(sprintf('distance=%s\n', mat2str(distMat)));
%% See Also
% <boxDistance_help.html boxDistance>.
