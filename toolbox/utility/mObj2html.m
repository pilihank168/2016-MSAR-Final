function mObj2html(mObj, htmlFile, imageFilePath, extraContents)
%mObjParse: Convert mObj into an HTML page.
%
%	Usage:
%		mObj2html(mObj)
%		mObj2html(mObj, htmlFile)
%
%	Description:
%		mObj2html(mFile, htmlFile) takes the given m-File and convert its comments into an HTML page.
%
%	Example:
%		htmlFile=[tempname, '.html'];
%		mFile='mObj2html.m';
%		mObj=mFileParse(mFile);
%		mObj2html(mObj, htmlFile);
%		web(htmlFile);
%
%	See also mFileParse.
%
%	Reference:
%		[1] This is a dummy reference.
%		[2] This is the second dummy reference.

%	Category: Utility
%	Roger Jang, 20100824

if nargin<1, selfdemo; return; end
if nargin<2, htmlFile=[tempname, '.htm']; end
if nargin<3, imageFilePath=[]; end
if nargin<4, extraContents=''; end

if ischar(mObj), mObj=mFileParse(mObj); end

fid=fopen(htmlFile, 'w');
% ====== Command
fprintf(fid, '<html lang="en">\n');
fprintf(fid, '<head>\n');
fprintf(fid, '	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">\n');
fprintf(fid, '	<title>kmeans :: Functions (Machine Learning Toolbox&#8482;)</title>\n');
fprintf(fid, '	<link rel="stylesheet" href="docstyle.css" type="text/css">\n');
fprintf(fid, '	<meta name="generator" content="DocBook XSL Stylesheets V1.52.2">\n');
fprintf(fid, '	<meta name="chunktype" content="refpage">\n');
fprintf(fid, '	<meta name="refentity" content="function:kmeans">\n');
fprintf(fid, '	<meta http-equiv="Content-Script-Type" content="text/javascript">\n');
fprintf(fid, '	<meta name="toctype" content="fcn">\n');
%fprintf(fid, '	<script language="JavaScript" src="docscripts.js"></script>\n');
fprintf(fid, '</head>\n');

fprintf(fid, '<body>\n');
fprintf(fid, '<a name="top_of_page"></a>\n');
fprintf(fid, '<p style="font-size:1px;">&nbsp;</p>\n');
fprintf(fid, '<a name="f3883830"></a>\n');
fprintf(fid, '<a class="indexterm" name="zmw57dd0e73983"></a>\n\n');
% ====== Print command name
[~, mainName]=fileparts(mObj.mFile);
fprintf(fid, '<h1 class="reftitle">%s</h1><!-- SYNCHTO: bq_w_hm.html -->\n\n', mainName);
% ====== Print h1 help (purpose)
fprintf(fid, '<p class="purpose">%s</p>\n\n', mObj.purpose);
% ====== Print usage (synopsis)
fprintf(fid, '<h2>Syntax</h2>\n');
fprintf(fid, '<p class="synopsis"><tt>\n');
for i=1:length(mObj.synopsis)
	if i~=1, fprintf(fid, '<br>'); end
	fprintf(fid, '%s\n', mObj.synopsis{i});
end
fprintf(fid, '</tt></p>\n\n');
% ====== Print description
fprintf(fid, '<h2>Description</h2>\n');
for i=1:length(mObj.description)
	fprintf(fid, '%s\n', mObj.description{i});
end
fprintf(fid, '\n');
% ====== Print reference
if ~isempty(mObj.reference)
	fprintf(fid, '<h2>References</h2>\n');
	for i=1:length(mObj.reference)
		fprintf(fid, '<p>%s\n', mObj.reference{i});
	end
	fprintf(fid, '\n');
end
% ====== Print example
% === Get rid of "common" leading tab
nonTabIndex=ones(1,length(mObj.example));
for i=1:length(mObj.example)
	index=find(mObj.example{i}~=9);
	nonTabIndex(i)=index(1);
end
startIndex=min(nonTabIndex);
for i=1:length(mObj.example)
	mObj.example{i}=mObj.example{i}(startIndex:end);
end
% === Print HTML
if ~isempty(mObj.example)
	fprintf(fid, '<h2>Example</h2>\n');
	fprintf(fid, '<pre class="programlisting">');
	for i=1:length(mObj.example)
		fprintf(fid, '%s\n', mObj.example{i});
	end
	fprintf(fid, '</pre>\n\n');
end
% ====== Print image
if exist(['help/', imageFilePath], 'file')==2
	fprintf(fid, '<center><a target=_blank href="%s"><img width=600 src="%s"></a></center>\n\n', imageFilePath, imageFilePath);
end

% ====== Print "See also"
if ~isempty(mObj.seeAlso)
	fprintf(fid, '<h2>See Also</h2>\n');
	for i=1:length(mObj.seeAlso)
		fprintf(fid, '% <a href="%s.html"><tt>%s</tt></a>', mObj.seeAlso{i}, mObj.seeAlso{i});
		if i~=length(mObj.seeAlso)
			fprintf(fid, ', ');
		else
			fprintf(fid, '.');
		end
	end
	fprintf(fid, '\n\n');
end

fprintf(fid, '%s\n', extraContents);
fprintf(fid, '</body></html>\n');
fclose(fid);

if nargin<2
	web(htmlFile);
%	dos(['start ', htmlFile]);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
