%% loan
% 分期貸款的每月應附金額
%% Syntax
% * 		p=loan(total, r, n, mode)
% * 		total: 總金額，分期初或期末
% * 		r: 年利率
% * 		n: 總年數
% * 		p: 每月投入金額
% * 		mode: 'initial' for 期初總金額, 'final' for 期末總金額
%% Description
%
% <html>
% <p>loan is the inverse function of saving:
% 	<ul>
% 	<li>saving(loan(total, r, n), r, n, 'initial') returns total.
% 	<li>loan(saving(p, r, n, 'initial'), r, n) returns p.
% 	</ul>
% </html>
%% Example
%%
%
total=500;
r=3/100;
n=20;
p=loan(total, r, n);
fprintf('期初貸款總額=%.2f萬, 利率=%.2f%%, 期數=%d年, 月繳=%.2f萬\n', total, r*100, n, p);
%% See Also
% <saving_help.html saving>.
