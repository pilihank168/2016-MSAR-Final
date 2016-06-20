%% axisLimitX
% Adjust all subplots in a plot windows to have the same limits
%% Syntax
%% Description
%
% <html>
% </html>
%% Example
%%
%
subplot(211); plot(rand(10));
subplot(212); plot(10*rand(3));
axisLimitSame(gcf);
