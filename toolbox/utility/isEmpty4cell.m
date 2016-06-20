function output=isEmpty4cell(inputCell)

output=zeros(size(inputCell));
for i=1:length(inputCell);
	if isempty(inputCell{i})
		output(i)=1;
	end
end