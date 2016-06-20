function [aa, bb, rmse]=lsSolverAdditive(R, lambdaA, lambdaB, iterCount)
% lsSolverAdditive: LS solution to min tr(D*D')+lambdaA*aa'*aa+lambdaB*bb'*bb, where D=R-aa*ones(1,n)-ones(m,1)*bb';

if nargin<1, selfdemo; return; end
if nargin<2, lambdaA=1; end
if nargin<3, lambdaB=1; end
if nargin<4, iterCount=20; end

[m,n]=size(R);
Rs1=sum(R,1);
Rs2=sum(R,2);
aa=rand(m,1);
for i=1:iterCount
%	bb=sum(R-aa*ones(1,n), 1)'/(m+lambdaB);
	bb=(Rs1-sum(aa))'/(m+lambdaB);
%	aa=sum(R-ones(m,1)*bb', 2)/(n+lambdaA);
	aa=(Rs2-sum(bb))/(n+lambdaA);
	D=R-aa*ones(1,n)-ones(m,1)*bb';
	mse(i)=trace(D*D');
end
rmse=(mse/(m*n)).^0.5;
plot(rmse, 'o-');

% ====== Self demo
function selfdemo
m=3;
n=4;
R=rand(m,n);
[aa, bb, rmse]=lsSolverAdditive(R);
plot(rmse, 'o-');
