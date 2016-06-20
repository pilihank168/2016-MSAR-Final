ftpSite='neural.cs.nthu.edu.tw';
file='name.txt';
fprintf('Connecting to %s...\n', ftpSite);
host=ftp(ftpSite, 'administrator', 'mir3524nthu');
cd(host, 'jang/temp');
x=dir(host, '/jang');
fprintf('Getting %s...\n', file);
%mget(host, file);	% Download a file
mput(host, 'junk');	% Upload a junk directory
fprintf('Done!\n');