%% xTickLabelRotate
% Rotate the labels of xtick
%% Syntax
% * 		xTickLabelRotate(degree)
% * 		xTickLabelRotate(degree, fontSize)
% * 		xTickLabelRotate(degree, fontSize, horizontalAlign)
%% Description
%
% <html>
% <p>xTickLabelRotate(degree) rotates the tick label of x-axis to the given degree.
% <p>xTickLabelRotate(degree, fontSize) uses the given font size.
% <p>xTickLabelRotate(degree, fontSize, horizontalAlign) use the given option for horizontal alignment
% </html>
%% Example
%%
%
xTickLabel={'Rock', 'Jazz', 'Classic', 'Country', 'Metal', '\alpha', '\pi', '\beta'};
subplot(2,1,1);
plot(1:10, 1:10);
xTickLabelRename(xTickLabel);
xTickLabelRotate(330, 10, 'left');
subplot(2,1,2);
plot(1:10, 1:10);
xTickLabelRename(xTickLabel);
xTickLabelRotate(60, 10, 'right');
%% See Also
% <xTickLabelRename_help.html xTickLabelRename>.
