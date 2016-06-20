function distMat=distPoint2circle(points, circles)
% distPoint2circle: Distance between a set of points to a set of circles
%
%	Usage:
%		distMat=distPoint2circle(points, circles)
%
%	Description:
%		distMat=distPoint2circle(points, circles) returns the distance matrix between a set of points and a set of circles
%			points: A set of points, with each column being a point
%			circles: A set of circles, with each column being a circle (center and radius)
%			distMat: The returned distance matrix
%
%	Example:
%		points=[1 2; 3 4; 2 5; 3 6]';
%		circles=[1 3 4; 2 5 3; 2 6 5]';
%		distMat=distPoint2circle(points, circles);
%		disp('points='); disp(points);
%		disp('circles='); disp(circles);
%		disp('distMat='); disp(distMat);

%	Roger Jang, 20141114

if nargin<1, selfdemo; return; end

[dim, pointNum]=size(points);
dist2center=distPairwise(points, circles(1:dim, :));
radiusVec=circles(end, :);
distMat=abs(dist2center-matrixDuplicate(radiusVec, pointNum, 1));

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);