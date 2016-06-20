function normalized=highSchoolNormalize(schoolName)
% highSchoolNormalize: Normalize highschool name

normalized=schoolName;
if ~isempty(strfind(schoolName, '�ذ�')), normalized='�ذꤤ��'; end
if ~isempty(strfind(schoolName, '����')), normalized='��������'; end
if ~isempty(strfind(schoolName, '�O�n�@��')), normalized='�x�n�@��'; end
if ~isempty(strfind(schoolName, '�O�n�k�l���Ť���')), normalized='�x�n�k��'; end
if ~isempty(strfind(schoolName, '�_��')), normalized='�_������'; end
if ~isempty(strfind(schoolName, '�v�j����')), normalized='�v�j����'; end
if ~isempty(strfind(schoolName, '�v�d�j�Ǫ��ݰ��Ť���')), normalized='�v�j����'; end
if ~isempty(strfind(schoolName, '�������Ť���')), normalized='��������'; end
if ~isempty(strfind(schoolName, '��������')), normalized='��������'; end
if ~isempty(strfind(schoolName, '�����k�l���Ť���')), normalized='�����k��'; end
if ~isempty(strfind(schoolName, '�����k��')), normalized='�����k��'; end
if ~isempty(strfind(schoolName, '���\����')), normalized='���\����'; end
if ~isempty(strfind(schoolName, '���D')), normalized='���D����'; end
if ~isempty(strfind(schoolName, '�O������')), normalized='�O������'; end
if ~isempty(strfind(schoolName, '�Ĥ@�k�l���Ť���')), normalized='�_�@�k��'; end
if ~isempty(strfind(schoolName, '�Ĥ@�k��')), normalized='�_�@�k��'; end
if ~isempty(strfind(schoolName, '�O���@��')), normalized='�x���@��'; end
if ~isempty(strfind(schoolName, '�O���Ĥ@���Ť���')), normalized='�x���@��'; end
if ~isempty(strfind(schoolName, '�O���k�l���Ť���')), normalized='�x���k��'; end
if ~isempty(strfind(schoolName, '�Z��')), normalized='�Z������'; end
if ~isempty(strfind(schoolName, '��Ϲ���')), normalized='���礤��'; end
if ~isempty(strfind(schoolName, '���հ��Ť���')), normalized='���հ���'; end
if ~isempty(strfind(schoolName, '���հ���')), normalized='���հ���'; end
if ~isempty(strfind(schoolName, '���s�k�l���Ť���')), normalized='���s�k��'; end
if ~isempty(strfind(schoolName, '��۰��Ť���')), normalized='��۰���'; end
if ~isempty(strfind(schoolName, '�y�����Ť���')), normalized='�y������'; end
if ~isempty(strfind(schoolName, '���W����')), normalized='���W����'; end
if ~isempty(strfind(schoolName, '�ùD���Ť���')), normalized='�ùD����'; end
if ~isempty(strfind(schoolName, '���ư��Ť���')), normalized='���Ƥ���'; end
if ~isempty(strfind(schoolName, '���ư���')), normalized='���Ƥ���'; end
if ~isempty(strfind(schoolName, '�s�˰���')), normalized='�s�ˤ���'; end
if ~isempty(strfind(schoolName, '�s�ˤk�l���Ť���')), normalized='�s�ˤk��'; end
if ~isempty(strfind(schoolName, '�s�ˤk��')), normalized='�s�ˤk��'; end
if ~isempty(strfind(schoolName, '�F�s����')), normalized='�F�s����'; end
if ~isempty(strfind(schoolName, '���߰���')), normalized='���߰���'; end
if ~isempty(strfind(schoolName, '�y������')), normalized='�y������'; end
if ~isempty(strfind(schoolName, '��Ͱ���')), normalized='��Ͱ���'; end
if ~isempty(strfind(schoolName, '��s����')), normalized='��s����'; end
if ~isempty(strfind(schoolName, '�ùD����')), normalized='�ùD����'; end
if ~isempty(strfind(schoolName, '��ذ���')), normalized='��ذ���'; end
return


