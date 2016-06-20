function marker=getMarker(index)
% getMarker: Get marker from a rotating palette
%	Usage: marker=getMarker(index)
%
%	For example:
%		t=linspace(0, 2*pi, 21);
%		for i=1:13
%			line(t, sin(t)*i/13, 'marker', getMarker(i));
%		end

% Roger Jang, 20040910, 20071009

if nargin<1, index=1; end

allMarker={'^', 'o', 's', 'v', 'd', 'p', 'h', '*', 'x', '<', '>', '+', '.'};
marker=allMarker{mod(index-1, length(allMarker))+1};