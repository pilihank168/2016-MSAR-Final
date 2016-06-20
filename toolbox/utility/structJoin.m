function struct1=structJoin(struct1, struct2, field, mode)
%structJoin: Join two struct vectors by a given field
%
%	Usage:
%		outStruct=structFind(struct1, struct2, field, mode)
%
%	Example:
%		struct1(1).x='xValue1'; struct1(1).y='a';
%		struct1(2).x='xValue2'; struct1(2).y='b';
%		struct1(3).x='xValue3'; struct1(3).y='c';
%		struct2(1).z='zValue1'; struct2(1).y='a';
%		struct2(2).z='zValue2'; struct2(2).y='b';
%		struct2(3).z='zValue3'; struct2(3).y='d';
%		field='y';
%		outStruct=structJoin(struct1, struct2, field);
%		disp(outStruct(1));
%		disp(outStruct(2));

%	Roger Jang, 20100414

if nargin<1, selfdemo; return; end
if nargin<4, mode='inner'; end		% Other join mode to be added

cmd=['{struct1.', field, '}'];
allFieldValue1=eval(cmd);
allField2=fieldnames(struct2);
index=find(strcmp(allField2, field));
allField2(index)=[];
keepIndex=[];
for i=1:length(struct2)
	index=find(strcmp(struct2(i).(field), allFieldValue1));
	if ~isempty(index), keepIndex=[keepIndex, index]; end
	% Copy fields in struct2 to struct1
	for j=1:length(index)
		for k=1:length(allField2)
			struct1(index(j)).(allField2{k})=struct2(i).(allField2{k});
		end
	end
end
struct1=struct1(keepIndex);	% For inner join only

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
