%% xTickLabelRename
% Rename tick labels on x axis sequentially
%% Syntax
%% Description
%
% <html>
% </html>
%% Example
%%
%
vecToBeLabeled=3:3:20;
n=length(vecToBeLabeled);
subplot(2,1,1);
plot(1:n, 1:n);
xTickLabelRename(vecToBeLabeled);
subplot(2,1,2);
vecToBeLabeled={'\pi', '2^5', 'e^{-3}', '\alpha'};
n=length(vecToBeLabeled);
subplot(2,1,2);
plot(1:n, 1:n);
xTickLabelRename(vecToBeLabeled);
%% See Also
% <xTickLabelRotate_help.html xTickLabelRotate>.
