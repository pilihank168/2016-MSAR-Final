function index = localMax(x, method, showPlot)
% LOCALMAX Find local maxima of a vector
%
%	Usage:
%		index = localMax(x, method, showPlot)
%			x: Input vector, or a matrix
%			method: a string to specify how to handle the first and last elements
%				'keepBoth' to keep the first and last elemetns if they are local max.
%				'keepFirst' to keep the first element if it is a local max.
%				'keepLast' to keep the last element if it is a local max.
%				'keepNone' to keep neither the first nor the last elements (default)
%			index: A 0-1 index vector indicating where the local maxima are.
%			showPlot: 1 for plotting
%
%	Example:
%		t = 0:0.2:2*pi;
%		x = sin(t)+randn(size(t));
%		method = 'keepBoth';
%		index = localMax(x, method, 1);

%	Roger Jang, 1999, 20071009, 20130707

if nargin<1, selfdemo; return; end
if nargin<2||isempty(method), method='keepNone'; end
if nargin<3, showPlot=0; end

[dim1, dim2]=size(x);
if dim1==1 || dim2==1	% x is a vector
	b1 = x(2:end-1)>x(1:end-2);
	b2 = x(2:end-1)>x(3:end);
	index = 0*x;
	index(2:end-1) = b1 & b2;
	if strcmp(method, 'keepFirst') | strcmp(method, 'keepBoth')
		index(1)=x(1)>x(2);
	end
	if strcmp(method, 'keepLast') | strcmp(method, 'keepBoth')
		index(end)=x(end)>x(end-1);
	end
	index=logical(index);
else		% x is a matrix
	b1 = x(2:end-1,:)>x(1:end-2,:);
	b2 = x(2:end-1,:)>x(3:end,:);
	index = 0*x;
	index(2:end-1,:) = b1 & b2;
	if strcmp(method, 'keepFirst') | strcmp(method, 'keepBoth')
		index(1,:)=x(1,:)>x(2,:);
	end
	if strcmp(method, 'keepLast') | strcmp(method, 'keepBoth')
		index(end,:)=x(end,:)>x(end-1,:);
	end
	index=logical(index);
end

if showPlot
	if dim1==1 || dim2==1	% x is a vector
		time = 1:length(x);
		plot(time, x, time(logical(index)), x(logical(index)), 'ro');
	else
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
