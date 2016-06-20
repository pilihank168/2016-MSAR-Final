function out=maxStrLen(strCellArray)

strLen=zeros(length(strCellArray), 1);
for i=1:length(strCellArray)
	strLen(i)=length(strCellArray{i});
end
out=max(strLen);
