function myCopyFile(source, target)

source=strrep(source, '/', '\');
target=strrep(target, '/', '\');
cmd = sprintf('copy /y "%s" "%s"', source, target);
[status, result]=dos(cmd);	% Avoid stdout on screen

% Why can i use copyfile(source, target, 'f') instead???