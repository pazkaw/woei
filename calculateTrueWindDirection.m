function [ctws, ctwd] = calculateTrueWindDirection(cawd, caws, ccourse, cspeed)
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
aws = caws.data(idxsIntoCaws)*3600/1852;     % Apparent wind speed in knots              
COG = ccourse.data(idxsIntoCcourse)*pi/180;  % Course over ground (0-360)
SOG = cspeed.data(idxsIntoCspeed)*3600/1852; % Speed over ground in knots (=Nautical miles/hour)

ts = datestr(datetime(cawd.TimeInfo.StartDate)+days(cawd.time),'yyyy-mm-dd HH:MM:SS.FFF');
ts = ts(idxsIntoCawd,:);

%% Calculate true wind speed
u = SOG.*sin(COG) - aws.*sind(awd);
v = SOG.*cos(COG) - awd.*cosd(awd);

tws = sqrt(u.*u + v.*v);
twd = atand(u ./v);

ctws = timeseries(tws,ts);
ctwd = timeseries(twd,ts);

