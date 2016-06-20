% Animation for 
%	1. Polynomial fitting
%	2. First, second, and third order Taylor expansion of a curve
%
% Roger Jang, June 3, 1996

x = linspace(1, 10, 10)';
y = [10 7 5 4 3.5 3.2 2 1 2 4]';
order = 9;
coef = polyfit(x, y, order);
xx = linspace(1, 10)';
yy = polyval(coef, xx);
limit = [min(x) max(x) min(y)-1 max(y)+1];

d_coef = [length(coef)-1:-1:1].*coef(1:length(coef)-1);
dd_coef = [length(d_coef)-1:-1:1].*d_coef(1:length(d_coef)-1);
ddd_coef = [length(dd_coef)-1:-1:1].*dd_coef(1:length(dd_coef)-1);

figure('name', 'Polynomial Fitting and Taylor Expansion', 'NumberTitle', 'off');
h = plot(x, y, 'o', xx, yy, '-');
set(h, 'linewidth', 2, 'erase', 'xor');
fitH = h(1);
curveH = h(2);
axis(limit);
title('Click and drag circles to change the curve.');
xlabel('Click and drag to see first, second, and third order approximation'); 

verticalH = line([nan nan], [min(y)-1 max(y)+1], 'erase', 'xor', 'color', 'w');
circleH = line(nan, nan, 'erase', 'xor', 'color', 'w', 'marker', 'o');
firstH = line(xx, nan*xx, 'erase', 'xor', 'color', 'g', 'linestyle', ':');
secondH = line(xx, nan*xx, 'erase', 'xor', 'color', 'c', 'linestyle', '-.');
thirdH = line(xx, nan*xx, 'erase', 'xor', 'color', 'r', 'linestyle', '--');
AxisH = gca; FigH = gcf;
curr_info = get(AxisH, 'CurrentPoint');
current_x = curr_info(1,1);

% The following is for animation

% action when button is first pushed down
action1 = ['curr_info=get(AxisH, ''currentPoint'');', ...
	'start_x=curr_info(1,1);', ...
	'start_y=curr_info(1,2);', ...
	'prev_y = start_y;', ...
	'[junk, index] = min(abs(start_x-x));'];
% actions after the mouse is pushed down
action2 = ['curr_info=get(AxisH, ''currentPoint'');', ...
	'curr_x=curr_info(1,1);', ...
	'curr_y=curr_info(1,2);', ...
	'y(index) = y(index)+curr_y-prev_y;', ...
	'prev_y = curr_y;', ...
	'set(fitH, ''ydata'', y);', ...
	'coef = polyfit(x, y, order);', ...
	'yy = polyval(coef, xx);', ...
	'set(curveH, ''ydata'', yy);', ...
	'd_coef = [length(coef)-1:-1:1].*coef(1:length(coef)-1);', ...
	'dd_coef = [length(d_coef)-1:-1:1].*d_coef(1:length(d_coef)-1);', ...
	'ddd_coef = [length(dd_coef)-1:-1:1].*dd_coef(1:length(dd_coef)-1);'];
% action when button is released
action3 = [];

% temporary storage for the recall in the down_action
set(AxisH,'UserData',action2);

% set action when the mouse is pushed down
down_action=[ ...
    'set(FigH,''WindowButtonMotionFcn'',get(AxisH,''UserData''));' ...
    action1];
set(FigH,'WindowButtonDownFcn',down_action);

% set action when the mouse is released
up_action=[ ...
    'set(FigH,''WindowButtonMotionFcn'','' '');', action3];
set(FigH,'WindowButtonUpFcn',up_action);
