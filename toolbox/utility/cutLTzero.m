function [newPitch, cutIndex] = cutLTzero(pitch);
%CUTZERO Cut leading/trailing zeros of a pitch vector

newPitch = pitch;
idx = find(pitch~=0);
cutIndex = [];
if ~isempty(idx),
	index1 = 1:idx(1)-1;
	index2 = idx(end)+1:length(pitch);
	cutIndex = [index1, index2];
	newPitch(cutIndex)=[];
end
