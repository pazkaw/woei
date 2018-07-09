function cawd = calculateApparentWindDirection(ccourse, cawa)
% http://davidburchnavigation.blogspot.nl/2013/04/true-true-wind-from-apparent-wind.html
%% Taking the intersect of all timeseries data to synchronise data series
[sharedVals,idxsIntoCawa] = intersect(cawa.time, ccourse.time);
[sharedVals,idxsIntoCcourse] = intersect(ccourse.time,cawa.time);

%% Extract common data series
awa = cawa.data(idxsIntoCawa)-180;
H = ccourse.data(idxsIntoCcourse);

ts = datestr(datetime(ccourse.TimeInfo.StartDate)+days(ccourse.time),'yyyy-mm-dd HH:MM:SS.FFF');
ts = ts(idxsIntoCcourse,:);

%% Calculate apparent wind direction
awd = H + awa;

cawd = timeseries(awd,ts);


