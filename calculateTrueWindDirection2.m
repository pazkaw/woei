function [ctws, ctwd] = calculateTrueWindDirection2(cawa, caws, ccourse, cspeed)
%% Taking the intersect of all timeseries data to synchronise data series
% cawd
[sharedVals,idxsIntoCawa] = intersect(cawa.time,intersect(ccourse.time,intersect(caws.time, cspeed.time)));

% ccourse
[sharedVals,idxsIntoCcourse] = intersect(ccourse.time,intersect(cawa.time,intersect(caws.time,cspeed.time)));

% cspeed
[sharedVals,idxsIntoCspeed] = intersect(cspeed.time,intersect(ccourse.time, intersect(caws.time, cawa.time)));

% caws
[sharedVals,idxsIntoCaws] = intersect(caws.time,intersect(ccourse.time, intersect(cspeed.time, cawa.time)));


%% Extract common data series
awa = cawa.data(idxsIntoCawa);
aws = caws.data(idxsIntoCaws)*3600/1852;     % Apparent wind speed in knots              
COG = ccourse.data(idxsIntoCcourse)*pi/180;  % Course over ground (0-360)
SOG = cspeed.data(idxsIntoCspeed)*3600/1852; % Speed over ground in knots (=Nautical miles/hour)
awa = (awa > 180).*(awa-360)+awa.*(awa <= 180);
awd = COG + awa*pi/180;

ts = datestr(datetime(cawa.TimeInfo.StartDate)+days(cawa.time),'yyyy-mm-dd HH:MM:SS.FFF');
ts = ts(idxsIntoCawa,:);

%% Calculate true wind speed
u = SOG.*sin(COG) - aws.*sind(awd);
v = SOG.*cos(COG) - awd.*cosd(awd);

tws = sqrt(u.*u + v.*v);
twd = atand(u ./v);

if(v > 0)
    twd = 180+twd;
end

ctws = timeseries(tws,ts);
ctwd = timeseries(twd,ts);
