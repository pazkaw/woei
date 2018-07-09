function ctwa = calculateTrueWindAngle(caws, cspeed, cawa)
% H3000 Instrument handbook
%% Taking the intersect of all timeseries data to synchronise data series
% caws
[sharedVals,idxsIntoCaws] = intersect(caws.time,intersect(cspeed.time,cawa.time));

% cspeed
[sharedVals,idxsIntoCspeed] = intersect(cspeed.time,intersect(caws.time,cawa.time));

% cawa
[sharedVals,idxsIntoCawa] = intersect(cawa.time,intersect(cspeed.time, caws.time));




%% Extract common data series
AWS = caws.data(idxsIntoCaws);
STW = cspeed.data(idxsIntoCspeed);
AWA = cawa.data(idxsIntoCawa);
ts = datestr(datetime(caws.TimeInfo.StartDate)+days(caws.time),'yyyy-mm-dd HH:MM:SS.FFF');
ts = ts(idxsIntoCaws,:);
Lwy = 0;

TWA = tand((AWS.*sind(AWA)+tand(Lwy)*STW)./(AWS.*cosd(AWA)-STW));
TWA(TWA>180) = TWA+180;

ctwa = timeseries(TWA,ts);