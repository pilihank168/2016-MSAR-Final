function table=dbQuery(dsn, sql)
% dbQuery: Database query via a given SQL
%	Usage: table=dbQuery(dsn, sql)
%
%	For example:
%		dsn = 'speechDb';
%		sql = 'select * from paTable order by yinMa';
%		table = dbQuery(dsn, sql);

%	Roger Jang, 20010203, 20080120

logintimeout(5);
conn = database(dsn, '', '');
%ping(conn)
cursorA = exec(conn, sql);
cursorA = fetch(cursorA);
table = cursorA.data;
temp = columnnames(cursorA);
eval(['fieldNames = {', temp, '}'';']); 
table = cell2struct(table, fieldNames, 2);
close(conn);