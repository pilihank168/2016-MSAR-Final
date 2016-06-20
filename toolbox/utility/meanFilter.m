function out = meanFilter(in, opt, plotOpt)
%meanFilter: Mean filter for a given order
%
%	Usage:
%		out = meanFilter(in, order)
%
%	Example:
%		n=20;
%		in=round(10*rand(1, n));
%		opt=meanFilter('defaultOpt');
%		opt.order=3;
%		subplot(2,1,1); out1=meanFilter(in, opt, 1);
%		opt.order=5;
%		opt.edgeMode='sharp';
%		subplot(2,1,2); out2=meanFilter(in, opt, 1);

%	Roger Jang, 20040424, 20140419

if nargin<1, selfdemo; return; end
% ====== Set the default options
if nargin==1 && ischar(in) && strcmpi(in, 'defaultOpt')
	out.order=3;
	out.edgeMode='progressive';
	return
end
if nargin<2|isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, plotOpt=0; end

if ~isstruct(opt)
	order=opt;
	clear opt;
	opt.order=order;
	opt.edgeMode='progressive';
end

side=fix(opt.order/2);
out=in;
for i=(side+1):length(in)-side
	out(i)=mean(in((i-side):(i+side)));
end

if strcmpi(opt.edgeMode, 'progressive')
	for i=1:side
		out(i)=mean(in(1:side+i));
	end
	for i=length(in)-side+1:length(in)
		out(i)=mean(in(i-side:end));
	end
end

if plotOpt
	plot(1:length(in), in, '-o', 1:length(out), out, '-o');
	legend('Original', 'After meanFilter');
	title(sprintf('order=%d, edgeMode=%s', opt.order, opt.edgeMode));
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
