function htmlFile=mFile2mFile2html(mFile, outputDir)
%mFile2mFile2html: Convert an .m file into an HTML page via publishing an intermediate .m file.
%
%	Usage:
%		htmlFile=mFile2mFile2html(mFile)
%		htmlFile=mFile2mFile2html(mFile, outputDir)
%
%	Description:
%		htmlFile=mFile2mFile2html(mFile) takes the given m-File and convert its comments into an HTML page.
%
%	Example:
%		htmlFile=mFile2mFile2html('xTickLabelRotate.m');
%		dos(['start ', htmlFile]);
%		%web(htmlFile);
%
%	See also mFileParse.
%
%	Reference:
%		This is a dummy reference.
%		This is the second dummy reference.

%	Category: Utility
%	Roger Jang, 20110629

if nargin<1, selfdemo; return; end
if nargin<2, outputDir=tempdir; end

[parentDir, mainName, extName]=fileparts(mFile);
if outputDir(end)=='/' | outputDir(end)=='\', outputDir(end)=[]; end
tempMFile=[outputDir, '/', mainName, '_help.m'];
htmlFile=[outputDir, '/', mainName, '_help.html'];
fid=fopen(tempMFile, 'w');
% ====== Print command name
[~, mainName]=fileparts(mFile);
fprintf(fid, '%%%% %s\n', mainName);
mObj=mFileParse(mFile);
% ====== Print h1 help (purpose)
fprintf(fid, '%% %s\n', mObj.purpose);
% ====== Print usage (synopsis)
fprintf(fid, '%%%% Syntax\n');
for i=1:length(mObj.synopsis)
	fprintf(fid, '%% * %s\n', mObj.synopsis{i});
end
% ====== Print description
fprintf(fid, '%%%% Description\n');
if length(mObj.description)==1
	fprintf(fid, '%% %s\n', mObj.description{1});
else	% Use (sort of) finite state machine to do the parsing
	fprintf(fid, '%%\n');
	fprintf(fid, '%% <html>\n');
	prevState=0;
	for i=1:length(mObj.description)
	%	fprintf('%s\n', mObj.description{i});
		if regexp(mObj.description{i}, '^%	$')==1	% Separating line with a leading tab only
			currState=0;
		else
			currState=leadingTabCount(mObj.description{i})-2;		% Use leading tab count as the state
		end
		if currState>prevState
			fprintf(fid, '%% '); for jjj=1:currState, fprintf(fid, '\t'); end; fprintf(fid, '<ul>\n');	% Start of current state
		end
		if currState<prevState
			for kkk=1:prevState-currState
				fprintf(fid, '%% '); for jjj=1:prevState-kkk+1, fprintf(fid, '\t'); end; fprintf(fid, '</ul>\n');	% End of previous (several) state
			end
		end
		if currState==0, tag='<p>'; else tag='<li>'; end
	%	if regexp(mObj.description{i}, '^%	$')~=1	% Separating line with a leading tab only
			fprintf(fid, '%% '); for jjj=1:currState, fprintf(fid, '\t'); end; fprintf(fid, '%s%s\n', tag, strrep(mObj.description{i}, char(9), ''));
	%	end
		prevState=currState;
	end
	currState=0;
	for kkk=1:prevState-currState
		fprintf(fid, '%% '); for jjj=1:prevState-kkk+1, fprintf(fid, '\t'); end; fprintf(fid, '</ul>\n');	% End of previous (several) state
	end
	fprintf(fid, '%% </html>\n');
end

% ====== Print reference
if ~isempty(mObj.reference)
	fprintf(fid, '%%%% References\n');
	for i=1:length(mObj.reference)
		fprintf(fid, '%% # %s\n', mObj.reference{i});
	end
end
% ====== Print example
if ~isempty(mObj.exampleItem)
	fprintf(fid, '%%%% Example\n');
	for i=1:length(mObj.exampleItem)
		fprintf(fid, '%%%%\n%%%s\n', mObj.exampleItem(i).info);
		for j=1:length(mObj.exampleItem(i).code)
			fprintf(fid, '%s\n', mObj.exampleItem(i).code{j});
		end
	end
end
% ====== Print "See also"
if ~isempty(mObj.seeAlso)
	fprintf(fid, '%%%% See Also\n');
	for i=1:length(mObj.seeAlso)
		fprintf(fid, '%% <%s_help.html %s>', mObj.seeAlso{i}, mObj.seeAlso{i});
		if i~=length(mObj.seeAlso)
			fprintf(fid, ',\n');
		else
			fprintf(fid, '.\n');
		end
	end
end
fclose(fid);
addpath(outputDir);
[~, mainName]=fileparts(tempMFile);
helpFile=publish(mainName, struct('format', 'html', 'outputDir', outputDir));
if nargout==0, dos(['start ', helpFile]); end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
