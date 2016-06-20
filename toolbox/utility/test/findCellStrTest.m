% 測試 findCellStr.dll 的用法

C = {'hello', '大學', 'yes', 'no', '清華', 'goodbye', '清華', 'hello'}';

pattern = '清華';
index = findcellstr(C, pattern);
fprintf('The index of "%s" in "%s" is %s.\n', pattern, cell2str(C), mat2str(index));

C = sortrows(C);
index = findcellstr(C, pattern, 1);
fprintf('The index of "%s" in "%s" is %s.\n', pattern, cell2str(C), mat2str(index));