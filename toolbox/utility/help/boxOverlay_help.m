%% boxOverlay
% Overlay a bounding box
%% Syntax
% * 		boxOverlay(bb, color, width, textString, textPos)
%% Description
%
% <html>
% <p>boxOverlay(bb, color, width, textString, textPos)
% 	<ul>
% 	<li>bb: Bounding box ([x, y, w, h], as return by stats(i),BoundingBox, where x is the distance to the leftmost boundary and y is the distance to the upper boundary)
% 	<li>color: Color
% 	<li>width: Width of the line for drawing the bounding box
% 	<li>textString: String for display along the bounding box
% 	<li>textPos: text position, either 'up' or 'down'
% 	</ul>
% </html>
%% Example
%%
% Example 1
BW=[1 1 1 0 0 0 0 0;1 0 1 0 1 1 0 0;1 1 1 0 1 1 0 0;0 0 0 0 0 0 1 0;1 1 1 0 0 0 1 0;1 0 1 0 0 0 1 0;1 0 1 0 0 1 1 0;1 1 0 0 0 0 0 0];
objLabel=bwlabel(BW, 4);
stats=regionprops(objLabel);
figure;
subplot(121); imshow(BW);
subplot(122); imagesc(objLabel); axis image; colorbar
for i=1:length(stats)
	boxOverlay(stats(i).BoundingBox, getColor(i), 1, int2str(i), 'bottom');
end
%%
% Example 2
BW=imread('text.png');
objLabel=bwlabel(BW);
stats=regionprops(objLabel);
figure; imagesc(objLabel); axis image; colorbar
for i=1:length(stats)
	boxOverlay(stats(i).BoundingBox, getColor(i), 1, int2str(i), 'left');
end
