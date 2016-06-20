function [out, bestIndex]=arOrderSelect4id(sourceSig, targetSig, orders, showPlot)
% arOrderSelect: Determine the order of an auto regressive (AR) model for system identification
% 
%   Usage: 
%       [out, bestIndex]=arOrderSelect4id(sourceSig, targetSig, orders, showPlot)
%
%	Example:
%		load signal4id.mat
%		sourceSig(1:100)=[];
%		sourceSig=sourceSig(1:16000);
%		targetSig=targetSig(1:16000);
%		orders=100:100:1000;
%		[out, bestIndex]=arOrderSelect4id(sourceSig, targetSig, orders, 1);

%	Category: Least-squares estimate
%   Roger Jang, 20150825

if nargin<1, selfdemo; return; end
if nargin<3, orders=10:10:100; end

orderNum=length(orders);
for i=1:orderNum
	out(i).order=orders(i);
	fprintf('%d/%d: order=%d, time=', i, orderNum, orders(i));
	A=enframe(sourceSig(1:end-1), orders(i), orders(i)-1)';
	b=targetSig(orders(i)+1:end);
	myTic=tic;
%	[out(i).trainRmse, out(i).testRmse, out(i).coef]=lseTrainTest(A, b);
	[out(i).trainRmse, out(i).testRmse, out(i).coef]=lseTrainTest(A, b, 1:size(A,1)/2);
	out(i).time=toc(myTic);
	fprintf('%g sec\n', out(i).time);
end
[~, bestIndex]=min([out.testRmse]);
bestOrder=orders(bestIndex);

if showPlot
	figure;
	subplot(311); plot(orders, [out.trainRmse], '.-', orders, [out.testRmse], '.-'); grid on;
	line(orders(bestIndex), out(bestIndex).testRmse, 'color', 'r', 'marker', 'o');
	ylabel('RMSE'); title('RMSE vs. orders for system ID');
	legend({'Training RMSE', 'Test RMSE'});
	subplot(312); plot(orders, [out.time], '.-'); grid on;
	xlabel('Orders'); ylabel('Time (sec)'); title('Running time');
	subplot(313); plot(out(bestIndex).coef, '.-'); grid on
	title('The best coefficients for AR model');
	figure;
	subplot(411); plot(sourceSig); title('Source signal'); axis([-inf inf -1 1]);
	subplot(412); plot(targetSig); title('Target signal'); axis([-inf inf -1 1]);
	A=enframe(sourceSig(1:end-1), bestOrder, bestOrder-1)'; axis([-inf inf -1 1]);
	b=targetSig(bestOrder+1:end);
	predictedSig=A*out(bestIndex).coef;
	subplot(413); plot([nan*ones(bestOrder, 1); predictedSig]); title('Predicted signal');
	subplot(414); plot([nan*ones(bestOrder, 1); targetSig(bestOrder+1:end)-predictedSig]); title('Difference in target and predicted signal');  axis([-inf inf -1 1]);
end

function [trainRmse, testRmse, theta]=lseTrainTest(A, b, trainingIndex)
if nargin<3, trainingIndex=1:2:length(b); end
A1=A(trainingIndex, :); b1=b(trainingIndex);		% Training data
A2=A; A2(trainingIndex,:)=[]; b2=b; b2(trainingIndex)=[];	% Test data
theta=A1\b1;
trainRmse=norm(A1*theta-b1)/sqrt(size(A1,1));
testRmse =norm(A2*theta-b2)/sqrt(size(A2,1));

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
