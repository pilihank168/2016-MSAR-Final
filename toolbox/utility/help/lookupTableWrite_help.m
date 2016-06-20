%% lookupTableWrite
% Write a lookup table to a file
%% Syntax
% *        lookupTableWrite(tableFunName, tableInvFunName, xRange, xySf, tableName, plotOpt)
%% Description
%
% <html>
% <p>�ҵ��w���d���ƥ����O�Y�滼�W(reverse=0)�άO�Y�滼��(reverse=1)�C
% <p>�Ҳ��ͪ� inc �ɮ׷|�Q�Φb tableLookupByRangeSearch in utility.cpp
% </html>
%% Example
%%
% To generate the table for mixLogSum:
tableFunName='mixLogSum';
tableInvFunName='mixLogSumInv';
xRange=[0, 25];
xySf=[2^15, 2^15];
tableName='mixLogSumTable';
plotOpt=1;
lookupTableWrite(tableFunName, tableInvFunName, xRange, xySf, tableName, plotOpt);
%%
% To generate the table for log:
tableFunName='log';
tableInvFunName='exp';
xRange=[0.1, 5];
xySf=[2^10, 2^10];
tableName='logTable';
plotOpt=1;
lookupTableWrite(tableFunName, tableInvFunName, xRange, xySf, tableName, plotOpt);
