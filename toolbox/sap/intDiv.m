function out=intDiv(x, y)
% ���� C ����ư��k�A�øg�ѥ|�ˤ��J�ӫO�d��T��

if x==0,
	out=0;
elseif x>0
	out=fix((x+fix(y/2))/y);
else
	out=fix((x-fix(y/2))/y);
end