function structCmp(struct1, struct2, index)
%structCmp: Compare fields of two struct vectors by given indices
%
%	Usage:
%		structCmp(struct1, struct2, index)
%
%	Example:
%		(to be added!)

%	Roger Jang, 20110902

if nargin<1, selfdemo; return; end
if nargin<3, index=1; end

fieldName1=fieldnames(struct1);
fieldName2=fieldnames(struct2);
allFieldName=union(fieldName1, fieldName2);

for i=1:length(allFieldName)
	fieldName=allFieldName{i};
	equal=isequal(struct1(1).(fieldName), struct2(1).(fieldName));
	fprintf('fieldName=%s, equal=%d\n', fieldName, equal);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
