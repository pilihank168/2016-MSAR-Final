function [out, originalFieldName]=xlsFile2struct(xlsFile, sheet, fieldName)
% xlsRead2struct: Read an xls file and return a structure array
%
%	Usage:
%		output=xlsRead2struct(xlsFile, sheet)
%		output=xlsRead2struct(xlsFile, sheet, fieldName)
%		[output, originalFieldName]=xlsRead2struct(...)
%
%	Example:
%		xlsFile='test.xls';
%		sheet='Sheet01';
%		fieldName={'myId', 'myName'};
%		[output, originalFieldName]=xlsFile2struct(xlsFile, sheet, fieldName);

%	Roger Jang, 20130401, 20140916

if nargin<1; selfdemo; return; end

[num, str, raw]=xlsread(xlsFile, sheet);
originalFieldName=raw(1,:);

if nargin<3
	fieldName=originalFieldName;
	count=1;
	for i=1:length(fieldName)
		if isnan(fieldName{i}) | isempty(fieldName{i})
			fieldName{i}=sprintf('emptyFieldName%.2d', count); count=count+1;
		end
		fieldName{i}(fieldName{i}=='''')=[];	% get rid of single quotes
		fieldName{i}(fieldName{i}==' ')=[];	% get rid of spaces
		fieldName{i}(fieldName{i}=='(')=[];	% get rid of "("
		fieldName{i}(fieldName{i}==')')=[];	% get rid of ")"
	end
end
raw(1,:)=[];
[m, n]=size(raw);
n=min(n, length(fieldName));	% If fieldName is too short, only take the necessary field values
for i=1:m
	for j=1:n
		out(i).(fieldName{j})=raw{i,j};
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);