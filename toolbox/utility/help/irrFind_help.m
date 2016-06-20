%% irrFind
% Find IRR (Internal Rate of Return)
%% Syntax
% * 		r=irrFind(cashFlowVec, x0, timeUnit4cashFlow, timeUnit4compounding)
%% Description
%
% <html>
% <p>r=irrFind(cashFlowVec, x0, timeUnit4cashFlow, timeUnit4compounding) returns the IRR of a given investment plan
% 	<ul>
% 	<li>irr: Internal rate of return
% 	<li>cashFlowVec: Cash flow vector
% 	<li>x0: Initial guess of IRR, default to 0
% 	<li>timeUnit4cashFlow: Unit in month for cash flow, with the following possible values:
% 		<ul>
% 		<li>1: month
% 		<li>3: quarter
% 		<li>6: half year
% 		<li>12: year (default)
% 		</ul>
% 	<li>timeUnit4compounding: Time unit compounding, with the following possible values:
% 		<ul>
% 		<li>'month' (default) for monthly compounding
% 		<li>'year' for yearly compounding (which is a valid option only when timeUnit4cashFlow is 12)
% 		</ul>
% 	</ul>
% <p>Note that if timeUnit4cashFlow is not 12 and timeUnit4compounding is 'year', the function should return nan.
% </html>
