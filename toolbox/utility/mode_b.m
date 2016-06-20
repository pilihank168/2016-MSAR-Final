function [element, index] = mode(x)
%mode: Mode of a vector
%	Usage: [element, index] = mode(x)

%	Roger Jang, April-1-97

[sortedElement, count] = elementCount(x);
[junk, count_index] = max(count);
element = sortedElement(count_index);
index = find(x==element);