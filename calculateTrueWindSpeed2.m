function [ctws, ctwd] = calculateTrueWindSpeed2(cawd, caws, ccourse, cspeed)
% http://davidburchnavigation.blogspot.nl/2013/04/true-true-wind-from-apparent-wind.html
%% Taking the intersect of all timeseries data to synchronise data series
% cawd
[sharedVals,idxsIntoCawd] = intersect(cawd.time,intersect(ccourse.time,intersect(caws.time, cspeed.time)));

% ccourse
[sharedVals,idxsIntoCcourse] = intersect(ccourse.time,intersect(cawd.time,intersect(caws.time,cspeed.time)));

% cspeed
[sharedVals,idxsIntoCspeed] = intersect(cspeed.time,intersect(ccourse.time, intersect(caws.time, cawd.time)));

% caws
[sharedVals,idxsIntoCaws] = intersect(caws.time,intersect(ccourse.time, intersect(cspeed.time, cawd.time)));


%% Extract common data series
awd = cawd.data(idxsIntoCawd);
aws = caws.data(idxsIntoCaws);
COG = ccourse.data(idxsIntoCcourse);
SOG = cspeed.data(idxsIntoCspeed);

ts = datestr(datetime(cawd.TimeInfo.StartDate)+days(cawd.time),'yyyy-mm-dd HH:MM:SS.FFF');
ts = ts(idxsIntoCawd,:);

%% Calculate true wind speed
u = SOG.*sind(COG) - aws.*sind(awd);
v = SOG.*cosd(COG) - awd.*cosd(awd);

tws = sqrt(u.*u + v.*v);
twd = atand(u ./v);

ctws = timeseries(tws,ts);
ctwd = timeseries(twd,ts);

