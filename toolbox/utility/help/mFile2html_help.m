%% mFile2html
% Parse an m-file and convert its comments into an HTML page.
%% Syntax
% * 		mFile2html(mFile)
% * 		mFile2html(mFile, htmlFile)
%% Description
% 		mFile2html(mFile, htmlFile) takes the given m-File and convert its comments into an HTML page.
%% References
% # 		[1] This is a dummy reference.
% # 		[2] This is the second dummy reference.
%% Example
%%
%
htmlFile=[tempname, '.html'];
mFile='xTickLabelRotate.m';
mFile2html(mFile, htmlFile);
web(htmlFile);
%% See Also
% <mFileParse_help.html mFileParse>.
