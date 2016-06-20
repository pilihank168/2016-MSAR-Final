function count=leadingTabCount(string)

for i=1:length(string)
	if string(i)~=9
		break;
	end
end
count=i-1;