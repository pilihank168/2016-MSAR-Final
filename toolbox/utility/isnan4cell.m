function out=isnan4cell(cellArray)

out=logical(zeros(length(cellArray), 1));
for i=1:length(cellArray)
	out(i)=(length(cellArray{i})==1) && isnan(cellArray{i});
end
