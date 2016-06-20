function r=irrFind(cashFlowVec, x0, timeUnit4cashFlow, timeUnit4compounding)
%irrFind: Find IRR (Internal Rate of Return)
%
%	Usage:
%		r=irrFind(cashFlowVec, x0, timeUnit4cashFlow, timeUnit4compounding)
%
%	Description:
%		r=irrFind(cashFlowVec, x0, timeUnit4cashFlow, timeUnit4compounding) returns the IRR of a given investment plan
%			irr: Internal rate of return
%			cashFlowVec: Cash flow vector
%			x0: Initial guess of IRR, default to 0
%			timeUnit4cashFlow: Unit in month for cash flow, with the following possible values:
%				1: month
%				3: quarter
%				6: half year
%				12: year (default)
%			timeUnit4compounding: Time unit compounding, with the following possible values:
%				'month' (default) for monthly compounding
%				'year' for yearly compounding (which is a valid option only when timeUnit4cashFlow is 12)
%		Note that if timeUnit4cashFlow is not 12 and timeUnit4compounding is 'year', the function should return nan.
%
%	Example:


if nargin<1, selfdemo; return; end
if nargin<2, x0=0; end
if nargin<3, timeUnit4cashFlow=12; end
if nargin<4, timeUnit4compounding='month'; end

if timeUnit4cashFlow~=12 & strcmp(timeUnit4compounding, 'year'), r=nan; return; end
r=fzero(@npvCompute, x0);

	function npv=npvCompute(x)
		n=length(cashFlowVec);
		switch(timeUnit4compounding)
			case 'month'
				npv=sum(cashFlowVec./((1+x/12).^(timeUnit4cashFlow*(0:n-1))));		% Monthly compounding
			case 'year'
				npv=sum(cashFlowVec./((1+x).^(0:n-1)));		% Yearly compounding
		end
	end
end

% ====== Self demo
%function selfdemo
%mObj=mFileParse(which(mfilename));
%strEval(mObj.example);
%emd