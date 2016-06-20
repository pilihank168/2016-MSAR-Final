function vecPacked=cellVecPlot(cellVec)

if nargin<1, selfdemo; return; end

vecNum=length(cellVec);
len=zeros(vecNum,1);
for i=1:vecNum
	len(i)=length(cellVec{i});
end
maxLen=max(len);

vecPacked=nan*ones(maxLen, vecNum);
for i=1:vecNum
	vecPacked(1:len(i), i)=cellVec{i}(:)';
end

plot(vecPacked);


% ====== Self demo
function selfdemo
cellVec{1}=[1 2 3];
cellVec{2}=[2 3 5 6 4];
cellVec{3}=[4 3 2 6 3 2 3];

output=feval(mfilename, cellVec);