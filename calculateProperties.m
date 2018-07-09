function [ctws,ctwa,ctwd] = calculateProperties(caws, cspeed, cawa, ccourse)
% https://www.starpath.com/freeware/truewind.pdf, p. 11
%% Taking the intersect of all timeseries data to synchronise data series
% caws
[sharedVals,idxsIntoCaws] = intersect(caws.time,intersect(cspeed.time,intersect(ccourse.time,cawa.time)));

% cspeed
[sharedVals,idxsIntoCspeed] = intersect(cspeed.time,intersect(caws.time,intersect(ccourse.time,cawa.time)));

% cawa
[sharedVals,idxsIntoCawa] = intersect(cawa.time,intersect(cspeed.time,intersect(ccourse.time, caws.time)));

% ccourse
[sharedVals,idxsIntoCcourse] = intersect(ccourse.time,intersect(cspeed.time,intersect(cawa.time, caws.time)));

%% Extract common data series
S = caws.data(idxsIntoCaws)*3600/1852;
A = cspeed.data(idxsIntoCspeed)*3600/1852;
H = ccourse.data(idxsIntoCcourse);
alpha = cawa.data(idxsIntoCawa);
alpha = (alpha > 180).*(alpha-360)+alpha.*(alpha <= 180);

ts = datestr(datetime(caws.TimeInfo.StartDate)+days(caws.time),'yyyy-mm-dd HH:MM:SS.FFF');
ts = ts(idxsIntoCaws,:);

%% Calculate true wind speed
T = sqrt(S.^2+A.^2-2.*S.*A.*cosd(alpha));
beta = (A.^2-T.^2-S.^2)./(2.*T.*S);
theta = acosd(beta);
twa = theta;
twd = H - theta;

ctws = timeseries(T,ts);
ctwa = timeseries(twa,ts);
ctwd = timeseries(twd,ts);


