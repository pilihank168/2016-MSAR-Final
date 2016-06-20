function [p, finalTotalValue]=loan(total, r, n, mode)
% load: 分期貸款的每月應附金額
%
%	Usage:
%		p=loan(total, r, n, mode)
%		total: 總金額，分期初或期末
%		r: 年利率
%		n: 總年數
%		p: 每月投入金額
%		mode: 'initial' for 期初總金額, 'final' for 期末總金額
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
%		fprintf('期初貸款總額=%.2f萬, 利率=%.2f%%, 期數=%d年, 月繳=%.2f萬\n', total, r*100, n, p);
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
