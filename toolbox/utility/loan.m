function [p, finalTotalValue]=loan(total, r, n, mode)
% load: �����U�ڪ��C���������B
%
%	Usage:
%		p=loan(total, r, n, mode)
%		total: �`���B�A������δ���
%		r: �~�Q�v
%		n: �`�~��
%		p: �C���J���B
%		mode: 'initial' for �����`���B, 'final' for �����`���B
%
%	Description:
%		loan is the inverse function of saving:
%			saving(loan(total, r, n), r, n, 'initial') returns total.
%			loan(saving(p, r, n, 'initial'), r, n) returns p.
%
%	Example:
%		total=500;
%		r=3/100;
%		n=20;
%		p=loan(total, r, n);
%		fprintf('����U���`�B=%.2f�U, �Q�v=%.2f%%, ����=%d�~, ��ú=%.2f�U\n', total, r*100, n, p);
%
%	See also saving.

%	Roger Jang, 20070504

if nargin<1, selfdemo; return; end
if nargin<4, mode='initial'; end

switch(mode)
	case 'initial'
		finalTotalValue=total*(1+r/12)^(12*n);
	case 'final'
		finalTotalValue=total;
	otherwise
		error('Unknown mode=%s', mode);
end
p=finalTotalValue/(((1+r/12)^(12*n)-1)/(r/12));

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
