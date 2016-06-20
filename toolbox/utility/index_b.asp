<%@language=JScript%>
<!== Roger Jang, 20041120 -->

<%
function getMFileUsage(fileName){
	var i;
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var fid=fso.OpenTextFile(fileName, 1);
	var contents=fid.ReadAll();
	fid.Close();
	var lines=contents.split("\n");
	var output=new Object();

	// ====== Check if a function
	pattern=/^\s*function\s/i;
	line=lines[0];
	output.isFunction=false;
	if (line.match(pattern) != null)
		output.isFunction=true;

	// ====== Get H1 help
	pattern=/^%\s*.*: (.*)/i;
	pattern=/^%\s*(.*)/i;
	output.h1="";
	for (i=0; i<lines.length; i++)
		if (lines[i].match(pattern) != null){
			output.h1=RegExp.$1;
			break;
		}
	
	// ====== Usage line
	pattern=/^%\s*Usage:\s*(.*)/i;
	output.usage="";
	startLine=-1;
	for (i=0; i<lines.length; i++)
		if (lines[i].match(pattern) != null){
			output.usage=RegExp.$1;
			startLine=i;
			break;
		}

	// ====== Argument documentation
	pattern=/^%\s*(.*)/i;
	output.argumentDoc="";
	if (startLine>=0)
		for (i=startLine+1; i<lines.length; i++)
			if ((lines[i].match(pattern) != null) && (RegExp.$1 != ""))
				output.argumentDoc = output.argumentDoc + "\\n" + RegExp.$1;
			else
				break;

	// ====== Return the final output
	return(output);
}
%>

<%title="Melody Recognition Toolbox"%>
<html>
<head>
	<title><%=title%></title>
	<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=big5">
	<meta HTTP-EQUIV="Expires" CONTENT="0">
</head>

<body>
<h2 align=center><%=title%></h2>
<h3 align=center><a target=_blank href="/jang">Roger Jang</a></h3>
<hr>

<!== 簡要說明 -->
<h3><img src="/jang/graphics/dots/redball.gif">Introduction</h3>
<blockquote>
This toolbox provide common utility functions for some of my other toolboxes:
</ul>
<li><a href="../audio">Audio Toolbox</a>
<li><a href="../dcpr">DCPR Toolbox</a>
<li><a href="../asr">ASR Toolbox</a>
</ul>
<p>
If you want to download the toolbox, please click <a href="..\utility.rar">here</a>.
</blockquote>

<!== 列出函數 -->
<%
functionList=new Array();
i=0;
functionList[i++]="asciiRead.m";
functionList[i++]="asciiWrite.m";
functionList[i++]="elementCount.m";
functionList[i++]="elementDuplicate.m";
functionList[i++]="elementMerge.m";
functionList[i++]="findCell.m";
functionList[i++]="findInRange.m";
functionList[i++]="findRecord.m";
functionList[i++]="findSegment.m";
%>
<h3><img src="/jang/graphics/dots/redball.gif">List of Important Functions</h3>
(<a target=_blank href="index_old.asp">Old page</a> that lists more)
<table border=1 align=center>
<tr>
<th>Functions<th>H1 Help<th>Usage<th>Description<th>Size
<%
fso = new ActiveXObject("Scripting.FileSystemObject");
fullPath = Server.MapPath(".");
for (i=0; i<functionList.length; i++){
	fileName=fullPath + "/" + functionList[i];
	ext=fso.GetExtensionName(fileName);
	if ((ext=="m") || (ext=="M")){
		f = fso.GetFile(fileName);
		out=getMFileUsage(fileName);
		if (out.isFunction){
			Response.write("\n<tr>\n");
			Response.write("<td><a target=_blank href=\"" + f.Name + "\">" + f.Name + "</a></td>");
			Response.write("<td>" + out.h1 + "&nbsp;</td>");
			doc=out.argumentDoc;
			doc=doc.replace(/"/g, "\\\"");		// 將字串原有的 " 代換成 \"
			doc=doc.replace(/'/g, "\\\'");		// 將字串原有的 ' 代換成 \'
		//	if (doc!="")
		//		Response.write("<td><a href='javascript:alert(\"" + doc + "\")'>" + out.usage + "</a>&nbsp;</td>");
		//	else
		//		Response.write("<td>" + out.usage + "&nbsp;</td>");
			Response.Write("<td>" + out.usage + "&nbsp;</td>");
			Response.write("<td align=right>\n");
			Response.write(doc);
			Response.write("&nbsp</td>");
			Response.write("<td align=right>" + f.Size + "</td>");
		}
	}
}
%>
</table>

<!== 列出底稿 -->
<%
scriptList=new Array();
i=0;
scriptList[i++]="goFtp.m";
scriptList[i++]="goWavFileComp.m";
scriptList[i++]="goWriteOutputFile.m";
%>
<h3><img src="/jang/graphics/dots/redball.gif">List of Scripts</h3>
<table border=1 align=center>
<tr>
<th>File Names<th>Help<th>Size
<%
for (i=0; i<scriptList.length; i++){
	fileName=fullPath + "/" + scriptList[i];
	ext=fso.GetExtensionName(fileName);
	if ((ext=="m") || (ext=="M")){
		f = fso.GetFile(fileName);
		out=getMFileUsage(fileName);
		if (!out.isFunction){
			Response.write("\n<tr>\n");
			Response.write("<td><a href=\"" + f.Name + "\">" + f.Name + "</a></td>");
			Response.write("<td>" + out.h1 + "&nbsp;</td>");
			Response.write("<td align=right>" + f.Size + "</td>");
		}
	}
}
%>
</table>

<hr>
<script language="JavaScript">
document.write("Last updated on " + document.lastModified + ".")
</script>

</body>
</html>
