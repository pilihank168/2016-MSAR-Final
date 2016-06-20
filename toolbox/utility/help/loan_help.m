%% loan
% �����U�ڪ��C���������B
%% Syntax
% * 		p=loan(total, r, n, mode)
% * 		total: �`���B�A������δ���
% * 		r: �~�Q�v
% * 		n: �`�~��
% * 		p: �C���J���B
% * 		mode: 'initial' for �����`���B, 'final' for �����`���B
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
fprintf('����U���`�B=%.2f�U, �Q�v=%.2f%%, ����=%d�~, ��ú=%.2f�U\n', total, r*100, n, p);
%% See Also
% <saving_help.html saving>.
