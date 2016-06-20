function output=vecAdd(v1, v2);

len1=length(v1);
len2=length(v2);

if len1>len2
	output=v1+[v2; zeros(len1-len2, 1)];
else
	output=v2+[v1; zeros(len2-len1, 1)];
end