function prob=transProb(A, i, k, j)

% �qA(i).candidate(k) ���� A(i+1).candidate(j) �����v

%prob=0; return
%prob=1/abs(A(i).candidate(k).index-A(i+1).candidate(j).index); return

% �ھ� pitch �Ӻ� transition probability
pitch1=A(i).candidate(k).pitch;
pitch2=A(i+1).candidate(j).pitch;
width=40;	% prob at x=width is equal to 0.5;
sigma=width/0.8326;
prob=-((pitch1-pitch2)/sigma)^2;	% Log prob. of Gaussian-like PDF

% �ھ� amdf �� local minima �� index �Ӻ� transition probability
index1=A(i).candidate(k).index;
index2=A(i+1).candidate(j).index;
width=10;	% prob at x=width is equal to 0.5;
sigma=width/0.8326;
prob=-((index1-index2)/sigma)^2;	% Log prob. of Gaussian-like PDF