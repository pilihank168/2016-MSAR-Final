function [yyyymmdd, time] = getDateTime
% getDate: Get date in yyyymmdd format
%	Usage: [yyyymmdd, time] = getDateTime
%
%	For example:
%		[yyyymmdd, time]=getDateTime

%	Roger Jang, 20050827

vec=datevec(now);
yyyymmdd=sprintf('%04d%02d%02d', vec(1), vec(2), vec(3));
time=sprintf('%02d%02d%02d', vec(4), vec(5), round(vec(6)));