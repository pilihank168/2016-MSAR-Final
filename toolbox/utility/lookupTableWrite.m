function lookupTableWrite(tableFunName, tableInvFunName, xRange, xySf, tableName, plotOpt)
%lookupTableWrite: Write a lookup table to a file
%
%	Usage:
%       lookupTableWrite(tableFunName, tableInvFunName, xRange, xySf, tableName, plotOpt)
%
%	Description:
%		�ҵ��w���d���ƥ����O�Y�滼�W(reverse=0)�άO�Y�滼��(reverse=1)�C
%		�Ҳ��ͪ� inc �ɮ׷|�Q�Φb tableLookupByRangeSearch in utility.cpp
%
%	Example:
%		% === To generate the table for mixLogSum:
%		tableFunName='mixLogSum';
%		tableInvFunName='mixLogSumInv';
%		xRange=[0, 25];
%		xySf=[2^15, 2^15];
%		tableName='mixLogSumTable';
%		plotOpt=1;
%		lookupTableWrite(tableFunName, tableInvFunName, xRange, xySf, tableName, plotOpt);
%		% === To generate the table for log:
%		tableFunName='log';
%		tableInvFunName='exp';
%		xRange=[0.1, 5];
%		xySf=[2^10, 2^10];
%		tableName='logTable';
%		plotOpt=1;
%		lookupTableWrite(tableFunName, tableInvFunName, xRange, xySf, tableName, plotOpt);

%	Roger Jang, 20070811

if nargin<1, selfdemo; return; end

%tableName=upper(tableName);

% ====== Define the constants of expTable
xMinOrig=xRange(1); xMaxOrig=xRange(2);
xSf=xySf(1); ySf=xySf(2);		% Scaling factors on x and y
x=[xMinOrig, xMaxOrig];
table=feval(tableFunName, x);		% �u�O�Ψӧ� yMin �M yMax
yMin=round(ySf*min(table)); yMax=round(ySf*max(table));
xMin=round(xMinOrig*xSf); xMax=round(xMaxOrig*xSf);
% �ϹB��H��^x����
tableInt=yMin:yMax;
x2=feval(tableInvFunName, (tableInt+0.5)/ySf); 	% x ���k�ɭ�: x in [x(i-1), x(i)] ===> log(1+exp(x)) = y(i)
x2=x2(1:end-1);					% �R���̫�@�ӡC�p�G table �����׬O n�Ax �����״N�O n-1
xInt=round(x2*xSf);
tableSize=length(xInt);
if plotOpt
	plot(xInt, (tableInt(1:end-1)+tableInt(2:end))/2, '.-');
end

% ���F�i�� binary range search, xInt �����O�Ѥp�ƨ�j
reverse=0;
if xInt(1)>xInt(end)
	xInt=fliplr(xInt);
	reverse=1;
end

% ====== Write table related constants
file=[tableName, 'Var.h'];
fid=fopen(file, 'w');
fprintf(fid, '#ifndef %s_H\n', tableName);
fprintf(fid, '#define %s_H\n', tableName);
fprintf(fid, '\n');
fprintf(fid, '#define %s_SIZE %d\n', tableName, tableSize);
fprintf(fid, '#define %s_X_SF %d\n', tableName, xSf);
fprintf(fid, '#define %s_Y_SF %d\n', tableName, ySf);
fprintf(fid, '#define %s_X_MIN %d\n', tableName, xMin);
fprintf(fid, '#define %s_X_MAX %d\n', tableName, xMax);
fprintf(fid, '#define %s_X_MIN_ORIG %f\n', tableName, xMinOrig);
fprintf(fid, '#define %s_X_MAX_ORIG %f\n', tableName, xMaxOrig);
fprintf(fid, '#define %s_Y_MIN %d\n', tableName, yMin);
fprintf(fid, '#define %s_Y_MAX %d\n', tableName, yMax);
fprintf(fid, '#define %s_REVERSE %d\n', tableName, reverse);
fprintf(fid, '\n');
fprintf(fid, '#endif\n');
fclose(fid);
fprintf('Saved %s\n', file);

% ====== Write table entries
file=[tableName, '.inc'];
fid=fopen(file, 'w');
fprintf(fid, 'int %s[%d]={%d', tableName, tableSize, xInt(1));
for i=2:tableSize
	fprintf(fid, ', %d', xInt(i));
end
fprintf(fid, '};\n');
fclose(fid);
fprintf('Saved %s\n', file);

return

% ====== Write the txt content of table
file='tableInt.txt';
fid=fopen(file, 'w');
fprintf(fid, '%d\n', xInt);
fclose(fid);
fprintf('Saved %s\n', file);

% ====== Write the bin content of table
file='tableInt.bin';
fid=fopen(file, 'wb');
fwrite(fid, xInt, 'integer*4');
fclose(fid);
fprintf('Saved %s\n', file);

% ====== Self demo
function selfdemo
tableFunName='mixLogSum';
tableInvFunName='mixLogSumInv';
xRange=[0, 25];
xySf=[2^15, 2^15];
tableName='mixLogSumTable';
plotOpt=1;
%feval(mfilename, tableFunName, tableInvFunName, xRange, xySf, tableName, plotOpt);
lookupTableWrite(tableFunName, tableInvFunName, xRange, xySf, tableName, plotOpt);