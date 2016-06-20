function needlePlot(data)
%needlePlot: Needle plots in 3D.
%	Usage: needlePlot(data)
%
%	Type "needle" for a self-demo.

%	Roger Jang, April-18-97, 20071009

if nargin == 0, selfdemo; return, end

x = data(:, 1);
y = data(:, 2);
z = data(:, 3);
figure
plot3(x, y, z, 'o');
bottom = min(z);
data_n = length(x);
for i = 1:data_n,
	line([x(i) x(i)], [y(i), y(i)], [bottom, z(i)], 'color', 'c');
end
axis([-inf inf -inf inf -inf inf]);
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Needle plot for data points');
set(gca, 'box', 'on');
%frot3d on
rotate3d on
hold on
plot(x, y);
hold off

%====== 2D interpolation
figure;
point_n = 21;
xi = linspace(min(x), max(x), point_n);
yi = linspace(min(y), max(y), point_n);
[xx, yy] = meshgrid(xi, yi);
[xx, yy, zz] = griddata(x, y, z, xx, yy);
mesh(xx, yy, zz);
hold on
plot3(x, y, z, 'o');
hold off
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Data points and 2D interpolation');
set(gca, 'box', 'on');
axis([-inf inf -inf inf -inf inf]);
%frot3d on
rotate3d on

%====== Contour
figure;
% Contour
contour(xx, yy, zz, 10);
hold on
line(x, y, 'linestyle', 'o');
hold off
xlabel('X'); ylabel('Y');
title('Data points and contours for 2D interpolation');
axis image

function selfdemo
t = linspace(0, 5*pi)';
x = t.*sin(t);
y = t.*cos(t);
z = t;
feval(mfilename, [x y z]);