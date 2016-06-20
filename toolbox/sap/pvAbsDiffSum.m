function absDiffSum=pvAbsDiffSum(pv)
% pvAbsDiffSum: Sum of absolute differences of neighboring pitches
%
%	Usage:
%		absDiffSum=pvAbsDiffSum(pv)

%	Roger Jang, 20091001

segment=segmentFind(pv);
absDiffSum=0;
for i=1:length(segment)
	absDiffSum=absDiffSum+sum(abs(diff(pv(segment(i).begin:segment(i).end))));
end
