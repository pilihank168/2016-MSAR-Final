function index = structFind(record, field, fieldValue, exactMatch)
%structFind: Find a record according to a field's value
%
%	Usage: index = structFind(record, field, fieldValue, exactMatch)
%		index: Index of matched records
%		record: Record (structure array) to be matched
%		field: Which field to be matched
%		fieldValue: Value to be matched
%		exactMatch: 1 for exact match, 0 for substring match
%
%	Example:
%		table=tableRead('table01.txt', 1, {'id', 'word', 'count'});
%		index1=structFind(table, 'word', 'th');
%		fprintf('index1=%s\n', mat2str(index1));
%		index2=structFind(table, 'word', 'white')
%		fprintf('index2=%s\n', mat2str(index2));
%		index3=structFind(table, 'word', 'th', 0)
%		fprintf('index3=%s\n', mat2str(index3));

%	Roger Jang, 20020406, 20071009

if nargin<1, selfdemo; return; end
if nargin<4, exactMatch=1; end

% ====== Deal with a single field
if isstr(field), field={field}; end
if isstr(fieldValue)|isnumeric(fieldValue), fieldValue={fieldValue}; end

%cmd=['{record.', field, '}'];
%allFieldValue = eval(cmd);
if length(field)==1			% Single criterion
	if isstr(fieldValue{1})		% string data
		allFieldValue={record.(field{1})};
		if exactMatch==1
			index=strmatch(upper(fieldValue{1}), upper(allFieldValue), 'exact');
		else
			for i=1:length(allFieldValue)
				index(i)=~isempty(findstr(upper(fieldValue{1}), upper(allFieldValue{i})));
			end
			index=find(index);
		end
	elseif isnumeric(fieldValue{1})		% numeric data
		allFieldValue=[record.(field{1})];
		index=find(allFieldValue==fieldValue{1});
	else
		error('Unknown data type!');
	end
else		% Multiple criteria
	itemNum=length(field);
	index=structFind(record, field(1), fieldValue(1), exactMatch);
	for i=2:itemNum
		index=intersect(index, structFind(record, field(i), fieldValue(i), exactMatch));
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
