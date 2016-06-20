% Test the sync. between findSegment.m and segmentFindMex.dll

caseNum=100;
errorFound=0;
for i=1:caseNum
	fprintf('i=%d/%d\n', i, caseNum);
%	x=randsrc(1, 1000);
	x=randn(1, 1000);
	segment1=findSegment(x);
	segment2=segmentFindMex(x);
	if ~isequal(segment1, segment2)
		fprintf('Error!\n');
		errorFound=1;
		break;
	end
end
if errorFound==0
	fprintf('Test passed! No error found!\n');
end

return



x = [1 0 1 0 1 1 0 0 1 0];
fprintf('x = %s\n', mat2str(x));
segment1=findSegment(x);
for i=1:length(segment1)
	fprintf('Segment %d: %d~%d\n', i, segment1(i).begin, segment1(i).end);
end


fprintf('Result of segmentFindMex.dll:\n');
segment2=segmentFindMex(x);
for i=1:length(segment2)
	fprintf('Segment %d: %d~%d\n', i, segment2(i).begin, segment2(i).end);
end

return

