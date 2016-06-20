%% lookupTableWrite
% Write a lookup table to a file
%% Syntax
% *        lookupTableWrite(tableFunName, tableInvFunName, xRange, xySf, tableName, plotOpt)
%% Description
%
% <html>
% <p>所給定的查表函數必須是嚴格遞增(reverse=0)或是嚴格遞減(reverse=1)。
% <p>所產生的 inc 檔案會被用在 tableLookupByRangeSearch in utility.cpp
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
