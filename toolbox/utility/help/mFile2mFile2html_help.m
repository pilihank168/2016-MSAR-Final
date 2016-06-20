%% mFile2mFile2html
% Convert an .m file into an HTML page via publishing an intermediate .m file.
%% Syntax
% * 		htmlFile=mFile2mFile2html(mFile)
% * 		htmlFile=mFile2mFile2html(mFile, outputDir)
%% Description
% 		htmlFile=mFile2mFile2html(mFile) takes the given m-File and convert its comments into an HTML page.
%% References
% # 		This is a dummy reference.
% # 		This is the second dummy reference.
%% Example
%%
%
htmlFile=mFile2mFile2html('xTickLabelRotate.m');
dos(['start ', htmlFile]);
%web(htmlFile);
%% See Also
% <mFileParse_help.html mFileParse>.
