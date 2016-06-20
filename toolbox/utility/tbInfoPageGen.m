function tbInfoPageGen
% tbInfoPageGen: Generate the info.xml for a toolbox
%
%	Usage:
%		tbInfoPageGen

inputFile='info_template.xml';
outputFile='info.xml';
fprintf('Reading %s...\n', inputFile);
contents=textread(inputFile,'%s','delimiter','\n','whitespace','');

tbInfo=toolboxInfo;
items=split(tbInfo.name, ' ');
contents=strrep(contents, 'TOOLBOX_NAME_ONLY', join(items(1:end-1), ' '));
contents=strrep(contents, 'TOOLBOX_NAME', tbInfo.name);
contents=strrep(contents, 'TOOLBOX_WEBSITE', tbInfo.website);
contents=strrep(contents, 'TOOLBOX_REPRESENTATIVE_FUNCTION', tbInfo.representativeFcn);

fprintf('Reading %s...\n', outputFile);
fileWrite(contents, outputFile);
