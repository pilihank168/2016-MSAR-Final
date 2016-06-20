function distMat=boxSetDistance(objSet1, objSet2, plotOpt)
% boxDistance: Distance between two bounding box
%	Usage:
%		distMat=boxSetDistance(objSet1, objSet2, plotOpt)
%
%	Example:
%		objSet1(1).BoundingBox=[3 5 6 4];
%		objSet1(2).BoundingBox=[5 4 9 3];
%		objSet2(1).BoundingBox=[10 10 4 5];
%		objSet2(2).BoundingBox=[8 13 5 4];
%		objSet2(3).BoundingBox=[12 14 9 5];
%		distMat=boxSetDistance(objSet1, objSet2, 1);
%		axis image; title(sprintf('distance=%s\n', mat2str(distMat)));
%
%	See also boxDistance.

%	Category: Image feature extraction
%	Roger Jang, 20120628

if nargin<1, selfdemo; return; end
if nargin<3, plotOpt=0; end

m=length(objSet1);
n=length(objSet2);
distMat=zeros(m, n);

for i=1:m
	for j=1:n
		distMat(i,j)=boxDistance(objSet1(i).BoundingBox, objSet2(j).BoundingBox);
	end
end

if plotOpt
	for i=1:m
		boxOverlay(objSet1(i).BoundingBox, getColor(i), 2, int2str(i));
	end
	for i=1:n
		boxOverlay(objSet2(i).BoundingBox, getColorLight(i), 2, int2str(i));
	end
	box on;
	axis ij;
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);