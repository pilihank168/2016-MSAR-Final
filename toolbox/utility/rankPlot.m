function rrVec=rankPlot(rankVec, n)
% rankPlot: Top-n rank plot
%	Usage: recogRateVec = rankPlot(rankVec, n)

%	Roger Jang, 20081118

if nargin<1, selfdemo; return; end
if nargin<2, n=10; end

rankLen=length(rankVec);
rankVec(~isfinite(rankVec))=[];
rankIndex=1:n;
rankVec(rankVec>n)=[];
rankCount=hist(rankVec, rankIndex);
cumulatedRankCount=cumsum(rankCount);
subplot(2,1,1);
rrVec=cumulatedRankCount/rankLen*100;
plot(rankIndex, rrVec, 'o-'); grid on
set(gca, 'ylim', [0 100]);
xlabel('Rank'); ylabel('Cumulated percentage (%)'); title('Top-n recognition rates');
subplot(2,1,2);
stem(rankIndex, rankCount); grid on
xlabel('Rank'); ylabel('Count'); title('Rank counts');

% ====== Self demo
function selfdemo
rankVec=[1 1 1 3 2 1 8 1 inf 1 2 1 5 1 1 inf 1 1 3 1 1 12 1 1 1 inf 1 1 1 1 1 inf 15 14 1 1 1 1 1 2 1 23 1 1 7 1 7 8 1 1 1 9 1 1 4 5 1];
n=10;
rrVec=rankPlot(rankVec, n);