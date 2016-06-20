%% distPoint2circle
% Distance between a set of points to a set of circles
%% Syntax
% * 		distMat=distPoint2circle(points, circles)
%% Description
%
% <html>
% <p>distMat=distPoint2circle(points, circles) returns the distance matrix between a set of points and a set of circles
% 	<ul>
% 	<li>points: A set of points, with each column being a point
% 	<li>circles: A set of circles, with each column being a circle (center and radius)
% 	<li>distMat: The returned distance matrix
% 	</ul>
% </html>
%% Example
%%
%
points=[1 2; 3 4; 2 5; 3 6]';
circles=[1 3 4; 2 5 3; 2 6 5]';
distMat=distPoint2circle(points, circles);
disp('points='); disp(points);
disp('circles='); disp(circles);
disp('distMat='); disp(distMat);