if ~isempty(strfind(schoolName, '�ذ�')), normalized='�O�_���߫ذ갪�Ť���'; end
if ~isempty(strfind(schoolName, '����')), normalized='��ߪ������Ť���'; end
if ~isempty(strfind(schoolName, '��������')), normalized='�������߰������Ť���'; end
if ~isempty(strfind(schoolName, '�x�n�@��')), normalized='��߻O�n�Ĥ@���Ť���'; end
if ~isempty(strfind(schoolName, '�O�n�@��')), normalized='��߻O�n�Ĥ@���Ť���'; end
if ~isempty(strfind(schoolName, '�_��')), normalized='��鿤�p�ߴ_������'; end
if ~isempty(strfind(schoolName, '�v�j����')), normalized='��߻O�W�v�d�j�Ǫ��ݰ��Ť���'; end
if ~isempty(strfind(schoolName, '�v�d�j�Ǫ��ݰ��Ť���')), normalized='��߻O�W�v�d�j�Ǫ��ݰ��Ť���'; end
if ~isempty(strfind(schoolName, '���\����')), normalized='�O�_���ߦ��\���Ť���'; end
if ~isempty(strfind(schoolName, '���D')), normalized='�p�ߩ��D���Ť���'; end
if ~isempty(strfind(schoolName, '�_�@�k��')), normalized='�O�_���߲Ĥ@�k�l���Ť���'; end
if ~isempty(strfind(schoolName, '�x���@��')), normalized='��߻O���Ĥ@���Ť���'; end
if ~isempty(strfind(schoolName, '�Z��')), normalized='��ߪZ�����Ť���'; end
if ~isempty(strfind(schoolName, '��Ϲ���')), normalized='��߬�Ǥu�~��Ϲ��簪�Ť���'; end
if ~isempty(strfind(schoolName, '���հ��Ť���')), normalized='�p�����հ��Ť���'; end
if ~isempty(strfind(schoolName, '���s�k�l���Ť���')), normalized='�x�_���ߤ��s�k�l���Ť���'; end
if ~isempty(strfind(schoolName, '�Q�s����')), normalized='�O�_���ߪQ�s����'; end
if ~isempty(strfind(schoolName, '�s�ˤk��')), normalized='��߷s�ˤk�l���Ť���'; end
if ~isempty(strfind(schoolName, '��������')), normalized='�p�ߩ������Ť���'; end
if ~isempty(strfind(schoolName, '�j�P����')), normalized='�x�_���ߤj�P���Ť���'; end
if ~isempty(strfind(schoolName, '�Ĥ@�k�l���Ť���')), normalized='�O�_���߲Ĥ@�k�l���Ť���'; end
if ~isempty(strfind(schoolName, '�Ÿq����')), normalized='��߹Ÿq���Ť���'; end
if ~isempty(strfind(schoolName, '��ذ���')), normalized='��ߤ�ذ��Ť���'; end
if ~isempty(strfind(schoolName, '�ùD����')), normalized='�p�߽ùD���Ť���'; end
if ~isempty(strfind(schoolName, '��۰��Ť���')), normalized='�p�ߺ�۰���'; end
if ~isempty(strfind(schoolName, '�ùD����')), normalized='�p�߽ùD���Ť���'; end

return
	
switch(schoolName)
	case '�ذ�'
		normalized='�O�_���߫ذ갪�Ť���';
	case '����'
		normalized='��ߪ������Ť���';
	case '����'
		normalized='�������߰������Ť���';
	case {'�x�n', '�O�n'}
		normalized='��߻O�n�Ĥ@���Ť���';
	case '�_��'
		normalized='��鿤�p�ߴ_������'
	case {'�v�j����', '�v�d�j�Ǫ��ݰ��Ť���'}
		normalized='��߻O�W�v�d�j�Ǫ��ݰ��Ť���';
	case '���\����'
		normalized='�O�_���ߦ��\���Ť���';
	case '���D'
		normalized='�p�ߩ��D���Ť���';
	case {'�_�@�k��', '�Ĥ@�k�l���Ť���'}
		normalized='�O�_���߲Ĥ@�k�l���Ť���';
	case '�x���@��'
		normalized='��߻O���Ĥ@���Ť���';
	case '�Z��'
		normalized='��ߪZ�����Ť���';
	case '��Ϲ���'
		normalized='��߬�Ǥu�~��Ϲ��簪�Ť���';
	case '����'
		normalized='�p�����հ��Ť���';
	case '���s'
		normalized='�x�_���ߤ��s�k�l���Ť���';
	case '�Q�s����'
		normalized='�O�_���ߪQ�s����';
	case '�s�ˤk��'
		normalized='��߷s�ˤk�l���Ť���';
	case '��������'
		normalized='�p�ߩ������Ť���';
	case '�j�P����'
		normalized='�x�_���ߤj�P���Ť���';
	case '�Ÿq����'
		normalized='��߹Ÿq���Ť���';
	case '��ذ���'
		normalized='��ߤ�ذ��Ť���';
	case '�ùD����'
		normalized='�p�߽ùD���Ť���';
	case '��۰��Ť���'
		normalized='�p�ߺ�۰���';
	otherwise
		normalized=schoolName;
	%	fprintf('No normalization for %s\n', schoolName);
end
