function dist=boxDistance(bb1, bb2, showPlot)
% boxDistance: Distance between two bounding box
%	Usage:
%		boxDistance(bb1, bb2, showPlot)
%
%	Description:
%		boxDistance(bb1, bb2) returns the distance between two BBs, which is defined as the sum of L-1 norm between left-up corners and right-down corners.
%
%	Example:
%		bb1=[3 5 8 8];
%		bb2=[5 4 9 5];
%		subplot(2,2,1);
%		dist=boxDistance(bb1, bb2, 1);
%		axis image; title(sprintf('distance=%d\n', dist));
%		bb1=[3 5 8 8];
%		bb2=[11 10 9 5];
%		subplot(2,2,2);
%		dist=boxDistance(bb1, bb2, 1);
%		axis image; title(sprintf('distance=%d\n', dist));
%		bb1=[3 5 8 8];
%		bb2=[11 13 9 5];
%		subplot(2,2,3);
%		dist=boxDistance(bb1, bb2, 1);
%		axis image; title(sprintf('distance=%d\n', dist));
%		bb1=[3 5 8 8];
%		bb2=[12 14 9 5];
%		subplot(2,2,4);
%		dist=boxDistance(bb1, bb2, 1);
%		axis image; title(sprintf('distance=%d\n', dist));

if nargin<1, selfdemo; return; end
if nargin<3, showPlot=0; end

leftUp1=[bb1(1), bb1(2)];
rightDown1=[bb1(1)+bb1(3), bb1(2)+bb1(4)];
leftUp2=[bb2(1), bb2(2)];
rightDown2=[bb2(1)+bb2(3), bb2(2)+bb2(4)];
dist=sum(abs(leftUp1-leftUp2))+sum(abs(rightDown1-rightDown2));

if showPlot
	boxOverlay(bb1, getColor(1), 2);
	boxOverlay(bb2, getColor(2), 2);
	box on;
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);