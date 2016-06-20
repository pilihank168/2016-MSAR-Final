function output=boxIntersect(bb1, bb2, plotOpt)
% boxOverlay: Intersection of two bounding boxes
%	Usage:
%		boxIntersect(bb, color, width)
%
%	Example:
%		bb1=[3 5 8 8]; bb2=[5 4 9 5];
%		subplot(2,2,1);
%		output=boxIntersect(bb1, bb2, 1);
%		axis image; title(sprintf('output=%d\n', output));
%		bb1=[3 5 8 8]; bb2=[11 10 9 5];
%		subplot(2,2,2);
%		output=boxIntersect(bb1, bb2, 1);
%		axis image; title(sprintf('output=%d\n', output));
%		bb1=[3 5 8 8]; bb2=[11 13 9 5];
%		subplot(2,2,3);
%		output=boxIntersect(bb1, bb2, 1);
%		axis image; title(sprintf('output=%d\n', output));
%		bb1=[3 5 8 8]; bb2=[12 14 9 5];
%		subplot(2,2,4);
%		output=boxIntersect(bb1, bb2, 1);
%		axis image; title(sprintf('output=%d\n', output));

%	Category: Geometry
%	Roger Jang, 20110629

if nargin<1, selfdemo; return; end
if nargin<3, plotOpt=0; end

x1=[bb1(1), bb1(1)+bb1(3), bb1(1)+bb1(3), bb1(1), bb1(1)];
y1=[bb1(2), bb1(2), bb1(2)+bb1(4), bb1(2)+bb1(4), bb1(2)];
x2=[bb2(1), bb2(1)+bb2(3), bb2(1)+bb2(3), bb2(1), bb2(1)];
y2=[bb2(2), bb2(2), bb2(2)+bb2(4), bb2(2)+bb2(4), bb2(2)];
inside1=inpolygon(x1, y1, x2, y2);
inside2=inpolygon(x2, y2, x1, y1);
output=any([inside1(:); inside2(:)]);

if plotOpt
	boxOverlay(bb1, getColor(1), 2);
	boxOverlay(bb2, getColor(2), 2);
	box on; axis ij;
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);