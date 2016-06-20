max=250;
income=1:max;
out=zeros(max, 1);
for i=1:max
	if i<=37
		out(i)=i*6/100;
	elseif i<=99
		out(i)=i*13/100-2.59;
	elseif i<=198
		out(i)=i*21/100-10.51;
	elseif i<=372
		out(i)=i*30/100-28.33;
	else
		out(i)=i*40/100-65.53;
	end
end

plot(income, out, '.-');
